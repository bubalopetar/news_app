// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String title;
  final String link;
  final String? description;
  final String? img;
  final DateTime? pubDate;

  const Article({
    required this.title,
    required this.link,
    this.description,
    this.img,
    this.pubDate,
  });

  @override
  List<Object> get props {
    return [
      title,
      link,
    ];
  }
}
