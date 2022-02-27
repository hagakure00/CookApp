import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../Switch_Image.dart';


class DetailInfo extends StatefulWidget {
  const DetailInfo({Key? key,required this.comment, required this.recetteId, required this.name, required this.auteur, required this.category, required this.sousCategory, required this.like, required this.time, required this.ingredient, required this.preparation}) : super(key: key);

  final String recetteId;
  final String name;
  final String auteur;
  final String category;
  final String sousCategory;
  final int like;
  final String time;
  final List ingredient;
  final List preparation;
  final Widget comment;

  @override
  _DetailInfoState createState() => _DetailInfoState();
}

class _DetailInfoState extends State<DetailInfo> {

  void addLike(String docID,int like) {
    var newLikes = like + 1;
    FirebaseFirestore.instance.collection("AppRecette").doc(docID).update({
      'like' : newLikes
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Center(
          child: Container(
            height: 5,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(widget.name,
          style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 23,letterSpacing: 1,decoration: TextDecoration.none)),),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Ionicons.person_outline,color: primary,size: 15),
            const SizedBox(width: 5),
            Text("Publié par :  ",
              style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 12,letterSpacing: 1,decoration: TextDecoration.none)),),
            Text(widget.auteur,
              style: GoogleFonts.poppins( textStyle: const TextStyle(color: primary,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            const Icon(Ionicons.document_outline,color: primary,size: 15),
            const SizedBox(width: 5),
            Text(widget.category,
              style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
            const SizedBox(width: 15),
            const Icon(Ionicons.documents_outline,color: primary,size: 15),
            const SizedBox(width: 5),
            Text(widget.sousCategory,
              style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),

          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  addLike(widget.recetteId, widget.like);
                });
              },
              child: Row(
                children: [
                  const Icon(Ionicons.heart, color: Colors.red,),
                  const SizedBox(width: 5,),
                  buildLike()
                ],
              ),
            ),
            const SizedBox(width: 40),

            const Icon(Ionicons.timer_outline,color: black),
            const SizedBox(width: 6),
            Text(widget.time + ' minutes',
              style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
            const Spacer(),

          ],
        ),
        const SizedBox(height: 10,),
        Divider(color: Colors.black.withOpacity(0.3),),

        Expanded(child:

        DefaultTabController(
          length: 3,
          initialIndex: 0,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                indicatorColor: Colors.red,
                tabs: [
                  Tab(
                    text: "Ingredients".toUpperCase(),
                  ),
                  Tab(
                    text: "Preparations".toUpperCase(),
                  ),
                  Tab(
                    text: "Commentaires".toUpperCase(),
                  ),
                ],
                labelColor: black,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0,color: primary),
                  insets: EdgeInsets.symmetric(horizontal:16.0),
                ),
                unselectedLabelColor: Colors.black.withOpacity(0.3),
                labelStyle:  GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,fontWeight:FontWeight.w500, decoration: TextDecoration.none)),
               // labelPadding: const EdgeInsets.symmetric(horizontal: 32,),
              ),
              Divider(color: Colors.black.withOpacity(0.3),),
              const SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView(
                      children: widget.ingredient.map(
                            (ingredient) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              getImageIngredient(ingredient),
                              const SizedBox(width: 15),
                              Text(ingredient,
                                  style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none))),
                            ],
                          ),
                        ),
                      ).toList(),
                    ),

                    ListView(
                      children: widget.preparation.map(
                            (preparation) => Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                children: [
                                  Text(preparation,
                                      style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none))),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Container(
                                    height: 1,
                                    width: size.width - 200,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),),
                              )
                            ],
                          ),
                        ),
                      ).toList(),
                    ),

                    ListView(
                      children: [
                        widget.comment
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ))
      ],
    );
  }

  Widget buildLike() {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('AppRecette').doc(widget.recetteId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text ('Error = ${snapshot.error}');
        if (snapshot.hasData) {
          var data = snapshot.data!.data();
          return Text(data!['like'].toString(), style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)));
        } else {
          return const SizedBox();
        }
      },
    );
  }

}
