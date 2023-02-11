import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/provider/current_locale.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

const languages = [
  'English',
  'Chinese',
];

const labelStyle = TextStyle(fontSize: 16);

class _SettingsPageState extends State<SettingsPage> {
  var _language = 'English';

  void _onSetLanguage(value) {
    setState(() {
      _language = value!;
    });
    if (value == 'Chinese') {
      Provider.of<CurrentLocale>(context, listen: false)
          .setLocale(const Locale('zh'));
    } else {
      Provider.of<CurrentLocale>(context, listen: false)
          .setLocale(const Locale('en'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Card(
            child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              const Divider(),
              Row(
                children: [
                  Icon(
                    Icons.language,
                    size: 16,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    AppLocalizations.of(context)!.language,
                    style: labelStyle,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  DropdownButton(
                    value: _language,
                    items:
                        languages.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: _onSetLanguage,
                  )
                ],
              ),
              const Divider(),
            ],
          ),
        )));
  }
}
