class ProfilUser {

  String id;
  final String name;
  final int numberPost;
  final String photoURL;

  ProfilUser(
      { required this.name,
      required this.numberPost,
      required this.photoURL,
        this.id = ''
     });

  Map <String, dynamic> toMap() => {
  'id' : id,
  'name' : name,
  'numberPost' : numberPost,
  'photoURL' : photoURL,

  };


  factory ProfilUser.fromJson(Map<String, dynamic> map, String id) {
    return ProfilUser(
      id: map['id'],
      name: map['name'],
      numberPost: map['numberPost'],
      photoURL: map['photoURL'],
    );
  }

}