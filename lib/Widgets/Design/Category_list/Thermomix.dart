import 'package:cook/Models/recette.dart';
import 'package:cook/Pages/DetailPage.dart';
import 'package:cook/Service/Firebase.dart';
import 'package:cook/Theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';


class ThermomixList extends StatefulWidget {
  const ThermomixList({Key? key}) : super(key: key);

  @override
  _ThermomixListState createState() => _ThermomixListState();
}

class _ThermomixListState extends State<ThermomixList> {

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    final tabSelect = <Widget>[
      const Tab(text: 'Aperitif'),
      const Tab(text: 'Entrée'),
      const Tab(text: 'Plat'),
      const Tab(text: 'Dessert'),
    ];
    final tabView = <Widget>[
      Container(child: buildListThermomixAperitif()),
      Container(child: buildListThermomixEntree()),
      Container(child: buildListThermomixPlat()),
      Container(child: buildListThermomixDessert()),
    ];

    return Column(
      children: [
        TabBar(
            labelStyle:  GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,fontWeight:FontWeight.w500, decoration: TextDecoration.none)),
            labelPadding: const EdgeInsets.symmetric(horizontal: 20),
            isScrollable: true,
            indicatorColor: primary, tabs: tabSelect,labelColor: primary,unselectedLabelColor: black),
        const SizedBox(height: 20),
        SizedBox(
            height: size.height -330,
            child: TabBarView(
              children: tabView,
            )),
      ],
    );
  }
  Widget buildListThermomixAperitif() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<List<Recette>>(
      stream: getThermomixRecetteAperitif(),
      builder:(context, snapshot) {
        if (snapshot.hasError){return const Text('error');}
        else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Recette data = snapshot.data![index];
              return GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                  child: buildcard(data)
              );
            },
          );
        } else { return const SpinKitRipple(color: primary, size: 100.0);}
      },
    );
  }
  Widget buildListThermomixEntree() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<List<Recette>>(
      stream: getThermomixRecetteEntree(),
      builder:(context, snapshot) {
        if (snapshot.hasError){return const Text('error');}
        else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Recette data = snapshot.data![index];
              return GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                  child: buildcard(data)
              );
            },
          );
        } else { return const SpinKitRipple(color: primary, size: 100.0);}
      },
    );
  }
  Widget buildListThermomixPlat() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<List<Recette>>(
      stream: getThermomixRecettePlat(),
      builder:(context, snapshot) {
        if (snapshot.hasError){return const Text('error');}
        else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Recette data = snapshot.data![index];
              return GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                  child: buildcard(data)
              );
            },
          );
        } else { return const SpinKitRipple(color: primary, size: 100.0);}
      },
    );
  }
  Widget buildListThermomixDessert() {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<List<Recette>>(
      stream: getThermomixRecetteDessert(),
      builder:(context, snapshot) {
        if (snapshot.hasError){return const Text('error');}
        else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Recette data = snapshot.data![index];
              return GestureDetector(
                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                  child: buildcard(data)
              );
            },
          );
        } else { return const SpinKitRipple(color: primary, size: 100.0);}
      },
    );
  }

  Widget buildcard(data) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
        child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Card(
              color: Colors.white,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: data.imageURL,
                      child: SizedBox(
                        width: 100,
                        height: 100,
                        child: Image.network(data.imageURL,fit: BoxFit.cover),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        SizedBox(
                            width: size.width -190,
                            child: Text(data.name, style: GoogleFonts.poppins( textStyle: const TextStyle(color: black, fontSize: 16,letterSpacing: 1,fontWeight: FontWeight.w400, decoration: TextDecoration.none)),overflow: TextOverflow.ellipsis)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Ionicons.reader_outline, color: primary,size: 16),
                            const SizedBox(width: 10),
                            Text(data.categorie,
                              style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(Ionicons.timer_outline, color: primary,size: 16),
                            const SizedBox(width: 10),
                            Text(data.time + " Mn",
                              style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,letterSpacing: 1,decoration: TextDecoration.none)),),
                          ],
                        ),

                      ],
                    )
                  ],
                ),
              ),
            )
        )
    );
  }

}
