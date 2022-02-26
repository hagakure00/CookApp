import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Pages/AddPage.dart';
import 'package:cook/Pages/CategoriePage.dart';
import 'package:cook/Pages/HomePage.dart';
import 'package:cook/Pages/SearchPage.dart';
import 'package:cook/Pages/UserPage.dart';
import 'package:cook/Theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import '../main.dart';



class Sidebar extends StatefulWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {



  final user = FirebaseAuth.instance.currentUser!;

  File? image;
  String? downloadURL;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Image non trouvé : $e');
      }
    }
    uploadImage();
  }
  Future uploadImage() async {
    final user = FirebaseAuth.instance.currentUser!;
    // message de validation
    const message = 'Photo changé avec succes ! Mise a jour dans un instant';
    const snackBar = SnackBar(
        content: Text(message, style: TextStyle(fontSize: 14),
        ), backgroundColor: Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

      FirebaseStorage.instance.ref().child('UserRecette').child(user.uid).delete();
    // upload image to storage
    Reference ref = FirebaseStorage.instance.ref().child('UserRecette').child(user.uid);
    await ref.putFile(image!);
    // recuperer url
    downloadURL = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('UserRecette').doc(user.uid).update({
      'photoURL': downloadURL
    });
  }


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
                      const Icon(Icons.home_outlined,size:28, color: primary),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Text("Home", style: GoogleFonts.poppins(textStyle: const TextStyle(color: black,fontSize: 16,fontWeight: FontWeight.w500, letterSpacing: 0.5,height: 1,decoration: TextDecoration.none))),
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
                      const Icon(Ionicons.reader_outline,size:28, color: primary),
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
                      const Icon(Ionicons.person,size:28, color: primary),
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
                      const Icon(Icons.add_circle,size:28, color: primary),
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
                      const Icon(Icons.search,size:28, color: primary),
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
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: FirebaseFirestore.instance.collection('UserRecette').doc(user.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return Text ('Error = ${snapshot.error}');

                  if (snapshot.hasData) {
                    var data = snapshot.data!.data();
                    return SizedBox(
                        height: 100,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20,top: 10),
                              child: GestureDetector(
                                onTap:() {
                                  setState(() {
                                    pickImage(ImageSource.gallery);
                                  });
                                },
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:data!['photoURL'],fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) => Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      const SpinKitRipple(color: white, size: 20),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                    const Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Icon(Icons.camera_alt_rounded, color: primary,size: 20))
                                  ],
                                )
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 35,left: 10),
                              child: Column(

                                children: [
                                  Text(data['name'],
                                    style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                                  const SizedBox(height: 5),
                                  Text('Recettes :  ' + data['numberPost'].toString(),
                                    style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),

                                ],
                              ),
                            )
                          ],
                        )
                    );
                  }
                  return const SpinKitRipple(color: primary, size: 20);
                },
              ),
              const SizedBox(height: 20),
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
