import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/core/utils/url_converter.dart';

void main() {
  group(
    'toUri',
    () {
      late UrlConverter converter;
      String url = 'https://www.index.hr/rss';
      Uri uri = Uri.parse(url);

      setUp(
        () {
          converter = UrlConverterImpl();
        },
      );
      test('should return URI when valid url sent', () {
        final result = converter.toURI(url);
        expect(result, Right(uri));
      });
      test('should return InvalidUrlFailure when empty url sent', () async {
        final result = converter.toURI('');
        expect(result, Left(InvalidUrlFailure()));
      });
    },
  );
}
