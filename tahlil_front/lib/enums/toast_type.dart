import 'package:flutter/material.dart';

enum ToastType {
  error,
  success;

  Color get backgroundColor {
    switch (this) {
      case ToastType.error:
        return Colors.red.shade100;
      case ToastType.success:
        return Colors.green.shade100;
    }
  }

  Color get foregroundColor {
    switch (this) {
      case ToastType.error:
        return Colors.red.shade900;
      case ToastType.success:
        return Colors.green.shade900;
    }
  }
}
