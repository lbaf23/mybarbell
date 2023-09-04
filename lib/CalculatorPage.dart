import 'package:flutter/material.dart';
import 'package:mybarbell/CalculatorPage/OneRepMaxCalculator.dart';
import 'CalculatorPage/ScoreCalculator.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              OneRepMaxCalculatorPage(),
              ScoreCalculatorPage(),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ));
  }
}
