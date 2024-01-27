import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled15/routes.dart';
import 'package:untitled15/screens/init_screen.dart';
import 'package:untitled15/screens/splash/splash_screen.dart';
import 'package:untitled15/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool rememberMe = prefs.getBool('rememberMe') ?? false;

  runApp(MyApp(rememberMe: rememberMe));
}

class MyApp extends StatelessWidget {
  final bool rememberMe;

  const MyApp({Key? key, required this.rememberMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isFirstTime = !rememberMe;

    return MaterialApp(
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const InitScreen(),
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Project lập trình ứng dụng di động K2N2',
      theme: AppTheme.lightTheme(context),
      initialRoute: isFirstTime
          ? SplashScreen.routeName
          : (rememberMe ? InitScreen.routeName : SplashScreen.routeName), // Change this line
      routes: {
        ...routes,  // Use the routes map you've defined
      },
    );
  }
}
