import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Style.dart';
import 'CalculateUtils.dart';

class WilksScoreCalculatorPage extends StatefulWidget {
  const WilksScoreCalculatorPage({super.key});

  @override
  State<WilksScoreCalculatorPage> createState() => _WilksScoreCalculatorPageState();
}

const zeroStr = '0.00';
const noLevel = '';


class _WilksScoreCalculatorPageState extends State<WilksScoreCalculatorPage> {
  final _bodyWeightController = TextEditingController();
  var _wkWeightUnit = 'Kg';
  var _gender = '0';

  final _squatController = TextEditingController();
  final _benchController = TextEditingController();
  final _deadliftController = TextEditingController();

  var _squatWilksScore = zeroStr;
  var _benchWilksScore = zeroStr;
  var _deadliftWilksScore = zeroStr;
  var _totalWilksScore = zeroStr;
  var _wilksLevel = noLevel;
  var _levelColor = Colors.grey;

  void _clearWilksData() {
    _bodyWeightController.text = '';
    _squatController.text = '';
    _benchController.text = '';
    _deadliftController.text = '';
    setState(() {
      _wkWeightUnit = 'Kg';
      _gender = '0';
      _squatWilksScore = zeroStr;
      _benchWilksScore = zeroStr;
      _deadliftWilksScore = zeroStr;
      _totalWilksScore = zeroStr;
      _wilksLevel = noLevel;
      _levelColor = Colors.grey;
    });
  }

