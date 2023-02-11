import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/provider/current_locale.dart';
import 'package:provider/provider.dart';

import 'CalculatorPage.dart';
import 'PlanPage.dart';
import 'SettingsPage.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => CurrentLocale())],
      child: const MyApp()));
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
    return Consumer<CurrentLocale>(
      builder: (context, currentLocale, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyBarbell',
          locale: currentLocale.value,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MyHomePage(title: 'MyBarbell'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _bottomIndex = 0;
  final _pageList = [CalculatorPage(), PlanPage(), SettingsPage()];
  final _fbutton = [
    null,
    FloatingActionButton(
        onPressed: () {}, tooltip: 'Increment', child: const Icon(Icons.add)),
    null
  ];

  void _onBottomChanged(int index) {
    setState(() {
      _bottomIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: Icon(Icons.home),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _bottomIndex,
          onTap: _onBottomChanged,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.calculate),
                label: AppLocalizations.of(context)!.calculator),
            BottomNavigationBarItem(
                icon: const Icon(Icons.book),
                label: AppLocalizations.of(context)!.plan),
            BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: AppLocalizations.of(context)!.settings),
          ],
        ),
        body: _pageList[_bottomIndex],
        floatingActionButton: _fbutton[_bottomIndex]);
  }
}
