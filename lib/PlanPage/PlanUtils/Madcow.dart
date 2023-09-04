import 'dart:math';


double getStartingWeight(double rm5, int prWeek, double plateWeight) {
  return (rm5 * pow((1 / 1.025), (prWeek - 1)) / (2 * plateWeight)).round() * 2 * plateWeight;
}

double maxWeight(double startingWeight, int week, double plateWeight) {
  week = week - 1;
  return (startingWeight * pow(1.025, week) / (2 * plateWeight)).round() * 2 * plateWeight;
}

double getLastWeight(double maxWeight, double interval, int num, double plateWeight) {
  return (maxWeight * (1 - interval * num) / (2 * plateWeight)).round() * 2 * plateWeight;
}



void main() {
  // print(getStartingWeight(124, 4, 2.5));
  // print(maxWeight(95, 1, 2.5));
  print(getLastWeight(100, 0.125, 3, 2.5));
}
