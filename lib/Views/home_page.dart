import 'package:app/Views/otp_page.dart';
import 'package:flag/flag_enum.dart';
import 'package:flag/flag_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController phoneNumber = TextEditingController();
  String? errorMessage;
  bool isLoading = false; // Track loading state

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _verifyPhoneNumber() async {
    final phone = '+91${phoneNumber.text}';

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
          setState(() {
            isLoading = false;           });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            errorMessage = 'Verification failed. Please try again.';
            isLoading = false;
          });
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            isLoading = false;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                phone: phone,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            isLoading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error occurred: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Please enter your mobile number',
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 16.0),
          const Text(
            'You\'ll receive a 6 digit code to verify next.',
            style: TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 32.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(width: 24.0),
                    Flag.fromCode(FlagsCode.IN, height: 24.0, width: 32.0),
                    const SizedBox(width: 8.0),
                    const Text('+91'),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        controller: phoneNumber,
                        maxLength: 10,
                        maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        decoration: const InputDecoration(
                          hintText: 'Mobile Number',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF2E3B62), width: 2.0),
                          ),
                          counterText: '',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                  ],
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ElevatedButton(
              onPressed: isLoading
                  ? null // Disable button when loading
                  : () {
                if (phoneNumber.text.length == 10) {
                  setState(() {
                    errorMessage = null;
                  });
                  _verifyPhoneNumber();
                } else {
                  setState(() {
                    errorMessage = 'Please enter a valid 10-digit mobile number';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3B62),
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              )
                  : const Text('CONTINUE', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}
