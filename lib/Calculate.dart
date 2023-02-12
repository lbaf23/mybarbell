import 'dart:math';

import 'package:flutter/material.dart';

var Formula = <String>['Beachle', 'Brzycky', 'Epley'];

double calculate1RM(
    String formula, String weightUnit, double weight, int reps) {
  if (formula == Formula[0]) {
    return weight * (1 + (0.033 * reps));
  } else if (formula == Formula[1]) {
    return weight / (1.0278 - 0.0278 * reps);
  } else if (formula == Formula[2]) {
    return weight * (1 + reps / 30.0);
  }
  return 0;
}

// wilks
// [male, female]
const a = [-216.0475144, 594.31747775582];
const b = [16.2606339, -27.23842536447];
const c = [-0.002388645, 0.82112226871];
const d = [-0.00113732, -0.00930733913];
const e = [7.01863E-06, 4.731582E-05];
const f = [-1.291E-08, -9.054E-08];

double calculateWilksScore(
    String bodyWeightUnit, double bodyWeight, int gender, double bellWeight) {
  if(bodyWeightUnit == 'Lb') {
    bodyWeight = lb2kg(bodyWeight);
    bellWeight = lb2kg(bellWeight);
  }
  return bellWeight *
      500.0 /
      (a[gender] +
          b[gender] * bodyWeight +
          c[gender] * pow(bodyWeight, 2) +
          d[gender] * pow(bodyWeight, 3) +
          e[gender] * pow(bodyWeight, 4) +
          f[gender] * pow(bodyWeight, 5));
}

List calculateWilksLevel(double score) {
  if (score < 120) {
    return ['Untrained', Colors.grey];
  } else if (score < 200) {
    return ['Beginner', Colors.green];
  } else if (score < 238) {
    return ['Novice', Colors.lightBlue];
  } else if (score < 326) {
    return ['Intermediate', Colors.yellow];
  } else if (score < 414) {
    return ['Advanced', Colors.orange];
  } else {
    return ['Elite', Colors.red];
  }
}

double lb2kg(double lb) {
  return lb * 0.45359237;
}

double kg2lb(double kg) {
  return kg / 0.45359237;
}

String formatDouble(double d) {
  return d.toStringAsFixed(2);
}
