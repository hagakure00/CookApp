import 'package:cook/Pages/AddPage.dart';
import 'package:cook/Pages/CategoriePage.dart';
import 'package:cook/Pages/HomePage.dart';
import 'package:cook/Pages/SearchPage.dart';
import 'package:cook/Pages/UserPage.dart';
import 'package:cook/Theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';



class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {



  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      child: Drawer(
        child: Container(
          color: white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height:150,
                  child: Image.asset("assets/images/logo.png",fit: BoxFit.cover),
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (const HomePage())));},
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 30,
                          width: 30,
                          child: Image.asset('assets/images/home.png')),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Accueil", style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 16,fontWeight: FontWeight.w500, letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (const CategoriePage())));},
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/category.png')),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Categories", style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 16,fontWeight: FontWeight.w500, letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (const UserPage())));},
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/user.png')),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Mon Profil", style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 16,fontWeight: FontWeight.w500, letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
                      ),
                    ],
                  ),
                ),
              ),

              GestureDetector(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (const AddPage())));},
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/add.png')),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Ajouter", style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 16,fontWeight: FontWeight.w500, letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
                      ),
                    ],
                  ),
                ),
              ),


              GestureDetector(
                onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (const SearchPage())));},
                child: Padding(
                  padding: const EdgeInsets.only(left: 20,bottom: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/search.png')),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Rechercher", style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 16,fontWeight: FontWeight.w500, letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
                      ),
                    ],
                  ),
                ),
              ),


              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => (const MainPage())));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border:  Border.all(color: black,width: 3)
                    ),
                    child: Text("Se Deconnecter",
                        style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 13,fontWeight: FontWeight.bold, letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
