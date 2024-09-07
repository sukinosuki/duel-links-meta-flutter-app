import 'dart:async';

import 'package:duel_links_meta/components/ModalBottomSheetWrap.dart';
import 'package:duel_links_meta/pages/ban_list_change/type/DataGroup.dart';
import 'package:duel_links_meta/type/ban_list_change/BanListChange.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

int _defaultYearIndex = 0;
int _defaultItemIndex = 0;

class BanListChangePicker extends StatefulWidget {
  const BanListChangePicker({
    required this.data,
    required this.onConfirm,
    super.key,
  });

  final List<DataGroup<BanListChange>> data;
  final void Function(int index1, int index2) onConfirm;

  @override
  State<BanListChangePicker> createState() => _BanListChangePickerState();
}

class _BanListChangePickerState extends State<BanListChangePicker> {
  List<String> get years => widget.data.map((e) => e.name).toList();

  Timer? yearPickerTimer;
  Timer? itemPickerTimer;

  int selectedYearKey = 0;
  int selectedItemKey = 0;

  late FixedExtentScrollController _controller;

  @override
  void initState() {
    setState(() {
      selectedYearKey = _defaultYearIndex;
      selectedItemKey = _defaultItemIndex;
    });
    _controller = FixedExtentScrollController(initialItem: _defaultItemIndex);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalBottomSheetWrap(
      child: Container(
        height: 240,
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 32,
                      scrollController: FixedExtentScrollController(initialItem: selectedYearKey),
                      // onSelectedItemChanged: (int selectedItem) {
                      //   log('change, int: ${selectedItem}');
                      // }.debounce(1000),
                      onSelectedItemChanged: (int selectedItem) {
                        if (yearPickerTimer?.isActive ?? false) yearPickerTimer!.cancel();

                        yearPickerTimer = Timer(const Duration(milliseconds: 500), () {
                          setState(() {
                            selectedYearKey = selectedItem;

                            selectedItemKey = 0;
                          });

                          _controller.jumpTo(0);
                        });
                      },
                      children: years.map((item) {
                        return Center(child: Text(item));
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.22,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 32,
                      scrollController: _controller,
                      onSelectedItemChanged: (int selectedItem) {
                        if (itemPickerTimer?.isActive ?? false) itemPickerTimer!.cancel();

                        itemPickerTimer = Timer(const Duration(milliseconds: 500), () {
                          setState(() {
                            selectedItemKey = selectedItem;
                          });
                        });
                      },
                      children: widget.data[selectedYearKey].items.map((item) {
                        return Center(
                          child: Text(item.formattedMonthDay),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ElevatedButton(
                onPressed: () {
                  _defaultItemIndex = selectedItemKey;
                  _defaultYearIndex = selectedYearKey;
                  widget.onConfirm(selectedYearKey, selectedItemKey);
                },
                child: const Text('OK'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
