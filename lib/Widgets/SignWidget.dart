import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Animation/FadeAnimation.dart';
import 'package:cook/Theme/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HelpMessage.dart';

class SignWidget extends StatefulWidget {
  const SignWidget({Key? key, required this.onClickedLogIn}) : super(key: key);

  final Function() onClickedLogIn;

  @override
  _SignWidgetState createState() => _SignWidgetState();
}

class _SignWidgetState extends State<SignWidget> {

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool isHiddenPass = true;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: FadeAnimation(
                delay: 200,
                isHorizontal: true,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(children: [
                    buildHeader(),
                    const SizedBox(height: 30),
                    buildName(),
                    const SizedBox(height: 30),
                    buildEmail(),
                    const SizedBox(height: 30),
                    buildPass(),
                    const SizedBox(height: 40),
                    buildButton()
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future sign() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim());
      final message = 'Inscription reussi !  Bienvenue ${nameController.text.trim()}';
      final snackBar = SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 14),
          ), backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      final user =  FirebaseAuth.instance.currentUser!;

      await firebaseFirestore.collection('UserRecette').doc(user.uid).set({
        'name': nameController.text,
        'numberPost': 0,
        'photoURL': 'https://firebasestorage.googleapis.com/v0/b/app-perso-c2a3d.appspot.com/o/image.jpg?alt=media&token=1ca8866e-37f1-4841-9b76-56d7d53e0591',
        'id': user.uid,
      });
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      HelpMessage.showSnackBar(e.message);
    }
  }

  Widget buildHeader() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 50,bottom: 0),
        child: SizedBox(
          height:200,
          child: Image.asset("assets/images/logo.png",fit: BoxFit.cover,),
        ),
      ),
    ],
  );

  Widget buildName () => TextFormField(
      decoration: InputDecoration(
        labelText: "Nom",
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 0.0)),
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        prefixIcon: const Icon(Icons.person, color: primary,size: 20),
      ),
      style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      cursorColor: primary,
      controller: nameController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => value!.isEmpty ? "nom requis" : null,
  );

  Widget buildEmail () => TextFormField(
    decoration: InputDecoration(
      labelText: "Email",
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      fillColor: Colors.grey.withOpacity(0.1),
      filled: true,
      prefixIcon: const Icon(Icons.email, color: primary,size: 20),
    ),
      style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.done,
    cursorColor: primary,
    controller: emailController,
    autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) {
        const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
        final regExp = RegExp(pattern);

       if (!regExp.hasMatch(email!) && email.isEmpty) {
          return 'Email valide requis';
        } else if (!EmailValidator.validate(email)) {
          return null;
        }
      }
  );

  Widget buildPass () => TextFormField(
    decoration: InputDecoration(
      labelText: "Mot de passe",
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
        fillColor: Colors.grey.withOpacity(0.1),
      filled: true,
      prefixIcon: const Icon(Icons.lock, color: primary,size: 20),
        suffixIcon: InkWell(
          onTap: _togglePass,
          child: (isHiddenPass == true) ? const Icon(Icons.visibility,color: grey,size: 18) : const Icon(Icons.visibility_off,color: grey,size: 18),
        )
    ),
    style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
    keyboardType: TextInputType.visiblePassword,
    textInputAction: TextInputAction.done,
    cursorColor: primary,
    obscureText: isHiddenPass,
    controller: passController,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) => value != null && value.length <  6 ? "6 caractères minimum" : null,

  );


  Widget buildButton () => (MediaQuery.of(context).size.width > 370)
      ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // button inscription
        ElevatedButton(
          onPressed: () async {},
          style: ElevatedButton.styleFrom(primary: white),
          child: RichText(
              text: TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = widget.onClickedLogIn,
                  text: 'Déja un compte ?  ',
                  style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = widget.onClickedLogIn,
                        text: "Se connecter",
                      style: GoogleFonts.poppins( textStyle: const TextStyle(color: primary,fontSize: 13,decoration: TextDecoration.none)),
                    )])),
        ),

        // button inscription
        ElevatedButton(
            onPressed: () async {
              sign();
            },
            style: ElevatedButton.styleFrom(primary: primary),
            child: Text("S'inscrire",style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
        )])
      : Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // button inscription
        ElevatedButton(
          onPressed: () async {},
          style: ElevatedButton.styleFrom(primary: white),
          child: RichText(
              text: TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = widget.onClickedLogIn,
                  text: 'Déja un compte ?  ',
                  style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = widget.onClickedLogIn,
                      text: "Se connecter",
                      style: GoogleFonts.poppins( textStyle: const TextStyle(color: primary,fontSize: 13,decoration: TextDecoration.none)),
                    )])),
        ),
        const SizedBox(height: 10),
        // button inscription
        ElevatedButton(
            onPressed: () async {
              sign();
            },
            style: ElevatedButton.styleFrom(primary: primary),
            child: Text("S'inscrire",style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
        )]);

  void _togglePass() {
    setState(() {
      isHiddenPass = !isHiddenPass;
    });
  }


}