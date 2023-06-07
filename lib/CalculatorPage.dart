import 'package:flutter/material.dart';
import 'package:mybarbell/CalculatorPage/OneRepMaxCalculator.dart';
import 'CalculatorPage/WilksScoreCalculator.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            children: const [
              OneRepMaxCalculatorPage(),
              WilksScoreCalculatorPage(),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ));
  }
}
