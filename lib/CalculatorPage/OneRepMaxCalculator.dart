import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'Style.dart';
import 'CalculateUtils.dart';


class OneRepMaxCalculatorPage extends StatefulWidget {
  const OneRepMaxCalculatorPage({super.key});

  @override
  State<OneRepMaxCalculatorPage> createState() => _OneRepMaxCalculatorPageState();
}

const zeroStr = '0.00';
const noLevel = '    ';

const percentagesData = [
  '110%',
  '105%',
  '100%',
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
  '0',
  '0',
  '1',
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
  zeroStr,
  zeroStr,
  zeroStr,
  zeroStr
];

class _OneRepMaxCalculatorPageState extends State<OneRepMaxCalculatorPage> {
  var _formula = Formula[0];

  var _weightUnit = 'Kg';
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  var _rm1 = zeroStr;

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
    for (int i = 0; i < 14; i++) {
      percentagesWeight[i] = ((110 - 5 * i) / 100.0 * rm1).toStringAsFixed(2);
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
    return Card(child: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.one_rep_max_calculator,
                style: titleStyle
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
                style: inputStyle
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
                          child: Text(value, style: inputStyle),
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
                  maxLength: inputTextMaxLength,
                  controller: _weightController,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: false),
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: AppLocalizations.of(context)!.weight,
                      counterText: ''),
                  style: inputStyle
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
                  DropdownMenuItem(value: 'Kg', child: Text('Kg', style: inputStyle)),
                  DropdownMenuItem(value: 'Lb', child: Text('Lb', style: inputStyle))
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: TextField(
                  maxLength: inputTextMaxLength,
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
                  style: inputStyle,
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
                      height: 40,
                      child: ElevatedButton(
                          onPressed: () {
                            _onCalculate1RM(_formula);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.calculate,
                            style: buttonStyle
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
                  GestureDetector(
                    onTap: () {
                      if (_rm1 != zeroStr) {
                        Clipboard.setData(ClipboardData(text: _rm1));
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(AppLocalizations.of(context)!.one_rep_copied))
                        );
                      }
                    },
                    child: Text(
                      _rm1,
                      style: TextStyle(
                          fontSize: 45,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary
                      ),
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
    ));
  }
}
