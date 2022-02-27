import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Models/recette.dart';
import 'package:cook/Service/Firebase.dart';
import 'package:cook/Theme/colors.dart';
import 'package:cook/Widgets/Sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'DetailPage.dart';
import 'EditPage.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  final user = FirebaseAuth.instance.currentUser!;

  File? image;
  String? downloadURL;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source,maxHeight:  200 , maxWidth: 200,imageQuality: 85,);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Image non trouvé : $e');
      }
    }
    uploadImage();
    Navigator.push(context, MaterialPageRoute(builder: (context) => (const UserPage())));
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
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: buildAppBar()),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10), 
          child: Column(
            children: [

              buildUserInfo(),

              const SizedBox(height: 20),
              SizedBox(
                  width: size.width /1.5,
                  child: const Divider(height: 2,color: grey)),
              const SizedBox(height: 20),

              SizedBox(
                height: size.height - 230,
                child: buildListUserRecette(context)
              ),

            ],
          ),
        ),
      )
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

  Widget buildUserInfo() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('UserRecette').doc(user.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text ('Error = ${snapshot.error}');
        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          return SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 70,
                                width: 70,
                                child: CachedNetworkImage(
                                  imageUrl: data!['photoURL'],fit: BoxFit.cover,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      const SpinKitRipple(color: primary, size: 20),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            // CircleAvatar(
                            //     radius: 35,
                            //     backgroundColor: grey.withOpacity(0.2),
                            //     backgroundImage: NetworkImage(data!['photoURL'])
                            //      ),
                            const Positioned(
                                bottom: 5,
                                right: 5,
                                child: Icon(Icons.camera_alt_rounded, color: primary,size: 20))
                          ],
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20,left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data['name'],
                          style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                        const SizedBox(height: 10),
                        Text('Nombre de Recettes :  ' + data['numberPost'].toString(),
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
    );
  }

  Widget buildListUserRecette(context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height -200,
      child: StreamBuilder<List<Recette>>(
        stream: getUserRecette(),
        builder:(context, snapshot) {
          if (snapshot.hasError){return const Text('error');}
          else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Recette data = snapshot.data![index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: size.width -60,
                      child: GestureDetector(
                          onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                          child: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Card(
                                color: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: data.imageURL,
                                        child: SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(data.imageURL,fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          SizedBox(
                                             width: size.width -190,
                                              child: Text(data.name, style: GoogleFonts.poppins( textStyle: const TextStyle(color: black, fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w400, decoration: TextDecoration.none)),overflow: TextOverflow.ellipsis)),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(Ionicons.reader_outline, color: primary,size: 16),
                                              const SizedBox(width: 10),
                                              Text(data.categorie,
                                                style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(Ionicons.timer_outline, color: primary,size: 16),
                                              const SizedBox(width: 10),
                                              Text(data.time + " Mn",
                                                style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                                            ],
                                          ),

                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              )
                          )
                      ),
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => (EditPage(recette: data))));
                          },
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Card(
                              child: Icon(Ionicons.pencil_outline, color: black,size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                           openDialog(context,data);
                             },
                          child: const SizedBox(
                            width: 40,
                            height: 40,
                            child: Card(
                              child: Icon(Icons.close, color: red,size: 18),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              },
            );
          } else { return const SpinKitRipple(color: primary, size: 100.0);}
        },
      ),
    );
  }

  Future openDialog(BuildContext context,data) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: white,
        contentPadding: const EdgeInsets.all(20),
        title: Text("Supprimer la recette ?", style: GoogleFonts.oswald( textStyle: const TextStyle(color: primary,fontSize: 20,decoration: TextDecoration.none))),
        content: Text("Elle sera definitivement supprimer", style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none))),
        elevation: 5,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width /2,
                child: ElevatedButton(
                    onPressed: () async {
                      deleteRecette(data);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(primary: red),
                    child: Text("Supprimer", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width /2,
                child: ElevatedButton(
                    onPressed: () {
                      if (kDebugMode) {
                        print("retour ...................");
                      }
                      Navigator.of(context).pop();},
                    style: ElevatedButton.styleFrom(primary: grey),
                    child: Text("Annuler", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
