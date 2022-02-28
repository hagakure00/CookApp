import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cook/Pages/DetailPage.dart';
import 'package:cook/Pages/UserRecetteList.dart';
import 'package:cook/Theme/colors.dart';
import 'package:cook/Widgets/Sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import '../Models/profilUser.dart';
import '../Models/recette.dart';
import '../Service/Firebase.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  bool isExecute = false;
  String? snap;
  final TextEditingController searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size =  MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: buildAppBar()),
      drawer: const Sidebar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildListUser(),
            SizedBox(
              width: size.width - 100,
              child: const Divider(height: 2),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: buildSeachBar(context)
            ),
            SizedBox(
              height: size.height - 310,
              child: ListView(
                children: [ isExecute
                      ? StreamBuilder<List<Recette>>(
                    stream: getRecentRecette(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError){return const Text('error');}
                      else if (snapshot.hasData) {
                        return SizedBox(
                          height: size.height - 310,
                          child: ListView.builder(
                              itemCount:  snapshot.data!.length,
                              itemBuilder: (context,index) {
                                Recette data = snapshot.data![index];
                                if (snapshot.data![index].name.contains(snap!)){
                                  return GestureDetector(
                                      onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                                      child: buildCard(data)
                                  );
                                } else{
                                  return Container();
                                }
                              }
                          ),
                        );
                      } else { return const SpinKitRipple(color: primary, size: 100.0);}
                    },
                  )
                      : StreamBuilder<List<Recette>>(
                      stream: getRecentRecette(),
                      builder: (context, snapshot) {
                      if (snapshot.hasError){return const Text('error');}
                      else if (snapshot.hasData) {
                        return SizedBox(
                          height: size.height - 310,
                          child: ListView.builder(
                              itemCount:  snapshot.data!.length,
                              itemBuilder: (context,index) {
                                Recette data = snapshot.data![index];
                                return GestureDetector(
                                 onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => (DetailPage(recette: data))));},
                                  child: buildCard(data)
                                );
                              }
                          ),
                        );
                      } else { return const SpinKitRipple(color: primary, size: 100.0);}
                    },
                  ),
                ],
              ),
            )

          ],
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
  Widget buildSeachBar(context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1), width: 0.5)),
        fillColor: Colors.grey.withOpacity(0.1),
        filled: true,
        prefixIcon: const Icon(Icons.search, color: primary,size: 20),
        suffixIcon: InkWell(
            onTap: () {
              setState(() {
                searchController.clear();
                isExecute = false;
              });
            },
            child: (searchController.text.isNotEmpty) ? const Icon(Icons.close,color: grey,size: 18) : const SizedBox()
        ),
      ),
      style: GoogleFonts.poppins( textStyle: const TextStyle(color: black,fontSize: 13,decoration: TextDecoration.none)),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      cursorColor: primary,
      controller: searchController,
      onChanged: (value) {
        snap = value;
        setState(() {
          (searchController.text.isNotEmpty) ? isExecute = true : isExecute = false;
        });
      },
    );
  }


  Widget buildCard(data) {
    var size =  MediaQuery.of(context).size;
    return Padding(
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
                    child: CachedNetworkImage(
                      imageUrl: data.imageURL,fit: BoxFit.cover,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                      const SpinKitRipple(color: primary, size: 20),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
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
    );
  }

  Future queryData(String queryString) async {
    return FirebaseFirestore.instance.collection('AppRecette').where(
        'name' , isGreaterThanOrEqualTo: queryString).get();
  }

  Widget buildListUser() {
    return SizedBox(
      height: 140,
      child: StreamBuilder<List<ProfilUser>>(
        stream: getUser(),
        builder:(context, snapshot) {
          if (snapshot.hasError){return const Text('error');}
          else if (snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                ProfilUser data = snapshot.data![index];
                return GestureDetector(
                   onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => (UserRecetteList(profilUser: data))));},
                    child: Column(
                      children:  [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 80,
                              width: 80,
                              child: CachedNetworkImage(
                                imageUrl: data.photoURL,fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                const SpinKitRipple(color: primary, size: 20),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                            width: 90,
                            child: Text(data.name, style: GoogleFonts.poppins( textStyle: const TextStyle(color: black, fontSize: 13,letterSpacing: 0.5,decoration: TextDecoration.none,)),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis)),
                      ],
                    )
                );
              },
            );
          } else { return const SpinKitRipple(color: primary, size: 20.0);}
        },
      ),
    );
  }





}
