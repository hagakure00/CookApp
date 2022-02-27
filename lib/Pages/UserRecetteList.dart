import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Models/profilUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/recette.dart';
import '../Theme/colors.dart';
import '../Widgets/Design/CardRecette.dart';
import '../Widgets/Sidebar.dart';
import 'DetailPage.dart';

class UserRecetteList extends StatefulWidget {
  const UserRecetteList({Key? key, required this.profilUser}) : super(key: key);

  final ProfilUser profilUser;
  @override
  _UserRecetteListState createState() => _UserRecetteListState();
}

class _UserRecetteListState extends State<UserRecetteList> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: buildAppBar()),
      drawer: const Sidebar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            buildUserInfo(),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: size.width - 80,
                child: const Divider(height: 2),
              ),
            ),
            SizedBox(
              height: size.height - 215,
              child: ListView(
                children: [
                  buildListRecetteUser(),
                ],
              ),
            )
       ]),
    ));
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
      future: FirebaseFirestore.instance.collection('UserRecette').doc(widget.profilUser.id).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text ('Error = ${snapshot.error}');
        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          return SizedBox(
              height: 90,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20,top: 10),
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
                      ],
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
  Widget buildListRecetteUser() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height -215,
      child: StreamBuilder<List<Recette>>(
        stream: getUserRecetteList(),
        builder:(context, snapshot) {
          if (snapshot.hasError){return const Text('error');}
          else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Recette data = snapshot.data![index];
                return GestureDetector(
                    onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                    child: CardRecette(
                      name: data.name,
                      auteur: data.auteur,
                      category: data.categorie,
                      souscategory: data.sousCategorie,
                      time: data.time,
                      like: data.like.toString(),
                      image: data.imageURL,
                      comment: data.comment.toString(),
                    )
                );
              },
            );
          } else { return const SpinKitRipple(color: primary, size: 100.0);}
        },
      ),
    );
  }

  Stream<List<Recette>> getUserRecetteList() {
    String uid =  (FirebaseAuth.instance.currentUser!).uid;
    return FirebaseFirestore.instance.collection('AppRecette').where('userID', isEqualTo: widget.profilUser.id)
        .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        Recette.fromJson(doc.data(),doc.id)).toList());
  }

}
