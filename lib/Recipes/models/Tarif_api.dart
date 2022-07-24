import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_uygulamasi/Recipes/models/Tarif.dart';

class TarifApi {
  
  static Future<List<Tarif>> getTarif() async {
    var uri = Uri.https("yummly2.p.rapidapi.com", "/feeds/list", {
      "limit": "24",
      "start": "0",
    });
    final response = await http.get(uri, headers: {
      "X-RapidAPI-Key": "f7cc919b6amsh1036e32733a2345p1db547jsnd633440c32fa",
      "X-RapidAPI-Host": "yummly2.p.rapidapi.com",
      "useQueryString": "true"
    });

    Map data = jsonDecode(response.body);
    List temp_list = []; // API'den gelicek tarifler verileri için geçici liste

    for (var x in data['feed']) {
      temp_list.add(x["content"]["details"]);
    }
    return Tarif.tariflerFromSnapshot(temp_list);
  }
}
