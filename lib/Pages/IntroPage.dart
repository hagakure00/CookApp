import 'dart:async';
import 'package:cook/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../main.dart';



class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      setState(() {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MainPage()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 150,bottom: 0),
              child: SizedBox(
                height:200,
                child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,),
              ),
            ),
            Text("Application de recette de cuisine",
                style: GoogleFonts.oswald(textStyle: const TextStyle(color: black,fontSize: 18,letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
            SizedBox(
              width: MediaQuery.of(context).size.width - 50,
              child: Center(
                child: Text("enregistrer et partager vos recetttes",
                    style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 14,height: 2,decoration: TextDecoration.none))),
              ),
            ),
            const SizedBox(height: 100),
            const SpinKitRipple(color: primary, size: 100.0)
          ],
        )
    );
  }
}
