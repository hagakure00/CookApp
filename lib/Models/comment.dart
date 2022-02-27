import 'package:cloud_firestore/cloud_firestore.dart';

class Commentaire {

  String id;
  final String recetteId;
  final String userId;
  final String comment;
  final DateTime date;
  final String auteur;

  Commentaire(
      { required this.comment,
        required this.date,
        required this.auteur,
        required this.recetteId,
        required this.userId,
        this.id = ''
      });

  Map <String, dynamic> toMap() => {
    'comment' : comment,
    'date' : date,
    'auteur' : auteur,
    'id' : id,
    'recetteId' : recetteId,
    'userId' : userId,
  };


  factory Commentaire.fromJson(Map<String, dynamic> map, String id) {
    return Commentaire(
      comment: map['comment'],
      date: (map['date'] as Timestamp).toDate(),
      auteur: map['auteur'],
      id: map['id'],
      recetteId: map['recetteId'],
      userId: map['userId'],
    );
  }

}