  bool _checkCalculateWilks() {
    if (_squatController.text == '' &&
        _benchController.text == '' &&
        _deadliftController.text == '') {
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

  void _onCalculateWilKs(String gender) {
    double bodyWeight;
    try {
      bodyWeight = double.parse(_bodyWeightController.text);
    } on Exception catch (_) {
      return;
    }

    String squat = _squatController.text;
    String bench = _benchController.text;
    String deadlift = _deadliftController.text;

    double score1, score2, score3;
    if (squat != '') {
      setState(() {
        score1 = calculateWilksScore(
            _wkWeightUnit, bodyWeight, int.parse(gender), double.parse(squat));
        _squatWilksScore = score1.toStringAsFixed(2);
      });
    }

    if (bench != '') {
      setState(() {
        score2 = calculateWilksScore(
            _wkWeightUnit, bodyWeight, int.parse(gender), double.parse(bench));
        _benchWilksScore = score2.toStringAsFixed(2);
      });
    }

    if (deadlift != '') {
      setState(() {
        score3 = calculateWilksScore(_wkWeightUnit, bodyWeight,
            int.parse(gender), double.parse(deadlift));
        _deadliftWilksScore = score3.toStringAsFixed(2);
      });
    }

    if (squat != '' && bench != '' && deadlift != '') {
      setState(() {
        double score = calculateWilksScore(
            _wkWeightUnit,
            bodyWeight,
            int.parse(gender),
            double.parse(squat) + double.parse(bench) + double.parse(deadlift));
        _totalWilksScore = score.toStringAsFixed(2);
        var level = calculateWilksLevel(score, context);
        _wilksLevel = level[0];
        _levelColor = level[1];
      });
    }
  }

  Widget getChip() {
    if (_wilksLevel != noLevel) {
      return Chip(
        label: Text(_wilksLevel),
        backgroundColor: _levelColor,
      );
    }
    return SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.wilks_score,
                      style: titleStyle
                    ),
                    TextButton(
                        onPressed: _clearWilksData,
                        child: Text(
                          AppLocalizations.of(context)!.clear,
                        ))
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          maxLength: inputTextMaxLength,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: _squatController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'\d+\.?\d*'))
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.squat,
                              counterText: ''),
                          style: inputStyle,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          maxLength: inputTextMaxLength,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: _benchController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'\d+\.?\d*'))
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.bench,
                              counterText: ''),
                          style: inputStyle,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                          maxLength: inputTextMaxLength,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: _deadliftController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'\d+\.?\d*'))
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.deadlift,
                              counterText: ''),
                          style: inputStyle,
                        )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                        child: TextField(
                          maxLength: inputTextMaxLength,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: _bodyWeightController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'\d+\.?\d*'))
                          ],
                          decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText:
                              AppLocalizations.of(context)!.body_weight,
                              counterText: ''),
                          style: inputStyle,
                        )),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                        value: _gender,
                        items: [
                          DropdownMenuItem(
                              value: '0',
                              child:
                              Text(
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
                            _onCalculateWilKs(value!);
                            setState(() {
                              _gender = value;
                            });
                          }
                        }),
                    const SizedBox(
                      width: 20,
                    ),
                    DropdownButton(
                        value: _wkWeightUnit,
                        items: const [
                          DropdownMenuItem(
                              value: 'Kg', child: Text('Kg', style: inputStyle,)),
                          DropdownMenuItem(
                              value: 'Lb', child: Text('Lb', style: inputStyle,))
                        ],
                        onChanged: (value) {
                          if (value != _wkWeightUnit) {
                            if (value == 'Kg') {
                              if (_squatController.text != '') {
                                _squatController.text = lb2kg(
                                    double.parse(
                                        _squatController.text))
                                    .toStringAsFixed(2);
                              }
                              if (_benchController.text != '') {
                                _benchController.text = lb2kg(
                                    double.parse(
                                        _benchController.text))
                                    .toStringAsFixed(2);
                              }
                              if (_deadliftController.text != '') {
                                _deadliftController.text = lb2kg(
                                    double.parse(
                                        _deadliftController.text))
                                    .toStringAsFixed(2);
                              }
                              if (_bodyWeightController.text != '') {
                                _bodyWeightController.text = lb2kg(
                                    double.parse(
                                        _bodyWeightController.text))
                                    .toStringAsFixed(2);
                              }
                            } else {
                              if (_squatController.text != '') {
                                _squatController.text = kg2lb(
                                    double.parse(
                                        _squatController.text))
                                    .toStringAsFixed(2);
                              }
                              if (_benchController.text != '') {
                                _benchController.text = kg2lb(
                                    double.parse(
                                        _benchController.text))
                                    .toStringAsFixed(2);
                              }
                              if (_deadliftController.text != '') {
                                _deadliftController.text = kg2lb(
                                    double.parse(
                                        _deadliftController.text))
                                    .toStringAsFixed(2);
                              }
                              if (_bodyWeightController.text != '') {
                                _bodyWeightController.text = kg2lb(
                                    double.parse(
                                        _bodyWeightController.text))
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_checkCalculateWilks()) {
                                  _onCalculateWilKs(_gender);
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.calculate,
                                style: buttonStyle
                              )
                          ),
                        )
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DataTable(showBottomBorder: true, columns: [
                        DataColumn(
                            label:
                            Text(AppLocalizations.of(context)!.item)),
                        DataColumn(
                            label: Text(
                                AppLocalizations.of(context)!.wilks_score)),
                      ], rows: [
                        DataRow(cells: [
                          DataCell(
                              Text(AppLocalizations.of(context)!.squat)),
                          DataCell(Text(_squatWilksScore)),
                        ]),
                        DataRow(cells: [
                          DataCell(
                              Text(AppLocalizations.of(context)!.bench)),
                          DataCell(Text(_benchWilksScore)),
                        ]),
                        DataRow(cells: [
                          DataCell(
                              Text(AppLocalizations.of(context)!.deadlift)),
                          DataCell(Text(_deadliftWilksScore)),
                        ]),
                        DataRow(cells: [
                          DataCell(Text(
                            AppLocalizations.of(context)!.total,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                          DataCell(Text(
                            _totalWilksScore,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          )),
                        ])
                      ]),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.training_level,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      height: 40,
                      child: getChip(),
                    )
                  ],
                )
              ],
            ),
          ));
  }
}
