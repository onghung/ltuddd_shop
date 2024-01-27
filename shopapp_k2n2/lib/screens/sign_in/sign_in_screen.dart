import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import '../home/home_screen.dart';
import '../init_screen.dart';
import '../login_success/login_success_screen.dart';
import 'components/sign_form.dart';


class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";

  const SignInScreen({Key? key}) : super(key: key);

  Future<bool> getRememberMePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('rememberMe') ?? false;
  }

  void navigateBasedOnRememberMe(BuildContext context) async {
    bool rememberMe = await getRememberMePreference();
    if (rememberMe) {
      Navigator.pushNamed(context, InitScreen.routeName);
    } else {
      Navigator.pushNamed(context, LoginSuccessScreen.routeName);
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Sign In"),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Chào mừng trở lại",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Đăng nhập bằng email và mật khẩu  \nhoặc tiếp tục với tài khoản mạng xã hội của bạn",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SignForm(onContinuePressed: () {
                      navigateBasedOnRememberMe(context);
                    }),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocalCard(
                          icon: "assets/icons/google-icon.svg",
                          press: () {},
                        ),
                        SocalCard(
                          icon: "assets/icons/facebook-2.svg",
                          press: () {},
                        ),
                        SocalCard(
                          icon: "assets/icons/twitter.svg",
                          press: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const NoAccountText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
