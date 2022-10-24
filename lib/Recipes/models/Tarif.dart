class Tarif {
  final String name;
  final String images;
  final double ratings;
  final String totalTime;
  Tarif({
    required this.name,
    required this.images,
    required this.ratings,
    required this.totalTime,
  });

  factory Tarif.fromJson(dynamic json) {
    return Tarif(
        // 'factory' keywordu ile birlikte Tarif adlı sınıfa
        //**obje oluşturuyoruz.
        name: json['name'] ?? "", 
        // '??' operatoru ile ??'den önce olan ifade null ise
        //**??'den sonraki ifade dönüyor değilse ??'den önceki ifade dönüyor. 

        images: json["images"][0]["hostedLargeUrl"] ?? "",
        ratings: json["rating"] ?? "",
        totalTime: json["totalTime"] ?? "");
  }
  static List<Tarif> tariflerFromSnapshot(List snapshot) {
    //Bu method ile API'den gelen verilerle tarif

    //snapshot ifadesi Future ya da Stream
    //**ifadelerinin sonucunu ifade etmek için kullanılır.
    return snapshot.map((data) {
      return Tarif.fromJson(data);  
    }).toList(); // API'den aldığımız verilerle yemek tarifi listesini döndürüyoruz.
  }
  @override
  String toString() {
    
    return "Recipe {name: $name , image: $images, rating: $ratings, totalTime: $totalTime}";

    }
}


