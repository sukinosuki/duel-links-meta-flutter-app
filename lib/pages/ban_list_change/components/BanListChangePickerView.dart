import 'dart:async';
import 'dart:developer';

import 'package:duel_links_meta/extension/Function.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../type/ban_list_change/BanListChange.dart';
import '../type/DataGroup.dart';

 int _defaultYearIndex = 0;
 int _defaultItemIndex = 0;

class BanListChangePicker extends StatefulWidget {
  const BanListChangePicker({super.key, required this.data, required this.onConfirm,});

  final List<DataGroup<BanListChange>> data;
  final Function onConfirm;


  @override
  State<BanListChangePicker> createState() => _BanListChangePickerState();
}

class _BanListChangePickerState extends State<BanListChangePicker>{
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
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
      child: Container(
        height: 240,
        padding: const EdgeInsets.only(top: 8.0),
        color: Theme.of(context).colorScheme.onPrimary,
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
                        log('change $int');

                        if (yearPickerTimer?.isActive ?? false) yearPickerTimer!.cancel();

                        yearPickerTimer = Timer(const Duration(milliseconds: 500), () {
                        log('execute');

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
                    child: Container(
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
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ElevatedButton(
                onPressed: ()  {
                  log('confirm: $selectedYearKey, $selectedItemKey');
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
