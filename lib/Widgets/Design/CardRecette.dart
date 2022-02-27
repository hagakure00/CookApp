import 'package:cook/Theme/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';


class CardRecette extends StatefulWidget {
  const CardRecette({Key? key,required this.comment, required this.name, required this.auteur, required this.category, required this.souscategory, required this.time, required this.like, required this.image}) : super(key: key);

  final String name;
  final String auteur;
  final String category;
  final String souscategory;
  final String time;
  final String like;
  final String image;
  final String comment;

  @override
  _CardRecetteState createState() => _CardRecetteState();
}

class _CardRecetteState extends State<CardRecette> {


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Card(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              children: [
                Hero(
                  tag: widget.name,
                  child: SizedBox(
                    width: size.width -20,
                    height: 200,
                    child: Image.network(widget.image,fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                    top: 0,
                    child: Container(
                      height: 200,
                      width: size.width -20,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            stops: const [0.4, 0.8],
                            colors: [black.withOpacity(0), black],
                          )),
                    )),
                Positioned(
                    top: 0,
                    child: Container(
                      height: 200,
                      width: size.width -20,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.4, 0.8],
                            colors: [black.withOpacity(0), black],
                          )),
                    )),
                Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Ionicons.person_outline, color: primary,size: 16),
                        const SizedBox(width: 10),
                        Text(widget.auteur,
                          style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                      ],
                    )
                ),
                Positioned(
                    top: 40,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Ionicons.document_outline, color: primary,size: 16),
                        const SizedBox(width: 10),
                        Text(widget.category,
                          style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                      ],
                    )
                ),
                Positioned(
                    top: 70,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Ionicons.documents_outline, color: primary,size: 16),
                        const SizedBox(width: 10),
                        Text(widget.souscategory,
                          style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                      ],
                    )
                ),
                Positioned(
                    top: 100,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Ionicons.timer_outline, color: primary,size: 16),
                        const SizedBox(width: 10),
                        Text(widget.time + " Mn",
                          style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                      ],
                    )
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [
                         Text(widget.like.toString(),
                          style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                        const SizedBox(width: 8),
                        const Icon(Ionicons.heart, color: primary ,size: 16),
                      ],
                    )
                ),
                Positioned(
                    top: 40,
                    right: 10,
                    child: Row(
                      children: [
                        Text(widget.comment,
                          style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                        const SizedBox(width: 8),
                        const Icon(Icons.messenger, color: primary ,size: 16),
                      ],
                    )
                ),
                Positioned(
                    bottom: 10,
                    left: 10,
                    child: SizedBox(
                        width: size.width -50,
                        child: Text(widget.name, style: GoogleFonts.poppins( textStyle: const TextStyle(color: white, fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w400, decoration: TextDecoration.none))))
                ),
              ],
            ),
          ),
        )
    );
  }
}
