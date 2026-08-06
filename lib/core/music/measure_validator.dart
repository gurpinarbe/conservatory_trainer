import 'measure.dart';

abstract final class MeasureValidator {
  static bool isMeasureDurationValid(Measure measure) {
    return measure.totalUnits == measure.timeSignature.measureUnits;
  }
}
