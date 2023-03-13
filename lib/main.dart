import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/provider/currentSettings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

import 'CalculatorPage.dart';
import 'PlanPage.dart';
import 'SettingsPage.dart';


void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => CurrentSettings()),
        ],
          child: const MyApp()
      )
  );
/*  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
    SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }*/
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentSettings>(
      builder: (context, currentSettings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyBarbell',
          locale: currentSettings.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            brightness: currentSettings.theme,
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(
              title: 'MyBarbell',
              currentSettings: currentSettings
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title, required this.currentSettings});

  final String title;
  CurrentSettings currentSettings;

  @override
  State<MyHomePage> createState() => _MyHomePageState(currentSettings);
}

class _MyHomePageState extends State<MyHomePage> {
  var currentSettings;

  _MyHomePageState(this.currentSettings);

  int _bottomIndex = 0;
  final _pageList = [
    CalculatorPage(),
    // TODO PlanPage(),
    SettingsPage()
  ];
  final _fbutton = [
    null,
    /* TODO
    FloatingActionButton(
        onPressed: () {}, tooltip: 'Increment', child: const Icon(Icons.add)),
     */
    null
  ];

  void _onBottomChanged(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }

  ScrollPhysics? getPhysics() {
    if (UniversalPlatform.isAndroid) {
      return const ClampingScrollPhysics();
    } else if (UniversalPlatform.isIOS) {
      return const NeverScrollableScrollPhysics();
    }
    else {
      return const NeverScrollableScrollPhysics();
    }
  }

  @override
  Widget build(BuildContext context) {
    var pageController = PageController(initialPage: _bottomIndex);


    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: const Icon(Icons.home),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomIndex,
          onTap: (index) {
            if (index != _bottomIndex) {
              pageController.jumpToPage(index);
            }
          },
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.calculate),
                label: AppLocalizations.of(context)!.calculator),
            /* TODO
            BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                label: AppLocalizations.of(context)!.plan),
            */
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppLocalizations.of(context)!.settings),
          ],
        ),
        body: PageView.builder(
            itemBuilder: (BuildContext context, int index) => _pageList[index],
            controller: pageController,
            itemCount: _pageList.length,
            physics: getPhysics(),
            onPageChanged: (index) {
                setState(() {
                _bottomIndex = index;
              });
            },
        ),
        floatingActionButton: _fbutton[_bottomIndex]);
  }
}
