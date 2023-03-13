import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/Calculate.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

const zeroStr = '0.00';
const noLevel = '    ';

const percentagesData = [
  '95%',
  '90%',
  '85%',
  '80%',
  '75%',
  '70%',
  '65%',
  '60%',
  '55%',
  '50%',
  '45%',
  '40%'
];
const percentagesReps = [
  '2',
  '3',
  '4~5',
  '6~7',
  '8~9',
  '10~11',
  '12~14',
  '15~16',
  '17~20',
  '21~25',
  '26~30',
  '30+'
];
var percentagesWeight = [
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr
];

class _CalculatorPageState extends State<CalculatorPage> {
  var _formula = Formula[0];

  var _weightUnit = 'Kg';
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  var _rm1 = zeroStr;

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

  void _clearData() {
    _weightController.text = '';
    _repsController.text = '';

    for (int i = 0; i < 12; i++) {
      percentagesWeight[i] = zeroStr;
    }

    setState(() {
      _weightUnit = 'Kg';
      _rm1 = zeroStr;
    });
  }

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

  bool _checkCalculate1RM() {
    if (_weightController.text == '') {
      var snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.weight_not_specified),
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    if (_repsController.text == '') {
      var snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.reps_not_specified),
        duration: const Duration(seconds: 1),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
    return true;
  }

  void _onCalculate1RM(formula) {
    if (!_checkCalculate1RM()) {
      return;
    }
    double weight;
    int reps;
    try {
      weight = double.parse(_weightController.text);
    } on Exception catch (_) {
      return;
    }
    try {
      reps = int.parse(_repsController.text);
    } on Exception catch (_) {
      return;
    }

    var rm1 = calculate1RM(formula, _weightUnit, weight, reps);
    setState(() {
      _rm1 = rm1.toStringAsFixed(2);
    });
    calculatePercentages(rm1);
  }

