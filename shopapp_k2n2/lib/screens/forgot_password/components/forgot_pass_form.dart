import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled15/screens/sign_in/sign_in_screen.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../components/no_account_text.dart';
import '../../../constants.dart';

class ForgotPassForm extends StatefulWidget {
  const ForgotPassForm({Key? key}) : super(key: key);

  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  late TextEditingController emailController;
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            onChanged: (value) {
              handleInputChanges(value);
            },
            validator: (value) {
              return validateEmail(value);
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Nhập email của bạn",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(height: 8),

          FormError(errors: errors),
          SizedBox(height: 8),

          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                handleContinuePressed(context);
              }
            },
            child: const Text("Tiếp tục"),
          ),
          SizedBox(height: 16),

          NoAccountText(),
        ],
      ),
    );
  }

  void handleInputChanges(String value) {
    if (value.isNotEmpty && errors.contains(kEmailNullError)) {
      setState(() {
        errors.remove(kEmailNullError);
      });
    } else if (emailValidatorRegExp.hasMatch(value) &&
        errors.contains(kInvalidEmailError)) {
      setState(() {
        errors.remove(kInvalidEmailError);
      });
    }
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty && !errors.contains(kEmailNullError)) {
      setState(() {
        errors.add(kEmailNullError);
      });
      return null;
    } else if (!emailValidatorRegExp.hasMatch(value) &&
        !errors.contains(kInvalidEmailError)) {
      setState(() {
        errors.add(kInvalidEmailError);
      });
      return null;
    }
    return null;
  }

  void handleContinuePressed(BuildContext context) async {
    try {
      String enteredEmail = emailController.text;
      await FirebaseAuth.instance.sendPasswordResetEmail(email: enteredEmail);

      // Display a success popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Thành công"),
            content: Text("Yêu cầu đặt lại mật khẩu đã được gửi tới $enteredEmail"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, SignInScreen.routeName);
                },
                child: Text("Đồng ý"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error sending password reset email: $e');
      // Display an error popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Error sending password reset email."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the popup
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }
}
