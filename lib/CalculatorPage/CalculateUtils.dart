import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

// wilks score 1.0
// gender [male, female]
const wk_a = [-216.0475144, 594.31747775582];
const wk_b = [16.2606339, -27.23842536447];
const wk_c = [-0.002388645, 0.82112226871];
const wk_d = [-0.00113732, -0.00930733913];
const wk_e = [7.01863E-06, 4.731582E-05];
const wk_f = [-1.291E-08, -9.054E-08];

// wilks score 2.0
const wk2_a = [47.4617885411949, -125.425539779509];
const wk2_b = [8.47206137941125, 13.7121941940668];
const wk2_c = [0.073694103462609, -0.0330725063103405];
const wk2_d = [-0.00139583381094385, -0.0010504000506583];
const wk2_e = [7.07665973070743E-06, 9.38773881462799E-06];
const wk2_f = [-1.20804336482315E-08, -2.3334613884954E-08];

double calculateWilksScore(
    double bodyWeight, int gender, double bellWeight, int version) {
  // wilks score 1.0
  if (version == 1) {
    return bellWeight *
        500.0 /
        (wk_a[gender] +
            wk_b[gender] * bodyWeight +
            wk_c[gender] * pow(bodyWeight, 2) +
            wk_d[gender] * pow(bodyWeight, 3) +
            wk_e[gender] * pow(bodyWeight, 4) +
            wk_f[gender] * pow(bodyWeight, 5));
  }
  // wilks score 2.0
  return bellWeight *
      600.0 /
      (wk2_a[gender] +
          wk2_b[gender] * bodyWeight +
          wk2_c[gender] * pow(bodyWeight, 2) +
          wk2_d[gender] * pow(bodyWeight, 3) +
          wk2_e[gender] * pow(bodyWeight, 4) +
          wk2_f[gender] * pow(bodyWeight, 5));
}

List calculateWilksLevel(double score, BuildContext context) {
  if (score < 120) {
    return [AppLocalizations.of(context)!.untrained, Colors.grey];
  } else if (score < 200) {
    return [AppLocalizations.of(context)!.beginner, Colors.green];
  } else if (score < 238) {
    return [AppLocalizations.of(context)!.novice, Colors.lightBlue];
  } else if (score < 326) {
    return [AppLocalizations.of(context)!.intermediate, Colors.yellow];
  } else if (score < 414) {
    return [AppLocalizations.of(context)!.advanced, Colors.orange];
  } else {
    return [AppLocalizations.of(context)!.elite, Colors.red];
  }
}

// [ Equipped, Classic, Equipped Bench, Classic Bench ]
// gender 0 male 1 female
const gl_A = [
  [1236.25115, 1199.72839, 381.22073, 320.98041],
  [758.63878, 610.32796, 221.82209, 142.40398]
];
const gl_B = [
  [1449.21864, 1025.18162, 733.79378, 281.40258],
  [949.31382, 1045.59282, 357.00377, 442.52671]
];
const gl_C = [
  [0.01644, 0.00921, 0.02398, 0.01008],
  [0.02435, 0.03048, 0.02937, 0.04724]
];
const e = 2.718281828;

double calculateGLScore(
    double bodyWeight, int gender, int liftType, double bellWeight) {
  return 100.0 /
      (gl_A[gender][liftType] -
          gl_B[gender][liftType] *
              pow(e, -gl_C[gender][liftType] * bodyWeight)) *
      bellWeight;
}

const ipf_C1 = [
  [387.265, 310.67, 133.94, 86.4745],
  [176.58, 125.1435, 49.106, 25.0485]
];
const ipf_C2 = [
  [1121.28, 857.785, 441.465, 259.155],
  [373.315, 228.03, 124.209, 43.848]
];
const ipf_C3 = [
  [80.6324, 53.216, 35.3938, 17.57845],
  [48.4534, 34.5246, 23.199, 6.7172]
];
const ipf_C4 = [
  [222.4896, 147.0835, 113.0057, 53.122],
  [110.0103, 86.8301, 67.4926, 13.952]
];

double calculateIPFScore(
    double bodyWeight, int gender, int liftType, double bellWeight) {
  return 500.0 +
      100.0 *
          (bellWeight -
              (ipf_C1[gender][liftType] * ln(bodyWeight)) +
              ipf_C2[gender][liftType]) /
          (ipf_C3[gender][liftType] * ln(bodyWeight) -
              ipf_C4[gender][liftType]);
}

double ln(double x) {
  return log(x) / log(e);
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

const dots_A = [-1.093E-06, -1.0706E-06];
const dots_B = [7.391293E-04, 5.158586E-04];
const dots_C = [-0.1918759221, -0.1126655495];
const dots_D = [24.0900756, 13.6175032];
const dots_E = [-307.75076, -57.96288];

double calculateDotsScore(
  double bodyWeight,
  int gender,
  double bellWeight,
) {
  return bellWeight *
      500.0 /
      (dots_A[gender] * pow(bodyWeight, 4) +
          dots_B[gender] * pow(bodyWeight, 3) +
          dots_C[gender] * pow(bodyWeight, 2) +
          dots_D[gender] * bodyWeight +
          dots_E[gender]);
}
