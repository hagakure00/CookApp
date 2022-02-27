import 'package:cook/Models/recette.dart';
import 'package:cook/Service/Firebase.dart';
import 'package:cook/Theme/colors.dart';
import 'package:cook/Widgets/Design/Category_list/Classique.dart';
import 'package:cook/Widgets/Design/Category_list/Cookeo.dart';
import 'package:cook/Widgets/Design/Category_list/Thermomix.dart';
import 'package:cook/Widgets/Sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import 'DetailPage.dart';


class CategoriePage extends StatefulWidget {
  const CategoriePage({Key? key}) : super(key: key);

  @override
  _CategoriePageState createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {

  var isSelectedClassique = false;
  var isSelectedCookeo = false;
  var isSelectedThermomix = false;

  @override
  void initState() {
    super.initState();
    isSelectedClassique = true;
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final tabSelect = <Widget>[
      const Tab(text: 'Aperitif'),
      const Tab(text: 'Entrée'),
      const Tab(text: 'Plat'),
      const Tab(text: 'Dessert'),
    ];

    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: buildAppBar()),
      drawer: const Sidebar(),
      body: DefaultTabController(
        length: tabSelect.length,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buttonClassique(),buttonCookeo(),buttonThermomix()
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                  width: size.width - 100,
                  child: Divider(color: Colors.black.withOpacity(0.3),)),
              const SizedBox(height: 10),
              //////////////////////////////////////////////
              // condition pour afficher les sous categorie
                if (isSelectedClassique )
                  const ClassiqueList()
                else if (isSelectedCookeo)
                  const CookeoList()
                 else if (isSelectedThermomix)
                  const ThermomixList()
              ///////////////////////////////////////////
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        elevation: 3,
        title: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 35, child: Image.asset('assets/images/logobar.png')),
              const SizedBox(width: 5),
              Text('Cook', style: GoogleFonts.oswald( textStyle: const TextStyle(color: black, fontSize: 20,letterSpacing: 1,decoration: TextDecoration.none))),
              const SizedBox(width: 2),
              Text('Book', style: GoogleFonts.oswald( textStyle: const TextStyle(color: primary, fontSize: 20,letterSpacing: 1,decoration: TextDecoration.none))),
            ],
          ),
        )
    );
  }

  Widget buttonClassique() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelectedClassique = true;
          if (isSelectedClassique = true){
            isSelectedCookeo = false;
            isSelectedThermomix = false;
          } else {
            isSelectedClassique = false;
          }
        });
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Card(
          shape: RoundedRectangleBorder(
              side: (isSelectedClassique == true) ? const BorderSide(color: primary, width: 2) : const BorderSide(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 50,
                  child: Image.asset('assets/images/classique.png')),
              Text('Classique', style: GoogleFonts.poppins( textStyle: const TextStyle(color: black, fontSize: 13,letterSpacing: 0.5,decoration: TextDecoration.none))),
            ],),),),
    );
  }
  Widget buttonCookeo() {
    return GestureDetector(
      onTap: () {
        setState(() {
            isSelectedCookeo = true;
            if (isSelectedCookeo = true){
              isSelectedClassique = false;
              isSelectedThermomix = false;
            } else {
              isSelectedCookeo = false;
            }
        });
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Card(
          shape: RoundedRectangleBorder(
              side: (isSelectedCookeo == true) ? const BorderSide(color: primary, width: 2) : const BorderSide(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 50,
                  child: Image.asset('assets/images/cookeo.png')),
              Text('Cookeo', style: GoogleFonts.poppins( textStyle: const TextStyle(color: black, fontSize: 13,letterSpacing: 0.5,decoration: TextDecoration.none))),
            ],),),),
    );
  }
  Widget buttonThermomix() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelectedThermomix = true;
          if (isSelectedThermomix = true){
            isSelectedClassique = false;
            isSelectedCookeo = false;
          } else {
            isSelectedThermomix = false;
          }
        });
      },
      child: SizedBox(
        width: 100,
        height: 100,
        child: Card(
          shape: RoundedRectangleBorder(
              side: (isSelectedThermomix == true) ? const BorderSide(color: primary, width: 2) : const BorderSide(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 50,
                  child: Image.asset('assets/images/thermomix.png')),
              Text('Thermomix', style: GoogleFonts.poppins( textStyle: const TextStyle(color: black, fontSize: 13,letterSpacing: 0.5,decoration: TextDecoration.none))),
            ],),),),
    );
  }


}
