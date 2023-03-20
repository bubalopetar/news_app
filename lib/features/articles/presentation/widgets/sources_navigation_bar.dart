import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/sources.dart';

import '../bloc/articles_bloc.dart';

class SourcesNavigationBar extends StatefulWidget {
  final int activeTabIndex;

  const SourcesNavigationBar({super.key, required this.activeTabIndex});

  @override
  State<SourcesNavigationBar> createState() => _SourcesNavigationBarState();
}

class _SourcesNavigationBarState extends State<SourcesNavigationBar> {
  final int optionsIndex = 6;

  BottomNavigationBarItem getOptionsItem() {
    return const BottomNavigationBarItem(
        icon: Icon(
          Icons.more_vert,
        ),
        label: '');
  }

  List<BottomNavigationBarItem> buildBottomNavigationItems() {
    List<BottomNavigationBarItem> items = sources
        .map<BottomNavigationBarItem>((source) => BottomNavigationBarItem(
              backgroundColor: Theme.of(context).bottomAppBarColor,
              label: source.name,
              icon: Image(
                image: AssetImage("assets/images/${source.name}.png"),
                height: 24,
                width: 24,
              ),
            ))
        .toList();
    items.add(getOptionsItem());
    return items;
  }

  showOptionsMenu(context) async {
    final items = [
      const PopupMenuItem(
        value: Options.favorites,
        child: Text("Favorites"),
      ),
    ];
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final bottomPosition = height - 65 - (items.length * 50);
    final selected = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(width, bottomPosition, 0, 0),
        items: items);
    switch (selected) {
      case Options.favorites:
        BlocProvider.of<ArticlesBloc>(context)
            .add(GetFavoritesEvent(activeTabIndex: optionsIndex));
        break;
      default:
        break;
    }
  }

  void _onSelectedNavigationItem(int index, BuildContext context) {
    if (index == optionsIndex) {
      showOptionsMenu(context);
      return;
    }
    var url = sources[index].url;
    BlocProvider.of<ArticlesBloc>(context)
        .add(GetArticlesFromUrlEvent(url: url, activeTabIndex: index));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.activeTabIndex,
      onTap: (index) => _onSelectedNavigationItem(index, context),
      items: buildBottomNavigationItems(),
    );
  }
}

enum Options { favorites }
