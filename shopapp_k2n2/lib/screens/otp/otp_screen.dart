import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants.dart';
import '../sign_in/sign_in_screen.dart';

class OtpScreen extends StatelessWidget {
  static String routeName = "/otp";

  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                const Text(
                  "OTP Verification",
                  style: headingStyle,
                ),
                const Text("Chúng tôi đã gửi đến hòm thư email của bạn"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Hãy truy cập đường link để hoàn tất"),
                    TweenAnimationBuilder(
                      tween: Tween(begin: 90.0, end: 0.0),
                      duration: const Duration(seconds: 90),
                      builder: (_, dynamic value, child) => Text(
                        "00:${value.toInt()}",
                        style: const TextStyle(color: kPrimaryColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 200),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.currentUser?.reload();
                    if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
                      Navigator.pushNamed(context, SignInScreen.routeName);
                    } else {
                      // Email is not verified
                      // You can show an error message or prompt the user to resend OTP
                    }
                  },
                  child: const Text("Verify OTP"),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
                  },
                  child: const Text(
                    "Resend OTP Code",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
