class Commentaire {

  String id;
  final String recetteId;
  final String comment;
  final DateTime date;
  final String auteur;

  Commentaire(
      { required this.comment,
        required this.date,
        required this.auteur,
        required this.recetteId,
        this.id = ''
      });

  Map <String, dynamic> toMap() => {
    'comment' : comment,
    'date' : date,
    'auteur' : auteur,
    'id' : id,
    'recetteId' : recetteId,
  };


  factory Commentaire.fromJson(Map<String, dynamic> map, String id) {
    return Commentaire(
      comment: map['comment'],
      date: map['date'],
      auteur: map['auteur'],
      id: map['id'],
      recetteId: map['recetteId'],
    );
  }

}