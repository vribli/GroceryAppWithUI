class Grocery {
  final String name;
  final String image;
  final String promoPrice;
  final String size;

  Grocery({
    this.name,
    this.image,
    this.promoPrice,
    this.size
  });

  factory Grocery.fromJson(Map<String, dynamic> json) {
    return Grocery(
      name: json['Name'],
      image: json['Image'],
      promoPrice: json['Promo Price'],
      size: json['Size'],
    );
  }
}
