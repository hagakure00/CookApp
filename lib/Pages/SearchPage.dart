import 'package:cook/Theme/colors.dart';
import 'package:cook/Widgets/Sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: buildAppBar()),
      drawer: const Sidebar(),
      body: const Center(
        child: Text("search"),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 5,
      title: Text('CookBook', style: GoogleFonts.oswald( textStyle: const TextStyle(color: primary, fontSize: 20,letterSpacing: 1,decoration: TextDecoration.none))),
    );
  }

}
