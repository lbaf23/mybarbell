import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/provider/currentSettings.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

const labelStyle = TextStyle(fontSize: 16);

class _TrackerPageState extends State<TrackerPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
      child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!.tracker),
              ],
            ),
          )
      )
    );
  }
}
