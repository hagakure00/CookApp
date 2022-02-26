import 'package:cook/Animation/FadeAnimation.dart';
import 'package:cook/Theme/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HelpMessage.dart';



class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key, required this.onClickedSignUp}) : super(key: key);

  final VoidCallback onClickedSignUp;

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {


  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final emailVerifController = TextEditingController();
  final passController = TextEditingController();

  bool isHiddenPass = true;


  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    emailVerifController.dispose();
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
                  padding: const EdgeInsets.all(30.0),
                  child: Column(children: [
                    buildHeader(),
                    const SizedBox(height: 30),
                    buildEmail(),
                    const SizedBox(height: 30),
                    buildPass(),
                    buildPassPerdu(),
                    const SizedBox(height: 30),
                    buildButton(),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }



  Future loginIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passController.text.trim());
      final message = 'Connection réussi avec le compte : ${emailController.text.trim()}';
      final snackBar = SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 14),
          ), backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.done,
    cursorColor: primary,
    obscureText: isHiddenPass,
    controller: passController,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    validator: (value) => value != null && value.length <  6 ? "6 caractères minimum" : null,
  );

  Widget buildPassPerdu () => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            passPerduDialog(context);
          },
          child: SizedBox(
            height: 24,
            child: Text('Mot de passe perdu ?',
              style: GoogleFonts.poppins( textStyle: const TextStyle(color: primary,fontSize: 13,decoration: TextDecoration.none))),
          ),
        ),
      ),
    ],
  );

  Widget buildButton() => (MediaQuery.of(context).size.width > 370)
      ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // button inscription
      ElevatedButton(
        onPressed: () async {},
        style: ElevatedButton.styleFrom(primary: white),
        child: RichText(
            text: TextSpan(
                recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
                text: 'pas de compte ?  ',
                style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
                children: [
                  TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
                      text: "S'inscrire",
                      style: GoogleFonts.poppins( textStyle: const TextStyle(color: primary,fontSize: 13,decoration: TextDecoration.none)),
                  )])),
      ),
      // button connection
      ElevatedButton(
          onPressed: () async {
            loginIn();
          },
          style: ElevatedButton.styleFrom(primary: primary),
          child: Text("Se Connecter", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
      ),])
      : Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // button inscription
          ElevatedButton(
            onPressed: () async {},
            style: ElevatedButton.styleFrom(primary: white),
            child: RichText(
                text: TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
                    text: 'pas de compte ?  ',
                    style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()..onTap = widget.onClickedSignUp,
                        text: "S'inscrire",
                        style: GoogleFonts.poppins( textStyle: const TextStyle(color: primary,fontSize: 13,decoration: TextDecoration.none)),
                      )])),
          ),
          const SizedBox(height: 10),
          // button connection
          ElevatedButton(
              onPressed: () async {
                loginIn();
              },
              style: ElevatedButton.styleFrom(primary: primary),
              child: Text("Se Connecter", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
          ),

        ],
      );

  passPerduDialog(BuildContext context) {
    return showDialog(context: context, builder: (context){
      return  Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black54,blurRadius: 10.0, offset: Offset(0.0, 10.0))
                  ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text("Mot de passe Perdu", style: GoogleFonts.oswald( textStyle: const TextStyle(color: primary,fontSize: 18,decoration: TextDecoration.none))),
                  const SizedBox(height: 20),
                  Text("un mail vous sera envoyer pour réinitialiser votre mot de passe ...", style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none))),
                  const SizedBox(height: 30),


                  // textformfield
                  TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: primary, width: 1.0)),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: Icon(Icons.email, color: primary,size: 20),
                      ),
                      style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      cursorColor: primary,
                      controller: emailVerifController,
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
                  ),

                  const SizedBox(height: 30),

                  // button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () async {Navigator.of(context).pop();},
                          style: ElevatedButton.styleFrom(primary: white),
                          child: Text("Retour",style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),)
                      ),

                      ElevatedButton(
                          onPressed: () async {
                            verifyEmail();
                            emailVerifController.clear();
                          },
                          style: ElevatedButton.styleFrom(primary: primary),
                          child: Text("Envoyer",style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
                      ),
                    ],
                  )

                ],
              ),
            )
          ],
        ),
      );
    });
  }

  verifyEmail() async {
    try {
      FirebaseAuth.instance.sendPasswordResetEmail(email: emailVerifController.text.trim());
      final message = 'Verifier votre boite mail : ${emailVerifController.text.trim()}';
      final snackBar = SnackBar(
          content: Text(message, style: const TextStyle(fontSize: 14),
          ), backgroundColor: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      HelpMessage.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
  
  void _togglePass() {
    setState(() {
      isHiddenPass = !isHiddenPass;
    });
  }




}
