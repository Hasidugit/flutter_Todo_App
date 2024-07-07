import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_to_do_app/screen/loginpage.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const LoginPage(),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
            ),
            const Image(image: AssetImage("image/to_do.png")),
            const SizedBox(
              height: 10,
            ),
            const CircularProgressIndicator(
              color: Colors.blue,
              strokeWidth: 5,
            ),
            const Spacer(),
            Text(
              "heloTech...",
              style: GoogleFonts.ibmPlexSans(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
