import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/themes/app_themes.dart';
import 'package:news_app/core/themes/bloc/theme_bloc.dart';
import 'package:news_app/sources.dart';

import '../bloc/articles_bloc.dart';

class SourcesNavigationBar extends StatelessWidget {
  SourcesNavigationBar({super.key, required this.activeTabIndex});

  final int optionsIndex = sources.length;
  final int activeTabIndex;

  BottomNavigationBarItem _getOptionsItem(context) {
    return BottomNavigationBarItem(
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryColor,
        ),
        label: '');
  }

  List<BottomNavigationBarItem> _buildBottomNavigationItems(context) {
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
    items.add(_getOptionsItem(context));
    return items;
  }

  double _calculateHeightToShowOptionsMenu(mq, items, context) {
    int menuItemHeight = 50;
    int bottomNavBarHeight = 70;
    final fromBottomHeight = mq.padding.bottom + bottomNavBarHeight;
    final showMenuAtHight =
        mq.size.height - fromBottomHeight - (items.length * menuItemHeight);
    return showMenuAtHight;
  }

  _showOptionsMenu(context) async {
    final items = _getOptionsMenuItems(context);
    final mq = MediaQuery.of(context);
    final size = mq.size;

    final selected = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(size.width,
            _calculateHeightToShowOptionsMenu(mq, items, context), 0, 0),
        items: items);

    switch (selected) {
      case Options.favorites:
        BlocProvider.of<ArticlesBloc>(context)
            .add(GetFavoritesEvent(activeTabIndex: optionsIndex));
        break;
      case Options.changeTheme:
        {
          final theme = Theme.of(context).brightness == Brightness.dark
              ? AppTheme.light
              : AppTheme.dark;
          BlocProvider.of<ThemeBloc>(context).add(ChangeThemeEvent(theme));
        }
        break;
      default:
        break;
    }
  }

  List<PopupMenuItem<dynamic>> _getOptionsMenuItems(context) {
    return [
      const PopupMenuItem(
        value: Options.favorites,
        child: Text("Favorites"),
      ),
      const PopupMenuItem(
          value: Options.changeTheme, child: Text('Change theme'))
    ];
  }

  void _onSelectedNavigationItem(
    int index,
    BuildContext context,
  ) {
    if (index == optionsIndex) {
      _showOptionsMenu(context);
      return;
    }
    var url = sources[index].url;
    BlocProvider.of<ArticlesBloc>(context)
        .add(GetArticlesFromUrlEvent(url: url, activeTabIndex: index));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: activeTabIndex,
      onTap: (index) => _onSelectedNavigationItem(index, context),
      items: _buildBottomNavigationItems(context),
    );
  }
}

enum Options { favorites, changeTheme }
