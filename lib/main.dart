import 'dart:io';
import 'dart:js';

import 'package:blogclub/article.dart';
import 'package:blogclub/carousel/carousel_slider.dart';
import 'package:blogclub/data.dart';
import 'package:blogclub/gen/assets.gen.dart';
import 'package:blogclub/gen/fonts.gen.dart';
import 'package:blogclub/home.dart';
import 'package:blogclub/profile.dart';
import 'package:blogclub/splash.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff0D253C);
    const secondaryTextColor = Color(0xff2D4379);
    const primaryColor = Color(0xff376AED);
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          snackBarTheme: const SnackBarThemeData(backgroundColor: primaryColor),
          appBarTheme: const AppBarTheme(
            titleSpacing: 32,
            backgroundColor: Colors.white,
            foregroundColor: primaryTextColor,
          ),
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: FontFamily.avenir,
          )))),
          colorScheme: const ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            onSurface: primaryTextColor,
            onBackground: primaryTextColor,
            background: Color(0xffFBFCFF),
            surface: Colors.white,
          ),
          textTheme: const TextTheme(
              subtitle1: TextStyle(
                  fontFamily: FontFamily.avenir,
                  color: primaryColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
              caption: TextStyle(
                fontFamily: FontFamily.avenir,
                fontWeight: FontWeight.w700,
                fontSize: 10,
                color: Color(0xffB8BB2),
              ),
              subtitle2: TextStyle(
                  fontFamily: FontFamily.avenir,
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w200,
                  fontSize: 18),
              headline5: TextStyle(
                  fontFamily: FontFamily.avenir,
                  fontSize: 20,
                  color: primaryTextColor,
                  fontWeight: FontWeight.w700),
              headline6: TextStyle(
                  fontFamily: FontFamily.avenir,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryTextColor),
              headline4: TextStyle(
                  fontFamily: FontFamily.avenir,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: primaryTextColor),
              bodyText1: TextStyle(
                  fontFamily: FontFamily.avenir,
                  color: primaryColor,
                  fontSize: 14),
              bodyText2: TextStyle(
                  fontFamily: FontFamily.avenir,
                  color: secondaryTextColor,
                  fontSize: 12)),
        ),
        // home: Stack(
        //   children: [
        //     const Positioned.fill(child: HomeScreen()),
        //     Positioned(right: 0, bottom: 0, left: 0, child: _BottomNavigation())
        //   ],
        // ));
        home: MainScreen());
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

const int homeIndex = 0;
const int articleIndex = 1;
const int searchIndex = 2;
const int menuIndex = 3;
const double bottomNvigationHeight = 65;

class _MainScreenState extends State<MainScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];

  GlobalKey<NavigatorState> _homeKey = GlobalKey();
  GlobalKey<NavigatorState> _articleKey = GlobalKey();
  GlobalKey<NavigatorState> _searchKey = GlobalKey();
  GlobalKey<NavigatorState> _menuKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    articleIndex: _articleKey,
    searchIndex: _searchKey,
    menuIndex: _menuKey
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          body: Stack(
        children: [
          Positioned.fill(
            bottom: bottomNvigationHeight,
            child: IndexedStack(
              index: selectedScreenIndex,
              children: [
                _navigator(_homeKey,homeIndex,const HomeScreen()),
                _navigator(_articleKey,articleIndex,const ArticleScreen()),
                _navigator(_searchKey,searchIndex,const SearchScreen()),
                _navigator(_menuKey,menuIndex,const ProfileScreen()),
         
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: _BottomNavigation(
              selectedIndex: selectedScreenIndex,
              onTap: (int index) {
                setState(() {
                  _history.remove(selectedScreenIndex);
                  _history.add(selectedScreenIndex);
                  selectedScreenIndex = index;
                });
              },
            ),
          ),
        ],
      )),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState==null && selectedScreenIndex != index? Container(): Navigator(
      key: key,
                onGenerateRoute: (settings) =>
                    MaterialPageRoute(builder: (context) => Offstage(offstage: selectedScreenIndex != index, child: child)),
              );
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text(
        'Search Screen',
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  final Function(int index) onTap;
  final int selectedIndex;

  const _BottomNavigation(
      {Key? key, required this.onTap, required this.selectedIndex})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 65,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: const Color(0xff9b8487).withOpacity(0.3),
                )
              ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BottomNavigationItem(
                      iconFileName: 'Home.png',
                      activeIconFileName: 'Home.png',
                      onTap: () {
                        onTap(homeIndex);
                      },
                      isActive: selectedIndex == homeIndex,
                      title: 'Home'),
                  BottomNavigationItem(
                      iconFileName: 'Articles.png',
                      activeIconFileName: 'Articles.png',
                      onTap: () {
                        onTap(articleIndex);
                      },
                      isActive: selectedIndex == articleIndex,
                      title: 'Articles'),
                  Expanded(child: Container()),
                  BottomNavigationItem(
                      iconFileName: 'Search.png',
                      activeIconFileName: 'Search.png',
                      onTap: () {
                        onTap(searchIndex);
                      },
                      isActive: selectedIndex == searchIndex,
                      title: 'Search'),
                  BottomNavigationItem(
                      iconFileName: 'Menu.png',
                      activeIconFileName: 'Menu.png',
                      onTap: () {
                        onTap(menuIndex);
                      },
                      isActive: selectedIndex == menuIndex,
                      title: 'Menu'),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              height: 65,
              width: 85,
              alignment: Alignment.topCenter,
              child: Container(
                  height: bottomNvigationHeight,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(32.5),
                      color: const Color(0xff376AED)),
                  child: Image.asset('assets/img/icons/plus.png')),
            ),
          )
        ],
      ),
    );
  }
}

class BottomNavigationItem extends StatelessWidget {
  final String iconFileName;
  final String activeIconFileName;
  final String title;
  final bool isActive;
  final Function() onTap;

  const BottomNavigationItem(
      {Key? key,
      required this.iconFileName,
      required this.activeIconFileName,
      required this.title,
      required this.onTap,
      required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/icons/${isActive ? activeIconFileName : iconFileName}',
              width: 24,
              height: 24,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: themeData.textTheme.caption!.apply(
                  color: isActive
                      ? themeData.colorScheme.primary
                      : themeData.textTheme.caption!.color),
            )
          ],
        ),
      ),
    );
  }
}
