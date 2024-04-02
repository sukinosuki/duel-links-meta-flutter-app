import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../components/MdCardItemView.dart';
import '../../../components/MdCardsBoxLayout.dart';
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

  handleTapCardItem(List<MdCard> cards, int index) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  fetchCards() async {
    Map<String, String> params = {
      'limit': '0',
      'banStatus[\$exists]': 'true',
      'alternateArt[\$ne]': 'true',
      'rush[\$ne]': 'true',
    };

    var res = await CardApi().list(params);
    var list = res.body!.map((e) => MdCard.fromJson(e)).toList();

    Map<String, List<MdCard>> group = {
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(8),
      child: Column(
        children: banStatus2CardsGroup.keys.map((key) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Padding(
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, childAspectRatio: 0.57, crossAxisSpacing: 6),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
