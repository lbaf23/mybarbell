import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/provider/currentSettings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

const labelStyle = TextStyle(fontSize: 16);

class _SettingsPageState extends State<SettingsPage> {
  _SettingsPageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var locale = Provider.of<CurrentSettings>(context, listen: false).localeString;
    var theme = Provider.of<CurrentSettings>(context, listen: false).themeString;

    void onSetLanguage(value) {
      if (value != locale) {
          setState(() {
            locale = value;
          });
          Provider.of<CurrentSettings>(context, listen: false)
              .setLocale(value);
      }
    }
    void onSetTheme(value) {
      if (value != theme) {
          setState(() {
            theme = value;
          });
          Provider.of<CurrentSettings>(context, listen: false)
              .setTheme(value);
      }
    }

    var locales = [
      ['en', AppLocalizations.of(context)!.english],
      ['zh', AppLocalizations.of(context)!.chinese]
    ];
    var themes = [
      ['0', AppLocalizations.of(context)!.light],
      ['1', AppLocalizations.of(context)!.dark]
    ];

    return Padding(
        padding: const EdgeInsets.all(5),
        child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  const Divider(),
                  Row(
                    children: [
                      const Icon(
                        Icons.language,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.language,
                        style: labelStyle,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton(
                        value: locale,
                        items: locales.map<DropdownMenuItem<String>>((List<String> value) {
                          return DropdownMenuItem<String>(
                            value: value[0],
                            child: Text(value[1])
                          );
                        }).toList(),
                        onChanged: onSetLanguage,
                      )
                    ],
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(
                        Icons.color_lens,
                        size: 16,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.theme,
                        style: labelStyle,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      DropdownButton(
                        value: theme,
                        items: themes.map<DropdownMenuItem<String>>((List<String> value) {
                          return DropdownMenuItem<String>(
                              value: value[0],
                              child: Text(value[1])
                          );
                        }).toList(),
                        onChanged: onSetTheme,
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
        )));
  }
}
