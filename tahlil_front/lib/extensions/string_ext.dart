extension NullableStringExt on String? {
  String? operator +(String? other) {
    if (this == null || other == null) return null;
    return '$this$other';
  }
}

extension StringExt on String {
  String? get nullIfEmpty => isEmpty ? null : this;
}
