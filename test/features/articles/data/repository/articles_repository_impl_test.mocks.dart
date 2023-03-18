// Mocks generated by Mockito 5.3.2 from annotations
// in news_app/test/features/articles/data/repository/articles_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:news_app/features/articles/data/datasources/articles_local_data_source.dart'
    as _i5;
import 'package:news_app/features/articles/data/datasources/articles_remote_data_source.dart'
    as _i2;
import 'package:news_app/features/articles/data/models/article_model.dart'
    as _i4;
import 'package:news_app/features/articles/domain/entities/article.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ArticlesRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockArticlesRemoteDataSource extends _i1.Mock
    implements _i2.ArticlesRemoteDataSource {
  @override
  _i3.Future<List<_i4.ArticleModel>> getArticlesFrom({required Uri? url}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getArticlesFrom,
          [],
          {#url: url},
        ),
        returnValue:
            _i3.Future<List<_i4.ArticleModel>>.value(<_i4.ArticleModel>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i4.ArticleModel>>.value(<_i4.ArticleModel>[]),
      ) as _i3.Future<List<_i4.ArticleModel>>);
}

/// A class which mocks [ArticlesLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockArticlesLocalDataSource extends _i1.Mock
    implements _i5.ArticlesLocalDataSource {
  @override
  _i3.Future<bool> cacheOrRemoveArticle(_i4.ArticleModel? article) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheArticle,
          [article],
        ),
        returnValue: _i3.Future<bool>.value(false),
        returnValueForMissingStub: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);
  @override
  List<_i6.Article> getCachedArticles() => (super.noSuchMethod(
        Invocation.method(
          #getCachedArticles,
          [],
        ),
        returnValue: <_i6.Article>[],
        returnValueForMissingStub: <_i6.Article>[],
      ) as List<_i6.Article>);
}
