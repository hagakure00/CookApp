import 'package:flutter/material.dart';

StatelessWidget getImageIngredient(String ingredient) {
  if (ingredient.contains('poireau')) {
    return const ImageIngredient(valueImage: "poireau");
  } else if (ingredient.contains('lardon')) {
    return const ImageIngredient(valueImage: "lardon");
  } else if (ingredient.contains('concombre')) {
    return const ImageIngredient(valueImage: "concombre");
  } else if (ingredient.contains('comcombre')) {
    return const ImageIngredient(valueImage: "concombre");
  }else if (ingredient.contains('basilic')) {
    return const ImageIngredient(valueImage: "basilic");
  } else if (ingredient.contains('vinaigre')) {
    return const ImageIngredient(valueImage: "vinaigrette");
  } else if (ingredient.contains('vinaigrette')) {
    return const ImageIngredient(valueImage: "vinaigrette");
  }  else if (ingredient.contains('oeuf')) {
    return const ImageIngredient(valueImage: "oeuf");
  } else if (ingredient.contains('sel')) {
    return const ImageIngredient(valueImage: "sel");
  } else if (ingredient.contains('poivre')) {
    return const ImageIngredient(valueImage: "poivre");
  } else if (ingredient.contains('fromage')) {
    return const ImageIngredient(valueImage: "fromage");
  } else if (ingredient.contains('courgette')) {
    return const ImageIngredient(valueImage: "courgette");
  } else if (ingredient.contains('chocolat')) {
    return const ImageIngredient(valueImage: "chocolat");
  } else if (ingredient.contains('sucre')) {
    return const ImageIngredient(valueImage: "sucre");
  } else if (ingredient.contains('beurre')) {
    return const ImageIngredient(valueImage: "beurre");
  }else if (ingredient.contains('olive')) {
    return const ImageIngredient(valueImage: "olive");
  } else if (ingredient.contains('chevre')) {
    return const ImageIngredient(valueImage: "chevre");
  } else if (ingredient.contains('olive')) {
    return const ImageIngredient(valueImage: "olive");
  }





  else {
    return const ImageIngredient(valueImage: "null");
  }
}


class ImageIngredient extends StatelessWidget {
  const ImageIngredient({Key? key, required this.valueImage}) : super(key: key);

  final String valueImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 20.0,
        child: ClipOval(child:Image.asset("assets/images/ingredients/$valueImage.webp")));
  }
}
