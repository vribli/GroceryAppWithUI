import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: true)
class ApiSearchResult {
  final String availability;
  final String category;
  final String image;
  final String name;
  final String previousPrice;
  final String productPrice;
  final String promoPrice;
  final String rating;
  final String size;
  final String supermarket;
  final String url;

  const ApiSearchResult(
  {this.availability,
  this.category,
  this.image,
  this.name,
  this.previousPrice,
  this.productPrice,
  this.promoPrice,
  this.rating,
  this.size,
  this.supermarket,
  this.url});

  factory ApiSearchResult.fromJson(Map<String, dynamic> json) =>
  ApiSearchResult(
  availability: json['Availability'] ?? '',
  category: json['Category'] ?? '',
  image: json['Image']??
  'https://upload.wikimedia.org/wikipedia/en/6/60/No_Picture.jpg',
  name: json['Name'] ?? '',
  previousPrice: json['Previous Price'].toString() ?? '0',
  productPrice: json['Product Price'].toString() ?? '0',
  promoPrice: json['Promo Price'].toString() ?? '0',
  rating: json['Rating'].toString() ?? '0',
  size: json['Size'] ?? '',
  supermarket: json['Supermarket'] ?? '',
  url: json['URL'] ?? ''
  );


  Map<String, dynamic> toJson() => {
  'Availability': availability,
  'Category': category,
  'Image': image,
  'Name': name,
  'Previous Price': previousPrice,
  'Product Price': productPrice,
  'Promo Price': promoPrice,
  'Rating': rating,
  'Size': size,
  'Supermarket': supermarket,
  'URL': url
  };
}