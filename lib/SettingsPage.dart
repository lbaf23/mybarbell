import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/provider/current_locale.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

const labelStyle = TextStyle(fontSize: 16);

const localeList = ["en", "zh"];

class _SettingsPageState extends State<SettingsPage> {
  var _language = '0';
  var _theme = '0';

  void _onSetLanguage(value) {
    if (value != _language) {
      setState(() {
        _language = value!;
      });
      Provider.of<CurrentLocale>(context, listen: false)
          .setLocale(Locale(localeList[int.parse(value)]));
    }
  }
  void _onSetTheme(value) {
    if (value != _theme) {
      setState(() {
        _theme = value!;
      });
      // TODO set theme
    }
  }


  @override
  Widget build(BuildContext context) {
    var languages = [
      ['0', AppLocalizations.of(context)!.english],
      ['1', AppLocalizations.of(context)!.chinese]
    ];
    var themes = [
      ['0', AppLocalizations.of(context)!.light],
      ['1', AppLocalizations.of(context)!.dark]
    ];

    return Padding(
        padding: EdgeInsets.all(5),
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
                        value: _language,
                        items:
                            languages.map<DropdownMenuItem<String>>((List<String> value) {
                          return DropdownMenuItem<String>(
                            value: value[0],
                            child: Text(value[1])
                          );
                        }).toList(),
                        onChanged: _onSetLanguage,
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
                        value: _theme,
                        items:
                        themes.map<DropdownMenuItem<String>>((List<String> value) {
                          return DropdownMenuItem<String>(
                              value: value[0],
                              child: Text(value[1])
                          );
                        }).toList(),
                        onChanged: _onSetTheme,
                      )
                    ],
                  ),
                  const Divider(),
                ],
              ),
        )));
  }
}
