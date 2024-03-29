import 'package:dartz/dartz.dart';
import 'package:news_app/core/error/failures.dart';

class UrlConverter {
  Either<InvalidUrlFailure, Uri> toURI(String url) {
    try {
      if (url.isEmpty) {
        throw const FormatException();
      } else {
        return Right(Uri.parse(url));
      }
    } on FormatException {
      return Left(InvalidUrlFailure());
    }
  }
}

class InvalidUrlFailure extends Failure {}
