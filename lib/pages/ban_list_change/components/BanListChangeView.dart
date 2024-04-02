import 'package:cached_network_image/cached_network_image.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:rive/rive.dart';

import '../../../http/BanListChangeApi.dart';
import '../../../type/ban_list_change/BanListChange.dart';
import '../../../util/time_util.dart';
import '../type/DataGroup.dart';
import 'BanListChangePickerView.dart';

class BanListChangeView extends StatefulWidget {
  const BanListChangeView({super.key});

  @override
  State<BanListChangeView> createState() => _BanListChangeViewState();
}

class _BanListChangeViewState extends State<BanListChangeView> with AutomaticKeepAliveClientMixin {
  var _pageStatus = PageStatus.loading;

  List<BanListChange> banListChanges = [];

  List<DataGroup<BanListChange>> _yearsGroup2 = [];

  BanListChange? currentBanListChange;

  //
  fetchBanListChanges() async {
    var params = {
      'rush[\$ne]': 'true',
      'sort': '-date,-announced',
    };

    var res = await BanListChangeApi().list(params: params);
    var list = res.body!.map((e) => BanListChange.fromJson(e)).toList();
    var formatter = DateFormat('MM-dd');

    List<DataGroup<BanListChange>> dataGroupList = [];

    list.forEach((item) {
      var year = item.date?.year ?? item.announced?.year;
      item.formattedMonthDay = formatter.format((item.date ?? item.announced)!);

      var index = dataGroupList.indexWhere((element) => element.name == year.toString());

      if (index != -1) {
        dataGroupList[index].items.add(item);
      } else {
        dataGroupList.add(DataGroup(name: year.toString(), items: [item]));
      }
    });

    dataGroupList.forEach((element) {
      element.items.sort((a, b) => b.formattedMonthDay.compareTo(a.formattedMonthDay));
    });

    setState(() {
      _yearsGroup2 = dataGroupList;
      currentBanListChange = dataGroupList[0].items[0];
      banListChanges = list;
      _pageStatus = PageStatus.success;
    });
  }

  _handlePickerConfirm(int yearIndex, int itemIndex) {
    var banListChange = _yearsGroup2[yearIndex].items[itemIndex];

    setState(() {
      currentBanListChange = banListChange;
    });

    Navigator.pop(context);
  }

  showChangePicker() {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BanListChangePicker(data: _yearsGroup2, onConfirm: _handlePickerConfirm),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchBanListChanges();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        AnimatedOpacity(
          opacity: _pageStatus ==PageStatus.success?1:0,
          duration: const Duration(milliseconds: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Updates'),
                      GestureDetector(
                        onTap: showChangePicker,
                        child: Row(
                          children: [
                            Text(TimeUtil.format(currentBanListChange?.date ?? currentBanListChange?.announced)),
                            const Icon(Icons.keyboard_arrow_down, size: 16),
                          ],
                        ),
                      )
                    ],
                  )),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: currentBanListChange?.changes.length ?? 0,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                    width: 45,
                                    height: 45 * 1.46,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        'https://s3.duellinksmeta.com/cards/${currentBanListChange!.changes[index].card?.oid}_w100.webp'),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      currentBanListChange!.changes[index].card?.name ?? '',
                                    ),
                                    Row(
                                      children: [
                                        const Text('From: ', style: TextStyle(fontSize: 11)),
                                        Text(
                                          currentBanListChange!.changes[index].from ?? '—',
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text('To: ', style: TextStyle(fontSize: 11)),
                                        Text(
                                          currentBanListChange!.changes[index].to ?? '—',
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        if (_pageStatus == PageStatus.loading)
          const Positioned.fill(
              child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
            ),
          ))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
