import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Models/recette.dart';
import 'package:cook/Models/comment.dart';
import 'package:cook/Service/Firebase.dart';
import 'package:cook/Theme/colors.dart';
import 'package:cook/Widgets/Design/DetailInfo.dart';
import 'package:cook/Widgets/Sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';



class DetailPage extends StatefulWidget {
  const DetailPage({Key? key, required this.recette}) : super(key: key);

  final Recette recette;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  final commentController = TextEditingController();

  String uid =  (FirebaseAuth.instance.currentUser!).uid;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return  Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: buildAppBar()),
      drawer: const Sidebar(),
      body: SlidingUpPanel(
        parallaxEnabled: true,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        minHeight: (size.height / 1.7),
        maxHeight: size.height / 1.3,
        panel: Padding(
          padding: const EdgeInsets.all(15.0),
          child: DetailInfo(
              recetteId: widget.recette.id,
              name: widget.recette.name,
              auteur: widget.recette.auteur,
              category: widget.recette.categorie,
              sousCategory: widget.recette.sousCategorie,
              like: widget.recette.like,
              time: widget.recette.time,
              ingredient: widget.recette.ingredients,
              preparation: widget.recette.preparations,
              comment: Column(
              children: [
                  Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          openDialog(context) ;
                        },
                        style: ElevatedButton.styleFrom(primary: primary),
                        child: Text("Laisser un commentaire", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,fontWeight:FontWeight.w500,letterSpacing: 0.5, decoration: TextDecoration.none)),)
                    ),
                  ],
                ),
                SizedBox(
                  child: Container(
                      height: 240,
                      child: buildListComment()),
                )
              ],
            ),
          )
        ),

        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: widget.recette.imageURL,
                    child: SizedBox(
                      height: 350,
                      width: size.width,
                      child: Image.network(widget.recette.imageURL,fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
            ],
          ),)
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

  Widget buildListComment() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<List<Commentaire>>(
      stream: getComment(),
      builder:(context, snapshot) {
        if (snapshot.hasError){return const Text('error');}
        else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Commentaire data = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Card(
                    shape: RoundedRectangleBorder(
                        side: (data.userId == uid) ? const BorderSide(color: primary, width: 0.8) : const BorderSide(color: Colors.transparent, width: 2),
                        borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text("publi?? par : ", style: GoogleFonts.poppins( textStyle: TextStyle(color: black.withOpacity(0.3),fontSize: 12,letterSpacing: 0.5, decoration: TextDecoration.none)),),
                                Text(data.auteur, style: GoogleFonts.poppins( textStyle: const TextStyle(color: primary,fontSize: 12,letterSpacing: 0.5, decoration: TextDecoration.none)),),
                              ],
                            ),
                            GestureDetector(
                              onTap: () async {
                                deleteComment(data);
                                await FirebaseFirestore.instance.collection('AppRecette').doc(widget.recette.id).update({
                                  'comment': FieldValue.increment(-1),
                                });
                              },
                              child: (data.userId == uid ) ? const Icon(Icons.clear,color: red,size: 15) : const SizedBox(),
                            )
                          ],
                        ),
                        SizedBox(
                           width: size.width - 90,
                            child: const Divider()),
                        const SizedBox(height: 5),
                        Text(data.comment, style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 0.5, decoration: TextDecoration.none)),)
                      ],
                    ),
                  )
                ),
              );
            },
          );
        } else { return const SpinKitRipple(color: primary, size: 100.0);}
      },
    );
  }

  Future openDialog(BuildContext context) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        backgroundColor: white,
        contentPadding: const EdgeInsets.all(20),
        title: Text("Ecrire un commentaire", style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 16,decoration: TextDecoration.none))),
        content: TextFormField(
          controller: commentController,
          keyboardType: TextInputType.text,
          maxLines: 3,
          minLines: 3,
          textInputAction: TextInputAction.done,
          style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none)),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2)),
            fillColor: grey.withOpacity(0.1),
            filled: true,
          ),
        ),
        elevation: 5,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width /2,
                child: ElevatedButton(
                    onPressed: () async {
                      addComment(context);
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(primary: primary),
                    child: Text("Envoyer", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
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
                    style: ElevatedButton.styleFrom(primary: grey.withOpacity(0.5)),
                    child: Text("Annuler", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,decoration: TextDecoration.none)),)
                ),
              ),
            ],
          )
        ],
      );
    });
  }

  String? userName;
  Future createComment(Commentaire comment) async {
    final doc = FirebaseFirestore.instance.collection('CommentRecette').doc();
    comment.id = doc.id;
    final json = comment.toMap();
    await doc.set(json);
  }
  addComment(context) async{
    String uid =  (FirebaseAuth.instance.currentUser!).uid;
    var collection = FirebaseFirestore.instance.collection('UserRecette');
    var docSnapshot = await collection.doc(uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      var name = data['name'];
      userName = name;
    }
    Commentaire comment = Commentaire(
        comment: commentController.text,
        date: DateTime.now(),
        auteur: userName.toString(),
        recetteId: widget.recette.id,
        userId: uid
    );
    createComment(comment);
    await FirebaseFirestore.instance.collection('AppRecette').doc(widget.recette.id).update({
      'comment': FieldValue.increment(1),
    });
    commentController.clear();
  }
  Stream<List<Commentaire>> getComment() {
    String uid =  (FirebaseAuth.instance.currentUser!).uid;
    return FirebaseFirestore.instance.collection('CommentRecette').where('recetteId', isEqualTo: widget.recette.id)
        .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
        Commentaire.fromJson(doc.data(),doc.id)).toList());
  }


  
}
