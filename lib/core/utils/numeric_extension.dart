extension IntFormatting on int {
  String toTwoDigitString() {
    return this < 100 ? toString().padLeft(2, '0') : toString();
  }
}

extension DoubleFormatting on double {
  String toPointerAsFixed(int count) {
    return this % 1 == 0 ? toInt().toString() : toStringAsFixed(count);
  }
}
