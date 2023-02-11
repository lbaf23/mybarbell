import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mybarbell/Calculate.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  var _formula = Formula[0];

  var _weightUnit = 'Kg';
  var _weightController = TextEditingController();
  var _repsController = TextEditingController();
  var rm1 = '0.00';

  var _bodyWeightController = TextEditingController();
  var _bodyWeightUnit = 'Kg';
  var _gender = '0';

  var _squatController = TextEditingController();
  var _benchController = TextEditingController();
  var _deadliftController = TextEditingController();

  var _squatWilksScore = '0.00';
  var _benchWilksScore = '0.00';
  var _deadliftWilksScore = '0.00';
  var _totalWilksScore = '0.00';
  var _wilksLevel = '--';
  var _levelColor = Colors.grey;

  void _onCalculate1RM() {
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

    setState(() {
      rm1 =
          Calculate1RM(_formula, _weightUnit, weight, reps).toStringAsFixed(2);
    });
  }

  void _onCalculateWilKs() {
    double bodyWeight;
    try {
      bodyWeight = double.parse(_bodyWeightController.text);
    } on Exception catch (_) {
      return;
    }

    String squat = _squatController.value.text;
    String bench = _benchController.value.text;
    String deadlift = _deadliftController.value.text;

    double score1, score2, score3;
    if (squat != '') {
      setState(() {
        score1 = CalculateWilksScore(_bodyWeightUnit, bodyWeight,
            int.parse(_gender), double.parse(squat));
        _squatWilksScore = score1.toStringAsFixed(2);
      });
    }

    if (bench != '') {
      setState(() {
        score2 = CalculateWilksScore(_bodyWeightUnit, bodyWeight,
            int.parse(_gender), double.parse(bench));
        _benchWilksScore = score2.toStringAsFixed(2);
      });
    }

    if (deadlift != '') {
      setState(() {
        score3 = CalculateWilksScore(_bodyWeightUnit, bodyWeight,
            int.parse(_gender), double.parse(deadlift));
        _deadliftWilksScore = score3.toStringAsFixed(2);
      });
    }

    if (squat != '' && bench != '' && deadlift != '') {
      setState(() {
        double score = CalculateWilksScore(
            _bodyWeightUnit,
            bodyWeight,
            int.parse(_gender),
            double.parse(squat) + double.parse(bench) + double.parse(deadlift));
        _totalWilksScore = score.toStringAsFixed(2);
        var level = CalculateWilksLevel(score);
        _wilksLevel = level[0];
        _levelColor = level[1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.one_rep_max_calculator,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.formula,
                          style: TextStyle(
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
                              setState(() {
                                _formula = value!;
                              });
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
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Weight',
                                counterText: ''),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        DropdownButton<String>(
                          value: _weightUnit,
                          onChanged: (value) {
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
                                border: OutlineInputBorder(),
                                labelText: AppLocalizations.of(context)!.reps,
                                counterText: ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              '1RM:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              rm1,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              _weightUnit,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            height: 40,
                            child: ElevatedButton(
                                onPressed: _onCalculate1RM,
                                child: Text(
                                    AppLocalizations.of(context)!.calculate)))
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
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        ButtonBar(
                          children: [
                            OutlinedButton(
                                onPressed: () {
                                  if (rm1 != '0.00') {
                                    setState(() {
                                      _squatController.text = rm1;
                                    });
                                  }
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.squat)),
                            OutlinedButton(
                                onPressed: () {
                                  if (rm1 != '0.00') {
                                    setState(() {
                                      _benchController.text = rm1;
                                    });
                                  }
                                },
                                child:
                                    Text(AppLocalizations.of(context)!.bench)),
                            OutlinedButton(
                                onPressed: () {
                                  if (rm1 != '0.00') {
                                    setState(() {
                                      _deadliftController.text = rm1;
                                    });
                                  }
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.deadlift))
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: const [
                        Text(
                          'Percentage',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    const Divider()
                  ],
                ),
              )),
              Card(
                  child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.wilks_score,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
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
                              border: OutlineInputBorder(),
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
                              border: OutlineInputBorder(),
                              labelText: AppLocalizations.of(context)!.bench,
                              counterText: ''),
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: TextField(
                          maxLength: 6,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: false),
                          controller: _deadliftController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'\d+\.?\d*'))
                          ],
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
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
                              border: OutlineInputBorder(),
                              labelText:
                                  AppLocalizations.of(context)!.body_weight,
                              counterText: ''),
                        )),
                        const SizedBox(
                          width: 5,
                        ),
                        DropdownButton(
                            value: _bodyWeightUnit,
                            items: const [
                              DropdownMenuItem(value: 'Kg', child: Text('Kg')),
                              DropdownMenuItem(value: 'Lb', child: Text('Lb'))
                            ],
                            onChanged: (value) {
                              setState(() {
                                _bodyWeightUnit = value!;
                              });
                            }),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.gender,
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            DropdownButton(
                                value: _gender,
                                items: [
                                  DropdownMenuItem(
                                      value: '0',
                                      child: Text(
                                          AppLocalizations.of(context)!.male)),
                                  DropdownMenuItem(
                                      value: '1',
                                      child: Text(
                                          AppLocalizations.of(context)!.female))
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                }),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                          child: ElevatedButton(
                              onPressed: _onCalculateWilKs,
                              child: Text(
                                  AppLocalizations.of(context)!.calculate)),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                              DataCell(Text(
                                _totalWilksScore,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontSize: 16),
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
