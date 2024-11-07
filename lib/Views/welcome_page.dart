import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
            width: 250.0,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 30.0,
                fontFamily: 'Agne',
                color: Colors.black
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('Phone Number Verified'),
                ],
              ),
            ),
          )
      ),
    );
  }
}
