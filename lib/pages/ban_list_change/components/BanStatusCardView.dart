import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/extension/Future.dart';
import 'package:duel_links_meta/util/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/MdCardItemView.dart';
import '../../../http/CardApi.dart';
import '../../../type/MdCard.dart';
import '../../../type/enum/PageStatus.dart';
import '../../cards_viewpager/index.dart';

class BanStatusCardView extends StatefulWidget {
  const BanStatusCardView({super.key});

  @override
  State<BanStatusCardView> createState() => _BanStatusCardViewState();
}

class _BanStatusCardViewState extends State<BanStatusCardView> with AutomaticKeepAliveClientMixin {
  Map<String, List<MdCard>> banStatus2CardsGroup = {};
  var _pageStatus = PageStatus.loading;

  void handleTapCardItem(List<MdCard> cards, int index) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  Future<void> fetchCards() async {
    final params = <String, String>{
      'limit': '0',
      r'banStatus[$exists]': 'true',
      r'alternateArt[$ne]': 'true',
      r'rush[$ne]': 'true',
    };

    final (err, res) = await CardApi().list(params).toCatch;
    if (err != null) {
      setState(() {
        _pageStatus = PageStatus.fail;
      });
      return;
    }
    final list = res!.map(MdCard.fromJson).toList();

    final group = <String, List<MdCard>>{
      'Forbidden': [],
      'Limited 1': [],
      'Limited 2': [],
      'Limited 3': [],
    };

    list.forEach((item) {
      group[item.banStatus]?.add(item);
    });

    setState(() {
      banStatus2CardsGroup = group;
      _pageStatus = PageStatus.success;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        AnimatedOpacity(
          opacity: _pageStatus == PageStatus.success?1:0,
          duration: const Duration(milliseconds: 400),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: banStatus2CardsGroup.keys.map((key) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SvgPicture.asset('assets/images/icon_${key.toLowerCase()}.svg', width: 20, height: 20),
                          ),
                          const SizedBox(width: 4),
                          Text(key, style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: banStatus2CardsGroup[key]!.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5, childAspectRatio: 0.57, crossAxisSpacing: 6),
                            itemBuilder: (context, index) {
                              return MdCardItemView(
                                mdCard: banStatus2CardsGroup[key]![index],
                                onTap: (card) => handleTapCardItem(banStatus2CardsGroup[key]!, index),
                              );
                            }),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),

        if (_pageStatus == PageStatus.loading) const Positioned.fill(child: Center(child: Loading()))
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
