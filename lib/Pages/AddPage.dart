import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Models/recette.dart';
import 'package:cook/Pages/HomePage.dart';
import 'package:cook/Service/Firebase.dart';
import 'package:cook/Theme/colors.dart';
import 'package:cook/Widgets/Sidebar.dart';
import 'package:cook/Widgets/Switch_Image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:firebase_storage/firebase_storage.dart';


class AddPage extends StatefulWidget {
 const AddPage({Key? key}) : super(key: key);


  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  String? userID;
  String? userName;
  int? userNumberPost;
  getUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    var collection = FirebaseFirestore.instance.collection('UserRecette');
    var docSnapshot = await collection.doc(user.uid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      var name = data['name'];
      var number = data['numberPost'];
      var id = data['id'];
      userName = name;
      userNumberPost = number;
      userID = id;
    }
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final timeController = TextEditingController();
  final ingredientController = TextEditingController();
  final preparationController = TextEditingController();
  final List _ingredients =[];
  final List _preparation =[];
  int index = 0;

  final itemssousCategory = ['Aperitif','Entrée','Plat principal','Dessert'];
  final itemsCategory = ['Recette Classique','Recette Cookeo','Recette Thermomix'];
  String? categoryValue;
  String? sousCategoryValue;
  File? image;
  String? downloadURL;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source,imageQuality: 90, maxHeight:  400 , maxWidth: 400);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Image non trouvé : $e');
      }
    }
  }
  Future uploadRecette() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    final isValid = formKey.currentState!.validate();
    if (image == null) {
      const message = 'La photo de la recette est requise !';
      const snackBar = SnackBar(
          content: Text(message, style: TextStyle(fontSize: 14),
          ), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (categoryValue == null){
      const message = 'La Categorie de la recette est requise !';
      const snackBar = SnackBar(
          content: Text(message, style: TextStyle(fontSize: 14),
          ), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (sousCategoryValue == null) {
      const message = 'La sous Categorie de la recette est requise !';
      const snackBar = SnackBar(
          content: Text(message, style: TextStyle(fontSize: 14),
          ), backgroundColor: Colors.red);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (isValid) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => (const HomePage())));
        // message de validation
        const message = 'Recette envoyé avec succes ! Mise a jour dans un instant';
        const snackBar = SnackBar(
            content: Text(message, style: TextStyle(fontSize: 14),
            ), backgroundColor: Colors.green);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        // upload image to storage
        Reference ref = FirebaseStorage.instance.ref().child('AppRecette').child(nameController.text);
        await ref.putFile(image!);
        // recuperer url
        downloadURL =  await ref.getDownloadURL();
        // poster contenu de la recette
        Recette recette = Recette(
            userID:  userID!,
            ingredients: (_ingredients.isNotEmpty) ? _ingredients : [],
            date: DateTime.now(),
            name:  nameController.text.toLowerCase(),
            time: (timeController.text.isNotEmpty) ? timeController.text : "0",
            auteur: userName!,
            imageURL: downloadURL!,
            like: 0,
            favoris: false,
            preparations: (_preparation.isNotEmpty) ? _preparation : [],
            categorie: categoryValue.toString(),
            sousCategorie: sousCategoryValue.toString(),
            comment: 0
        );
        createRecette(recette);
        await firebaseFirestore.collection('UserRecette').doc(user.uid).update({
          'numberPost': FieldValue.increment(1),
        });
      } else {
        return;
      }
    }


  }

  DropdownMenuItem<String>buildCategoryItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item,style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none))),
    );
  }
  DropdownMenuItem<String>buildsousCategoryItem(String item) {
    return DropdownMenuItem(
      value: item,
      child: Text(item,style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none))),
    );
  }


  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {

    final tabSelect = <Widget>[const Tab(text: 'Informations'),const Tab(text: 'Ingrédients'), const Tab(text: 'Préparations')];
    final tabView = <Widget>[buildInfoRecette(), buildIngredients(), buildPreparation(),];

    return DefaultTabController(
      length: tabSelect.length,
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: buildAppBar()),
        drawer: const Sidebar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                 TabBar(indicatorColor: primary, tabs: tabSelect,labelColor: primary,unselectedLabelColor: black),
                  const SizedBox(height: 20),
                 SizedBox(
                    height: MediaQuery.of(context).size.height -170,
                    child: TabBarView(
                    children: tabView,
                 )),
                ],
              ),
            ),
          ),
        )
      ),
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
  Widget buildImageRecette() {
    return Column(
      children: [
        const SizedBox(height: 0),


        // image de la recette
        GestureDetector(
          onTap:() => pickImage(ImageSource.gallery),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: image != null ? Image.file(image!,fit: BoxFit.cover) : Image.asset("assets/images/image.jpg",fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
  Widget buildInfoRecette() {
    return ListView(
      children: [
        buildImageRecette(),
        // non de la recette
        TextFormField(
          validator: (value) => value!.isEmpty ? "nom de la recette requis" : null,
          controller: nameController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none)),
          decoration: InputDecoration(
            hintText: "Nom de la recette",
            hintStyle: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 12,letterSpacing: 1,decoration: TextDecoration.none)),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2)),
            fillColor: white,
            filled: true,
          ),
        ),
        const SizedBox(height: 20),
        // temp de preparaion
        TextFormField(
          controller: timeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none)),
          decoration: InputDecoration(
            hintText: "Temps de préparation en minutes",
            hintStyle: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 12,letterSpacing: 1,decoration: TextDecoration.none)),
            border: const OutlineInputBorder(),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2)),
            fillColor: white,
            filled: true,
          ),
        ),
        const SizedBox(height: 20),
        // categorie de la recette
        Container(
          padding: const EdgeInsets.only(left: 15,top: 8,bottom: 8,right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                hint: Text('Categorie',style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 12,letterSpacing: 1,decoration: TextDecoration.none))),
                icon: const Icon(Ionicons.chevron_down_outline),
                iconSize: 20,
                value: categoryValue,
                isExpanded: true,
                items: itemsCategory.map(buildCategoryItem).toList(),
                onChanged: (value) => setState(() {categoryValue = value;})
            ),
          ),
        ),
        const SizedBox(height: 20),
        // sousCategorie de la recette
        Container(
          padding: const EdgeInsets.only(left: 15,top: 8,bottom: 8,right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: white,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
                hint: Text('sous Categorie',style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 12,letterSpacing: 1,decoration: TextDecoration.none))),
                icon: const Icon(Ionicons.chevron_down_outline),
                iconSize: 20,
                value: sousCategoryValue,
                isExpanded: true,
                items: itemssousCategory.map(buildCategoryItem).toList(),
                onChanged: (value) => setState(() {sousCategoryValue = value;})
            ),
          ),
        ),
        const SizedBox(height: 20),
        // submit recette
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => (const HomePage())));
                },
                style: ElevatedButton.styleFrom(primary: grey),
                child: Text("Retour", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,fontWeight:FontWeight.w500,letterSpacing: 0.5, decoration: TextDecoration.none)),)

            ),
            ElevatedButton(
                onPressed: () {
                  uploadRecette();
                },
                style: ElevatedButton.styleFrom(primary: primary),
                child: Text("Envoyer la recette", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 13,fontWeight:FontWeight.w500,letterSpacing: 0.5, decoration: TextDecoration.none)),)

            ),
          ],
        )
      ],
    );
  }
  Widget buildIngredients() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 90,
              child: TextFormField(
                controller: ingredientController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none)),
                decoration: InputDecoration(
                  hintText: "ingrédient",
                  hintStyle: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 12,letterSpacing: 1,decoration: TextDecoration.none)),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  fillColor: white,
                  filled: true,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (ingredientController.text.isNotEmpty) {
                    _ingredients.add(ingredientController.text);
                  }
                });
                ingredientController.clear();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: primary,
                ),
                child: Center(child: Text("+", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 25, decoration: TextDecoration.none)),))

              ),
            ),
          ],),
        const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height - 255,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: _ingredients.map((ingredient){
              return  Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width -55,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          getImageIngredient(ingredient),
                          const SizedBox(width: 20),
                          SizedBox(
                              width: MediaQuery.of(context).size.width -135,
                              child: Text(ingredient,style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none)))
                          ),],),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {_ingredients.remove(ingredient);});
                        },
                        child: const Icon(Icons.clear,color: red,size: 20),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
  Widget buildPreparation() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 90,
              child: TextFormField(
                controller: preparationController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none)),
                decoration: InputDecoration(
                  hintText: "Preparation",
                  hintStyle: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 12,letterSpacing: 1,decoration: TextDecoration.none)),
                  border: const OutlineInputBorder(),
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2)),
                  fillColor: white,
                  filled: true,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (preparationController.text.isNotEmpty) {
                    _preparation.add(preparationController.text);
                  }
                });
                preparationController.clear();
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: primary,
                ),
                  child: Center(child: Text("+", style: GoogleFonts.poppins( textStyle: const TextStyle(color: white,fontSize: 25, decoration: TextDecoration.none)),)),
              ),
            ),

          ],),
        const SizedBox(height: 20),
        SizedBox(
          height: MediaQuery.of(context).size.height - 255,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: _preparation.map((preparation){
              return  Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width -55,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(preparation,style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 14,letterSpacing: 1,decoration: TextDecoration.none))),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {_preparation.remove(preparation);});
                        },
                        child: const Icon(Icons.clear,color: red,size: 20),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

}


