class Product {

  final int id;

  final String category;

  final String name;

  final String description;

  final double price;

  final String image;

  Product({

    required this.id,

    required this.category,

    required this.name,

    required this.description,

    required this.price,

    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {

    return Product(

      id: json["id_plato"],

      category: json["categoria"],

      name: json["nombre"],

      description: json["descripcion"],

      price: (json["precio"] as num).toDouble(),

      image: json["imagen"],
    );
  }

  @override
  bool operator ==(Object other) {

    return identical(this, other) ||

        other is Product &&
        other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}