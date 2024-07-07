import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/screen/homepage.dart';
import 'package:flutter_application_to_do_app/screen/loginpage.dart';
import 'package:flutter_application_to_do_app/screen/signuppage.dart';
import 'package:flutter_application_to_do_app/service/apiserice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = AuthService();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Auth',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<bool>(
        future: _authService.isSignedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return HomePage();
            } else {
              return const LoginPage();
            }
          }
          return const CircularProgressIndicator();
        },
      ),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => HomePage(),
      },
    );
  }
}
