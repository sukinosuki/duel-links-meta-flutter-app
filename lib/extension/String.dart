
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

extension StringEx on String {
  toast() {
    print('[toast] $this');

    SmartDialog.showToast(this, alignment: const Alignment(0, 0.8));
  }

  copy(String? toastText) {
    print('toastText:  $toastText');

    Clipboard.setData(ClipboardData(text: this));

    if (toastText != null) {
      toastText.toast();
      // SmartDialog.showToast('已复制sql', alignment: const Alignment(0, 0.8));
    }
  }
}