import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/CalculatorPage/IPFScoreCalculator.dart';
import 'package:mybarbell/CalculatorPage/WilksScoreCalculator.dart';

import 'Style.dart';

class ScoreCalculatorPage extends StatefulWidget {
  const ScoreCalculatorPage({super.key});

  @override
  State<ScoreCalculatorPage> createState() => _ScoreCalculatorPageState();
}

class _ScoreCalculatorPageState extends State<ScoreCalculatorPage> {
  var _version = '';
  var page1 = const WilksScoreCalculatorPage();
  var page2 = const IPFScoreCalculatorPage();

  @override
  Widget build(BuildContext context) {
    var calculatorPage = [page1, page2];

    var versions = <String>[
      AppLocalizations.of(context)!.wilks_dots_score,
      AppLocalizations.of(context)!.ipfs_score
    ];
    var version = _version == '' ? versions[0] : _version;

    void _clearData() {
      // TODO clear data
      // if(versions.indexOf(version) == 0) {
      //   page1.clearData();
      // } else if (versions.indexOf(version) == 1) {
      //   page2.clearData();
      // }
    }

    return Card(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton(
                  value: version,
                  // style: titleStyle,
                  padding: dropdownPadding,
                  items: versions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: inputStyle),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != _version) {
                      setState(() {
                        _version = value!;
                      });
                    }
                  }),
              TextButton(
                  onPressed: _clearData,
                  child: Text(
                    AppLocalizations.of(context)!.clear,
                  ))
            ],
          ),
          const SizedBox(height: 20),
          calculatorPage[versions.indexOf(version)],
        ],
      ),
    ));
  }
}