  void calculatePercentages(double rm1) {
    for (int i = 0; i < 12; i++) {
      percentagesWeight[i] = ((95 - 5 * i) / 100.0 * rm1).toStringAsFixed(2);
    }
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

  List<DataRow> _getPercentagesReps() {
    List<DataRow> list = [];
    for (int i = 0; i < 12; i++) {
      list.add(DataRow(cells: [
        DataCell(Text(percentagesWeight[i])),
        DataCell(Text(percentagesData[i])),
        DataCell(Text(percentagesReps[i])),
      ]));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.one_rep_max_calculator,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                            onPressed: _clearData,
                            child: Text(
                              AppLocalizations.of(context)!.clear,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.formula,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton(
                            value: _formula,
                            items: Formula.map<DropdownMenuItem<String>>(
                                (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != _formula) {
                                _onCalculate1RM(value!);
                                setState(() {
                                  _formula = value;
                                });
                              }
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'\d+\.?\d*'))
                            ],
                            maxLength: 6,
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.weight,
                                counterText: ''),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        DropdownButton<String>(
                          value: _weightUnit,
                          onChanged: (value) {
                            if (_weightUnit != value) {
                              if (value == 'Kg') {
                                if (_weightController.text != '') {
                                  _weightController.text = lb2kg(
                                          double.parse(_weightController.text))
                                      .toStringAsFixed(2);
                                }
                                if (_rm1 != zeroStr) {
                                  double rm1 = lb2kg(double.parse(_rm1));
                                  setState(() {
                                    _rm1 = rm1.toStringAsFixed(2);
                                  });
                                  calculatePercentages(rm1);
                                }
                              } else {
                                if (_weightController.text != '') {
                                  _weightController.text = kg2lb(
                                          double.parse(_weightController.text))
                                      .toStringAsFixed(2);
                                }
                                if (_rm1 != zeroStr) {
                                  double rm1 = kg2lb(double.parse(_rm1));
                                  setState(() {
                                    _rm1 = rm1.toStringAsFixed(2);
                                  });
                                  calculatePercentages(rm1);
                                }
                              }
                            }
                            setState(() {
                              _weightUnit = value!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(value: 'Kg', child: Text('Kg')),
                            DropdownMenuItem(value: 'Lb', child: Text('Lb'))
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            maxLength: 6,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: false),
                            controller: _repsController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'\d'))
                            ],
                            decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.reps,
                                counterText: ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                                height: 35,
                                child: ElevatedButton(
                                    onPressed: () {
                                      _onCalculate1RM(_formula);
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)!.calculate
                                    )
                                )
                            )
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '1RM:',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              _rm1,
                              style: TextStyle(
                                fontSize: 44,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              _weightUnit,
                              style: const TextStyle(
                                  fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.set_as,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ButtonBar(
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  if (_rm1 != zeroStr) {
                                    if (_weightUnit != _wkWeightUnit) {
                                      if (_wkWeightUnit == 'Kg') {
                                        _squatController.text =
                                            lb2kg(double.parse(_rm1))
                                                .toStringAsFixed(2);
                                      } else {
                                        _squatController.text =
                                            kg2lb(double.parse(_rm1))
                                                .toStringAsFixed(2);
                                      }
                                    } else {
                                      _squatController.text = _rm1;
                                    }
                                  }
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.squat)),
                            OutlinedButton(
                                onPressed: () {
                                  if (_rm1 != zeroStr) {
                                    if (_weightUnit != _wkWeightUnit) {
                                      if (_wkWeightUnit == 'Kg') {
                                        _benchController.text =
                                            lb2kg(double.parse(_rm1))
                                                .toStringAsFixed(2);
                                      } else {
                                        _benchController.text =
                                            kg2lb(double.parse(_rm1))
                                                .toStringAsFixed(2);
                                      }
                                    } else {
                                      _benchController.text = _rm1;
                                    }
                                  }
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.bench)),
                            OutlinedButton(
                                onPressed: () {
                                  if (_rm1 != zeroStr) {
                                    if (_weightUnit != _wkWeightUnit) {
                                      if (_wkWeightUnit == 'Kg') {
                                        _deadliftController.text =
                                            lb2kg(double.parse(_rm1))
                                                .toStringAsFixed(2);
                                      } else {
                                        _deadliftController.text =
                                            kg2lb(double.parse(_rm1))
                                                .toStringAsFixed(2);
                                      }
                                    } else {
                                      _deadliftController.text = _rm1;
                                    }
                                  }
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.deadlift))
                          ],
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: DataTable(
                              showBottomBorder: true,
                              columns: [
                                DataColumn(
                                    label: Text(AppLocalizations.of(context)!.weight)
                                ),
                                DataColumn(
                                    label: Text(AppLocalizations.of(context)!.percentage)
                                ),
                                DataColumn(
                                    label: Text(AppLocalizations.of(context)!.reps)
                                )
                              ],
                              rows: _getPercentagesReps(),
                            ),
                        )
                      ],
                    )
                  ],
                ),
              )),
              // wilks score card
              Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.wilks_score,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
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
                              maxLength: 6,
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
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: TextField(
                              maxLength: 6,
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
                            )),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: TextField(
                              maxLength: 6,
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
                              maxLength: 6,
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
                            )),
                            const SizedBox(
                              width: 20,
                            ),
/*
                            Text(
                              AppLocalizations.of(context)!.gender,
                              style: const TextStyle(fontSize: 16),
                            ),

                            const SizedBox(
                              width: 15,
                            ),
*/
                            DropdownButton(
                                value: _gender,
                                items: [
                                  DropdownMenuItem(
                                      value: '0',
                                      child:
                                          Text(AppLocalizations.of(context)!.male)),
                                  DropdownMenuItem(
                                      value: '1',
                                      child: Text(
                                          AppLocalizations.of(context)!.female))
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
                                      value: 'Kg', child: Text('Kg')),
                                  DropdownMenuItem(
                                      value: 'Lb', child: Text('Lb'))
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
                                  height: 35,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        if (_checkCalculateWilks()) {
                                          _onCalculateWilKs(_gender);
                                        }
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.calculate)),
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
                            Chip(
                              label: Text(_wilksLevel),
                              backgroundColor: _levelColor,
                            )
                          ],
                        )
                      ],
                ),
              ))
            ],
          ),
        ));
  }
}
