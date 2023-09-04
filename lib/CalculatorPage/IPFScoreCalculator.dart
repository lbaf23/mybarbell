import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'CalculateUtils.dart';
import 'Style.dart';

class IPFScoreCalculatorPage extends StatefulWidget {
  const IPFScoreCalculatorPage({super.key});

  void clearData() => _IPFScoreCalculatorPageState()._clearData();

  @override
  State<IPFScoreCalculatorPage> createState() => _IPFScoreCalculatorPageState();
}

const zeroStr = '0.00';

class _IPFScoreCalculatorPageState extends State<IPFScoreCalculatorPage> {
  final _bodyWeightController = TextEditingController();
  var _wkWeightUnit = 'Kg';
  var _gender = '0';

  var _event = 0;
  var _category = 0;

  final _totalController = TextEditingController();

  var _ipfScore = zeroStr;
  var _ipfGLScore = zeroStr;

  void _clearData() {
    _bodyWeightController.text = '';
    _totalController.text = '';
    setState(() {
      _ipfScore = zeroStr;
      _ipfGLScore = zeroStr;
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
    int liftType = _category + _event;
    _onCalculateGL(bodyWeight, total, g, liftType);
    _onCalculateIPF(bodyWeight, total, g, liftType);
  }

  void _onCalculateIPF(
      double bodyWeight, double total, int gender, int liftType) {
    var score = calculateIPFScore(bodyWeight, gender, liftType, total);
    setState(() {
      _ipfScore = score.toStringAsFixed(2);
    });
  }

  void _onCalculateGL(
      double bodyWeight, double total, int gender, int liftType) {
    var score = calculateGLScore(bodyWeight, gender, liftType, total);
    setState(() {
      _ipfGLScore = score.toStringAsFixed(2);
    });
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
            const SizedBox(
              width: 10,
            ),
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
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(AppLocalizations.of(context)!.gender, style: inputStyle),
            const SizedBox(
              width: 10,
            ),
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
            const SizedBox(
              width: 20,
            ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.event,
              style: inputStyle,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                  title: Text(AppLocalizations.of(context)!.equipped),
                  value: 0,
                  groupValue: _event,
                  onChanged: (value) {
                    if (_event != value) {
                      setState(() {
                        _event = value!;
                      });
                      _onCalculateScore(_gender);
                    }
                  }),
            ),
            Expanded(
              child: RadioListTile(
                  title: Text(AppLocalizations.of(context)!.raw),
                  value: 1,
                  groupValue: _event,
                  onChanged: (value) {
                    if (_event != value) {
                      setState(() {
                        _event = value!;
                      });
                      _onCalculateScore(_gender);
                    }
                  }),
            )
          ],
        ),
        divider,
        smallHeightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.category,
              style: inputStyle,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                  title: Text(AppLocalizations.of(context)!.full_meet),
                  value: 0,
                  groupValue: _category,
                  onChanged: (value) {
                    if (_category != value) {
                      setState(() {
                        _category = value!;
                      });
                      _onCalculateScore(_gender);
                    }
                  }),
            ),
            Expanded(
              child: RadioListTile(
                  title: Text(AppLocalizations.of(context)!.bench_only),
                  value: 2,
                  groupValue: _category,
                  onChanged: (value) {
                    if (_category != value) {
                      setState(() {
                        _category = value!;
                      });
                      _onCalculateScore(_gender);
                    }
                  }),
            )
          ],
        ),
        divider,
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
        largeHeightBox,
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
                          Text(AppLocalizations.of(context)!.ipf_gl_score)),
                      DataCell(Text(_ipfGLScore)),
                    ]),
                    DataRow(cells: [
                      DataCell(Text(AppLocalizations.of(context)!.ipf_score)),
                      DataCell(Text(_ipfScore)),
                    ]),
                  ]),
            )
          ],
        ),
      ],
    );
  }
}
