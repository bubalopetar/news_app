import 'package:intl/intl.dart';
import 'package:news_app/features/articles/data/models/article_model.dart';
import 'package:xml/xml.dart';

abstract class ArticlesXMLParser {
  List<ArticleModel> getArticlesFromXML(String xml);
}

class ArticlesXMLParserImpl implements ArticlesXMLParser {
  late XmlDocument document;

  RegExp urlMatchingRegex = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');

  @override
  List<ArticleModel> getArticlesFromXML(String xml) {
    List<ArticleModel> articles = [];
    document = XmlDocument.parse(xml);

    for (XmlElement articleXML in document.findAllElements('item')) {
      dynamic result = _getArticleModelOrFalse(articleXML);
      if (result != false) {
        articles.add(result as ArticleModel);
      }
    }
    return articles;
  }

  dynamic _getArticleModelOrFalse(XmlElement article) {
    String? title = article.getElement('title')?.text;
    String? link = article.getElement('link')?.text;
    String? desc = article.getElement('description')?.text;
    String? category = article.getElement('category')?.text;
    DateTime? pubDate = _tryToGetPubDate(article.getElement('pubDate')?.text);
    String? img = _tryToGetImageLink(article);

    if (title != null && link != null) {
      return ArticleModel(
        title: title,
        link: link,
        description: desc ?? '',
        category: category ?? '',
        pubDate: pubDate,
        img: img ?? '',
      );
    } else {
      return false;
    }
  }

  String? _tryToGetImageLink(XmlElement article) {
    String? img = _tryToGetLinkFromText(article.getElement('content')?.text);
    if (img != null) return img;

    img = article.getElement('media:thumbnail')?.getAttribute('url');
    if (img != null) return img;

    String? descr = article.getElement('description')?.text;
    if (descr != null) {
      img = _tryToGetLinkFromText(descr);
      if (img != null) return img;
    }

    img = article.getElement('enclosure')?.getAttribute('url');
    if (img != null) return img;

    String content = article.text;
    img = _tryToGetLinkFromText(content, findImageLink: true);
    if (img != null) return img;

    return null;
  }

  String? _tryToGetLinkFromText(String? text, {bool findImageLink = false}) {
    if (text != null) {
      if (!findImageLink) {
        final match = urlMatchingRegex.firstMatch(text);
        if (match != null) {
          return text.substring(match.start, match.end);
        }
      } else {
        final matches = urlMatchingRegex.allMatches(text);

        if (matches.isNotEmpty) {
          for (RegExpMatch match in matches) {
            var link = match.input.substring(match.start, match.end);
            if (link.endsWith('.jpg') || link.endsWith('.png')) {
              return link;
            }
          }
        }
      }
    }
    return null;
  }

  DateTime? _tryToGetPubDate(String? dateString) {
    if (dateString == null) {
      return null;
    }

    DateTime? date;
    try {
      date = DateFormat('EEE, d MMM y hh:mm').parse(dateString);
    } on FormatException {
      date = DateFormat('y-d-MThh:mm').parse(dateString);
    }
    return date;
  }
}
