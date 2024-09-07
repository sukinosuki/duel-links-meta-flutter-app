
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

extension StringEx on String {
  void toast() {
    SmartDialog.showToast(this, alignment: const Alignment(0, 0.8));
  }

  void copy(String? toastText) {
    Clipboard.setData(ClipboardData(text: this));

    if (toastText != null) {
      toastText.toast();
      // SmartDialog.showToast('已复制sql', alignment: const Alignment(0, 0.8));
    }
  }
}