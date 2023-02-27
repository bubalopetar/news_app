import 'package:intl/intl.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:xml/xml.dart';

abstract class ArticlesXMLParser {
  late RegExp urlMatchingRegex;
  List<ArticleModel> getArticlesFromXML(String xml);
}

class ArticlesXMLParserImpl implements ArticlesXMLParser {
  @override
  RegExp urlMatchingRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');

  @override
  List<ArticleModel> getArticlesFromXML(String xml) {
    List<ArticleModel> articles = [];
    XmlDocument document = XmlDocument.parse(xml);

    for (var articleXML in document.findAllElements('item')) {
      dynamic result = _tryParseArticleModel(articleXML);
      if (result != false) {
        articles.add(result as ArticleModel);
      }
    }
    return articles;
  }

  dynamic _tryParseArticleModel(XmlElement article) {
    String? title = article.getElement('title')?.text;
    String? link = article.getElement('link')?.text;
    String? desc = article.getElement('description')?.text;
    DateTime? pubDate = _getDateTime(article.getElement('pubDate')?.text);
    String? img = _getImgLinkFromText(article.getElement('content')?.text);

    if (title != null && link != null) {
      return ArticleModel(
        title: title,
        link: link,
        description: desc,
        pubDate: pubDate,
        img: img,
      );
    } else {
      return false;
    }
  }

  String? _getImgLinkFromText(String? text) {
    String? imgLink;
    if (text != null) {
      final match = urlMatchingRegex.firstMatch(text);
      if (match != null) {
        String url = text.substring(match.start, match.end);
        if (url.contains('.jpg')) {
          imgLink = url;
        }
      }
    }
    return imgLink;
  }

  DateTime? _getDateTime(String? dateString) {
    return dateString != null
        ? DateFormat('EEE, d MMM y hh:mm').parse(dateString)
        : null;
  }
}
