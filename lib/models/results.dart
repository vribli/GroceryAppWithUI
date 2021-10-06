class ApiSearchResult {
  var availability;
  String category;
  String img;
  String name;
  var previousPrice;
  var productPrice;
  var promoPrice;
  num rating;
  String size;
  String supermarket;
  String url;

  ApiSearchResult({this.availability, this.category, this.img, this.name, this.previousPrice, this.productPrice, this.promoPrice, this.rating, this.size, this.supermarket, this.url});
  ApiSearchResult.fromJson(Map json)
      : availability = json['Availability'],
        category = json['Category'],
        img = json['Image'],
        name = json['Name'],
        previousPrice = json['Previous Price'],
        productPrice = json['Product Price'],
        promoPrice = json['Promo Price'],
        rating = json['Rating'],
        size = json['Size'],
        supermarket = json['Supermarket'],
        url = json['URL'];

  Map toJson() {
    return {
      'availability': availability,
      'category': category,
      'img': img,
      'name': name,
      'prevPrice': previousPrice,
      'productPrice': productPrice,
      'promoPrice': promoPrice,
      'rating': rating,
      'size': size,
      'supermarket': supermarket,
      'url': url
    };
  }
}