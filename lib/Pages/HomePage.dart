import 'package:cook/Models/recette.dart';
import 'package:cook/Service/Firebase.dart';
import 'package:cook/Theme/colors.dart';
import 'package:cook/Widgets/Design/CardRecette.dart';
import 'package:cook/Widgets/Sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'DetailPage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final tabSelect = <Widget>[const Tab(text: 'Récents'),const Tab(text: 'Populaires'),const Tab(text: 'Mes Recettes')];
    final tabView = <Widget>[buildListRecetteRecent(context),buildListRecettePopular(context), buildListUserRecette(context)];


    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: buildAppBar()),
      drawer: const Sidebar(),
      body: DefaultTabController(
        length: tabSelect.length,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TabBar(
                   isScrollable: true,
                    labelStyle:  GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,fontWeight:FontWeight.w500, decoration: TextDecoration.none)),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                    indicatorColor: primary, tabs: tabSelect,labelColor: primary,unselectedLabelColor: black),
                const SizedBox(height: 20),
                SizedBox(
                    height: size.height -160,
                    child: TabBarView(
                      children: tabView,
                    )),
              ],
            ),
          ),
        ),
      )
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
 Widget buildListRecetteRecent(context) {
   var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height -160,
      child: StreamBuilder<List<Recette>>(
        stream: getRecentRecette(),
        builder:(context, snapshot) {
          if (snapshot.hasError){return const Text('error');}
          else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Recette data = snapshot.data![index];
                return GestureDetector(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
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
  Widget buildListRecettePopular(context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height -160,
      child: StreamBuilder<List<Recette>>(
        stream: getPopularRecette(),
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
 Widget buildListUserRecette(context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height -160,
      child: StreamBuilder<List<Recette>>(
        stream: getUserRecette(),
        builder:(context, snapshot) {
          if (snapshot.hasError){return const Text('error');}
          else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Recette data = snapshot.data![index];
                return GestureDetector(
                    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
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
}
