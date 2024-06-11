import 'package:afriqmarkethub/components/rounded_button.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class OnboardingTemplate extends StatelessWidget {
  OnboardingTemplate(
      {super.key,
      required this.onBoardingImage,
      required this.heading,
      required this.decsription,
      required this.onPressed,
      required this.buttonTitle});
  final String onBoardingImage;
  final String heading;
  final String decsription;
  final VoidCallback onPressed;
  String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            onBoardingImage,
            scale: 1,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    heading,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  decsription,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SizedBox(
                      height: 50,
                      child: RoundedButton(
                          text: buttonTitle,
                          onPressed: onPressed,
                          Color: Colors.black),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
