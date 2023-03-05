import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/sources.dart';

import '../bloc/articles_bloc.dart';

class SourcesNavigationBar extends StatelessWidget {
  final int activeTabIndex;

  const SourcesNavigationBar({super.key, required this.activeTabIndex});

  List<BottomNavigationBarItem> buildBottomNavigationItems() {
    return sources
        .map<BottomNavigationBarItem>((source) => BottomNavigationBarItem(
              backgroundColor: Colors.grey.shade500,
              label: source.name,
              icon: Image(
                image: AssetImage("assets/images/${source.name}.png"),
                height: 24,
                width: 24,
              ),
            ))
        .toList();
  }

  void _onSelectedNavigationItem(int index, BuildContext context) {
    var url = sources[index].url;
    BlocProvider.of<ArticlesBloc>(context)
        .add(GetArticlesFromUrlEvent(url: url, activeTabIndex: index));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: activeTabIndex,
      onTap: (index) => _onSelectedNavigationItem(index, context),
      items: buildBottomNavigationItems(),
    );
  }
}
