import 'package:equatable/equatable.dart';

class Movie extends Equatable {
  final String uid;
  final String title;
  final String trailer_url;
  final String image_url;
  final List<String> categories;

  const Movie(
      {required this.uid,
        required this.title,
        required this.categories,
        required this.image_url,
        required this.trailer_url});

  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
      uid: json['uid'],
      title: json['title'],
      categories: json['categories'].cast<String>(),
      image_url: json['image_url'],
      trailer_url: json['trailer_url']);

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "title": title,
    "categories": categories,
    "image_url": image_url,
    "trailer_url": trailer_url
  };

  @override
  List<Object?> get props => [title, trailer_url, image_url, categories];
}