// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:core';

List<Map<String, dynamic>> sourcesList = [
  {
    'name': 'Index.hr',
    'url': 'https://www.index.hr/rss',
    'categories': [
      {
        'name': 'NAJČITANIJE',
        'url': 'https://www.index.hr/rss/najcitanije',
      },
      {
        'name': 'VIJESTI',
        'url': 'https://www.index.hr/rss/vijesti',
      },
      {
        'name': 'HRVATSKA',
        'url': 'https://www.index.hr/rss/vijesti-hrvatska',
      },
      {
        'name': 'ZAGREB',
        'url': 'https://www.index.hr/rss/vijesti-zagreb',
      },
      {
        'name': 'REGIJA',
        'url': 'https://www.index.hr/rss/vijesti-regija',
      },
      {
        'name': 'EU',
        'url': 'https://www.index.hr/rss/vijesti-eu',
      },
      {
        'name': 'SVIJET',
        'url': 'https://www.index.hr/rss/vijesti-svijet',
      },
      {
        'name': 'ZNANOST',
        'url': 'https://www.index.hr/rss/vijesti-znanost',
      },
      {
        'name': 'CRNA KRONIKA',
        'url': 'https://www.index.hr/rss/vijesti-crna-kronika',
      },
      {
        'name': 'KOMENTARI',
        'url': 'https://www.index.hr/rss/vijesti-komentari',
      },
      {
        'name': 'NOVAC',
        'url': 'https://www.index.hr/rss/vijesti-novac',
      },
      {
        'name': 'SPORT',
        'url': 'https://www.index.hr/rss/sport',
      },
      {
        'name': 'NOGOMET',
        'url': 'https://www.index.hr/rss/sport-nogomet',
      },
      {
        'name': 'KOŠARKA',
        'url': 'https://www.index.hr/rss/sport-kosarka',
      },
      {
        'name': 'TENIS',
        'url': 'https://www.index.hr/rss/sport-tenis',
      },
      {
        'name': 'OSTALI SPORTOVI',
        'url': 'https://www.index.hr/rss/sport-ostali-sportovi',
      },
      {
        'name': 'REGIJA',
        'url': 'https://www.index.hr/rss/sport-regija',
      },
      {
        'name': 'KOMENTARI',
        'url': 'https://www.index.hr/rss/sport-komentari',
      },
      {
        'name': 'BORILAČKI SPORTOVI',
        'url': 'https://www.index.hr/rss/sport-borilacki-sportovi',
      },
      {
        'name': 'E-SPORT',
        'url': 'https://www.index.hr/rss/sport-e-sport',
      },
      {
        'name': 'MAGAZIN',
        'url': 'https://www.index.hr/rss/magazin',
      },
      {
        'name': 'TV & FILM',
        'url': 'https://www.index.hr/rss/magazin-tv-film',
      },
      {
        'name': 'GLAZBA',
        'url': 'https://www.index.hr/rss/magazin-glazba',
      },
      {
        'name': 'TECH & GADGET',
        'url': 'https://www.index.hr/rss/magazin-tech-gadget',
      },
      {
        'name': 'LIFESTYLE',
        'url': 'https://www.index.hr/rss/magazin-lifestyle',
      },
      {
        'name': 'SHOWBIZ',
        'url': 'https://www.index.hr/rss/magazin-showbiz',
      },
      {
        'name': 'ZANIMLJIVOSTI',
        'url': 'https://www.index.hr/rss/magazin-zanimljivosti',
      },
      {
        'name': 'LJUBIMCI',
        'url': 'https://www.index.hr/rss/ljubimci',
      },
      {
        'name': 'FOOD',
        'url': 'https://www.index.hr/rss/food',
      },
      {
        'name': 'MAME',
        'url': 'https://www.index.hr/rss/mame',
      },
      {
        'name': 'AUTO',
        'url': 'https://www.index.hr/rss/auto',
      },
      {
        'name': 'FIT',
        'url': 'https://www.index.hr/rss/fit',
      },
      {
        'name': 'CHILL',
        'url': 'https://www.index.hr/rss/chill',
      },
      {
        'name': 'SHOPPING',
        'url': 'https://www.index.hr/rss/shopping',
      },
      {
        'name': 'HOROSKOP',
        'url': 'https://www.index.hr/rss/horoskop',
      }
    ]
  },
  {
    'name': 'Net.hr',
    'url': 'https://net.hr/feed',
    'categories': [
      {
        'name': 'DANAS',
        'url': 'https://net.hr/feed/danas',
      },
      {
        'name': 'SPORT',
        'url': 'https://net.hr/feed/sport',
      },
      {
        'name': 'HOT',
        'url': 'https://net.hr/feed/hot',
      },
      {
        'name': 'MAGAZIN',
        'url': 'https://net.hr/feed/magazin',
      },
      {
        'name': 'WEBCAFE',
        'url': 'https://net.hr/feed/webcafe',
      },
      {
        'name': 'VIDEO',
        'url': 'https://net.hr/feed/video',
      },
    ]
  }
];

class Source {
  late String name;
  late String url;

  late List<Source>? categories;
  Source({
    required this.name,
    required this.url,
    this.categories,
  });
}

List sources = sourcesList
    .map((source) => Source(
        name: source['name'],
        url: source['url'],
        categories: source['categories']
            .map<Source>((c) => Source(name: c['name'], url: c['name']))
            .toList()))
    .toList();
