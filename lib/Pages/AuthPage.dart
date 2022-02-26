import 'package:cook/Widgets/LoginWidget.dart';
import 'package:cook/Widgets/SignWidget.dart';
import 'package:flutter/material.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLog = true;

  @override
  Widget build(BuildContext context) => isLog
      ? LoginWidget(onClickedSignUp: toggle)
      : SignWidget(onClickedLogIn: toggle);

  void toggle() => setState(() => isLog = !isLog);




}
