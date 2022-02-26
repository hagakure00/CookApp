import 'package:cloud_firestore/cloud_firestore.dart';

class Recette {

  String id;
  final String userID;
  final DateTime date;
  final String name;
  final String time;
  final String auteur;
  final String imageURL;
  final int like;
  final bool favoris;
  final List ingredients;
  final List preparations;
  final String categorie;
  final String sousCategorie;
  final int comment;



  Recette(
      { required this.userID,
      required this.ingredients,
      required this.date,
      required this.name,
      required this.time,
      required this.auteur,
      required this.imageURL,
      required this.like,
      required this.favoris,
      required this.preparations,
      required this.categorie,
      required this.sousCategorie,
      required this.comment,
        this.id = ''});

  Map <String, dynamic> toMap() => {
  'id' : id,
  'userID' : userID,
  'date' : date,
  "name": name,
  "time": time,
  "auteur": auteur,
  "imageURL": imageURL,
  "like": like,
  "favoris": favoris,
  "preparations": preparations,
  "ingredients": ingredients,
  "categorie": categorie,
   "sousCategorie": sousCategorie,
   "comment": comment
  };


  factory Recette.fromJson(Map<String, dynamic> map, String id) {
    return Recette(
      id: map['id'],
      userID: map['userID'],
      name: map['name'],
      ingredients: map['ingredients'],
      date: (map['date'] as Timestamp).toDate(),
      time: map['time'],
      auteur: map['auteur'],
      imageURL: map['imageURL'],
      like: map['like'],
      favoris: map['favoris'],
      preparations: map['preparations'],
      categorie: map['categorie'],
      sousCategorie: map['sousCategorie'],
      comment: map['comment']
    );
  }

}