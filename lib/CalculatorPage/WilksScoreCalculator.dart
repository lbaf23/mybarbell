import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'CalculateUtils.dart';
import 'Style.dart';

class WilksScoreCalculatorPage extends StatefulWidget {
  const WilksScoreCalculatorPage({super.key});

  void clearData() => _WilksScoreCalculatorPageState()._clearData();

  @override
  State<WilksScoreCalculatorPage> createState() =>
      _WilksScoreCalculatorPageState();
}

const zeroStr = '0.00';
const noLevel = '';

class _WilksScoreCalculatorPageState extends State<WilksScoreCalculatorPage> {
  final _bodyWeightController = TextEditingController();
  var _wkWeightUnit = 'Kg';
  var _gender = '0';

  final _totalController = TextEditingController();

  var _wilksScore20 = zeroStr;
  var _wilksScore10 = zeroStr;
  var _dotsScore = zeroStr;

  var _wilksLevel = noLevel;
  var _levelColor = Colors.grey;

  void _clearData() {
    _bodyWeightController.text = '';
    _totalController.text = '';
    setState(() {
      _wilksScore10 = zeroStr;
      _wilksScore20 = zeroStr;
      _dotsScore = zeroStr;
      _wilksLevel = noLevel;
      _levelColor = Colors.grey;
    });
  }

  bool _checkCalculateWilks() {
    if (_totalController.text == '') {
      var snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.weight_not_specified),
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    if (_bodyWeightController.text == '') {
      var snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.body_weight_not_specified),
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  void _onCalculateScore(String gender) {
    double bodyWeight, total;
    int g;
    try {
      bodyWeight = double.parse(_bodyWeightController.text);
      total = double.parse(_totalController.text);
      g = int.parse(gender);
    } on Exception catch (_) {
      // TODO Exception
      return;
    }

    if (_wkWeightUnit == 'Lb') {
      bodyWeight = lb2kg(bodyWeight);
      total = lb2kg(total);
    }

    _onCalculateWilKs1(bodyWeight, total, g);
    _onCalculateWilKs2(bodyWeight, total, g);
    _onCalculateDots(bodyWeight, total, g);
  }

  void _onCalculateDots(double bodyWeight, double total, int gender) {
    var score = calculateDotsScore(bodyWeight, gender, total);
    setState(() {
      _dotsScore = score.toStringAsFixed(2);
    });
  }

  void _onCalculateWilKs2(double bodyWeight, double total, int gender) {
    var score = calculateWilksScore(bodyWeight, gender, total, 2);
    setState(() {
      _wilksScore20 = score.toStringAsFixed(2);
    });
  }

  void _onCalculateWilKs1(double bodyWeight, double total, int gender) {
    var score = calculateWilksScore(bodyWeight, gender, total, 1);
    setState(() {
      _wilksScore10 = score.toStringAsFixed(2);
      _wilksLevel = calculateWilksLevel(score, context)[0];
      _levelColor = calculateWilksLevel(score, context)[1];
    });
  }

  Widget getChip() {
    if (_wilksLevel != noLevel) {
      return Chip(
        label: Text(_wilksLevel),
        backgroundColor: _levelColor,
      );
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
              maxLength: inputTextMaxLength,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              controller: _totalController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))
              ],
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.total_weight,
                  counterText: ''),
              style: inputStyle,
            )),
            mediumWidthBox,
            Expanded(
                child: TextField(
              maxLength: inputTextMaxLength,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              controller: _bodyWeightController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d+\.?\d*'))
              ],
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: AppLocalizations.of(context)!.body_weight,
                  counterText: ''),
              style: inputStyle,
            )),
          ],
        ),
        largeHeightBox,
        Row(
          children: [
            Text(AppLocalizations.of(context)!.gender, style: inputStyle),
            mediumWidthBox,
            DropdownButton(
                value: _gender,
                padding: dropdownPadding,
                items: [
                  DropdownMenuItem(
                      value: '0',
                      child: Text(
                        AppLocalizations.of(context)!.male,
                        style: inputStyle,
                      )),
                  DropdownMenuItem(
                      value: '1',
                      child: Text(
                        AppLocalizations.of(context)!.female,
                        style: inputStyle,
                      ))
                ],
                onChanged: (value) {
                  if (_gender != value) {
                    setState(() {
                      _gender = value!;
                    });
                    _onCalculateScore(value!);
                  }
                }),
            const SizedBox(
              width: 40,
            ),
            Text(AppLocalizations.of(context)!.weight_unit, style: inputStyle),
            largeWidthBox,
            DropdownButton(
                value: _wkWeightUnit,
                padding: dropdownPadding,
                items: const [
                  DropdownMenuItem(
                      value: 'Kg',
                      child: Text(
                        'Kg',
                        style: inputStyle,
                      )),
                  DropdownMenuItem(
                      value: 'Lb',
                      child: Text(
                        'Lb',
                        style: inputStyle,
                      ))
                ],
                onChanged: (value) {
                  if (value != _wkWeightUnit) {
                    if (value == 'Kg') {
                      if (_totalController.text != '') {
                        _totalController.text =
                            lb2kg(double.parse(_totalController.text))
                                .toStringAsFixed(2);
                      }
                      if (_bodyWeightController.text != '') {
                        _bodyWeightController.text =
                            lb2kg(double.parse(_bodyWeightController.text))
                                .toStringAsFixed(2);
                      }
                    } else {
                      if (_totalController.text != '') {
                        _totalController.text =
                            kg2lb(double.parse(_totalController.text))
                                .toStringAsFixed(2);
                      }
                      if (_bodyWeightController.text != '') {
                        _bodyWeightController.text =
                            kg2lb(double.parse(_bodyWeightController.text))
                                .toStringAsFixed(2);
                      }
                    }
                    setState(() {
                      _wkWeightUnit = value!;
                    });
                  }
                }),
          ],
        ),
        largeHeightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: SizedBox(
              height: 40,
              child: ElevatedButton(
                  onPressed: () {
                    if (_checkCalculateWilks()) {
                      _onCalculateScore(_gender);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.calculate,
                      style: buttonStyle)),
            ))
          ],
        ),
        mediumWidthBox,
        Row(
          children: [
            Expanded(
              child: DataTable(
                  showBottomBorder: true,
                  // dataTextStyle: tableDataStyle,
                  // headingTextStyle: tableHeaderStyle,
                  columns: [
                    DataColumn(label: Text(AppLocalizations.of(context)!.item)),
                    DataColumn(
                        label: Text(AppLocalizations.of(context)!.score)),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(
                          Text(AppLocalizations.of(context)!.wilks_score_2_0)),
                      DataCell(Text(_wilksScore20)),
                    ]),
                    DataRow(cells: [
                      DataCell(
                          Text(AppLocalizations.of(context)!.wilks_score_1_0)),
                      DataCell(Text(_wilksScore10)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(AppLocalizations.of(context)!.dots_score)),
                      DataCell(Text(_dotsScore)),
                    ]),
                  ]),
            )
          ],
        ),
        mediumHeightBox,
        Row(
          children: [
            Text(
              AppLocalizations.of(context)!.training_level,
              style: const TextStyle(fontSize: 16),
            ),
            largeWidthBox,
            SizedBox(
              height: 40,
              child: getChip(),
            )
          ],
        ),
      ],
    );
  }
}
