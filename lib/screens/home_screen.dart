import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:nexa/openai_service.dart';
import 'package:nexa/widgets/feature_card.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechToText speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade600,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Nexa ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.yellow.shade600,
              ),
            ),
            const Text(
              'Assist',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        leading: const Icon(
          Icons.menu,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 135,
                    width: 135,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Container(
                  height: 130,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/virtual_assistant_image.png'),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: generatedImageUrl == null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    generatedContent == null
                        ? 'Hi, I am Nexa. What can I do for you?'
                        : generatedContent!,
                    style: TextStyle(
                      fontSize: generatedContent == null ? 20 : 17,
                    ),
                  ),
                ),
              ),
            ),
            if (generatedImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(generatedImageUrl!)),
              ),

            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Here are some features',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null,
              child: Column(
                children: [
                  FeatureCard(
                    heading: 'ChatGPT',
                    description:
                        'A smarter way to stay organized and informed with ChatGPT',
                    textColor: Colors.black,
                    cardColor: Colors.yellow.shade600,
                  ),
                  FeatureCard(
                    heading: 'Dall-E',
                    description:
                        'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    textColor: Colors.yellow.shade600,
                    cardColor: Colors.black,
                  ),
                  FeatureCard(
                    heading: 'Smart Voice Assistant',
                    description:
                        'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                    textColor: Colors.black,
                    cardColor: Colors.yellow.shade600,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), // Add some spacing before the FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isGenerateImagePrompt(lastWords);
            if (speech.contains('http')) {
              generatedImageUrl = speech;
              generatedContent = null;
              setState(() {});
            } else {
              generatedContent = speech;
              generatedImageUrl = null;
              setState(() {});
              await systemSpeak(speech);
            }

            await stopListening();
          } else {
            initSpeechToText();
          }
        },
        child: Icon(
          speechToText.isListening ? Icons.stop : Icons.mic,
          color: Colors.red,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
