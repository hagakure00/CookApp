import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Models/comment.dart';
import 'package:cook/Models/recette.dart';
import 'package:cook/Models/profilUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';




// Ajouter
Future createRecette(Recette recette) async {
  String uid =  (FirebaseAuth.instance.currentUser!).uid;
  final docRecette = FirebaseFirestore.instance.collection('AppRecette').doc();
  recette.id = docRecette.id;
  final json = recette.toMap();
  await docRecette.set(json);
}

// Editer
Future editRecette(Recette recette, String editId) async {
  String uid =  (FirebaseAuth.instance.currentUser!).uid;
  FirebaseFirestore.instance.collection('AppRecette').doc(editId).update(recette.toMap());
}
//delete
Future deleteRecette(Recette recette) async {
  String uid = (FirebaseAuth.instance.currentUser!).uid;
  FirebaseFirestore.instance.collection('AppRecette').doc(recette.id).delete();
  FirebaseStorage.instance.ref().child('AppRecette').child(recette.name).delete();
  await FirebaseFirestore.instance.collection('UserRecette').doc(uid).update({
    'numberPost': FieldValue.increment(-1)});
}
Future deleteComment(Commentaire comment) async {
  String uid = (FirebaseAuth.instance.currentUser!).uid;
  FirebaseFirestore.instance.collection('CommentRecette').doc(comment.id).delete();
}

////////////////////////////////////////////////////////
////////////////////////////////////////////////////////

// get recette home
Stream<List<Recette>> getUserRecette() {
  String uid =  (FirebaseAuth.instance.currentUser!).uid;
  return FirebaseFirestore.instance.collection('AppRecette').where('userID', isEqualTo: uid)
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getRecentRecette() {
  String uid =  (FirebaseAuth.instance.currentUser!).uid;
  return FirebaseFirestore.instance.collection('AppRecette').orderBy("date", descending: true)
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getPopularRecette() {
  String uid =  (FirebaseAuth.instance.currentUser!).uid;
  return FirebaseFirestore.instance.collection('AppRecette').orderBy("like", descending: true)
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}


// get recette categorie
Stream<List<Recette>> getClassiqueRecetteAperitif(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Classique")
      .where('sousCategorie', isEqualTo: "Aperitif")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getCookeoRecetteAperitif(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Cookeo")
      .where('sousCategorie', isEqualTo: "Aperitif")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getThermomixRecetteAperitif(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Thermomix")
      .where('sousCategorie', isEqualTo: "Aperitif")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}

Stream<List<Recette>> getClassiqueRecetteEntree(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Classique")
      .where('sousCategorie', isEqualTo: "Entrée")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getCookeoRecetteEntree(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Cookeo")
      .where('sousCategorie', isEqualTo: "Entrée")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getThermomixRecetteEntree(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Thermomix")
      .where('sousCategorie', isEqualTo: "Entrée")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}

Stream<List<Recette>> getClassiqueRecettePlat(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Classique")
      .where('sousCategorie', isEqualTo: "Plat principal")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getCookeoRecettePlat(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Cookeo")
      .where('sousCategorie', isEqualTo: "Plat principal")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getThermomixRecettePlat(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Thermomix")
      .where('sousCategorie', isEqualTo: "Plat principal")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}

Stream<List<Recette>> getClassiqueRecetteDessert(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Classique")
      .where('sousCategorie', isEqualTo: "Dessert")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getCookeoRecetteDessert(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Cookeo")
      .where('sousCategorie', isEqualTo: "Dessert")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getThermomixRecetteDessert(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Thermomix")
      .where('sousCategorie', isEqualTo: "Dessert")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}

Stream<List<Recette>> getClassiqueRecetteBoisson(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Classique")
      .where('sousCategorie', isEqualTo: "Boisson")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getCookeoRecetteBoisson(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Cookeo")
      .where('sousCategorie', isEqualTo: "Boisson")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getThermomixRecetteBoisson(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Thermomix")
      .where('sousCategorie', isEqualTo: "Boisson")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}

Stream<List<Recette>> getClassiqueRecetteAutre(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Classique")
      .where('sousCategorie', isEqualTo: "Autre")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getCookeoRecetteAutre(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Cookeo")
      .where('sousCategorie', isEqualTo: "Autre")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}
Stream<List<Recette>> getThermomixRecetteAutre(){
  return FirebaseFirestore.instance.collection('AppRecette')
      .where('categorie', isEqualTo: "Recette Thermomix")
      .where('sousCategorie', isEqualTo: "Autre")
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      Recette.fromJson(doc.data(),doc.id)).toList());
}

//////////////////////////////////////////////////
//////////////////////////////////////////////////

// get list user
Stream<List<ProfilUser>> getUser() {
  return FirebaseFirestore.instance.collection('UserRecette')
      .snapshots().map((snapshot) => snapshot.docs.map((doc) =>
      ProfilUser.fromJson(doc.data(),doc.id)).toList());
}



