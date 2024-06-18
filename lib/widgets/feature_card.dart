import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  final String heading;
  final String description;
  final Color textColor;
  final Color cardColor;
  const FeatureCard({
    super.key,
    required this.heading,
    required this.description,
    required this.textColor,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 5,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 25,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: cardColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                heading,
                style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              description,
              style: TextStyle(color: textColor, fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}
