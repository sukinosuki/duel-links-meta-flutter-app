import 'package:duel_links_meta/components/Loading.dart';
import 'package:duel_links_meta/components/MdCardItemView2.dart';
import 'package:duel_links_meta/pages/cards_viewpager/index.dart';
import 'package:duel_links_meta/pages/top_decks/type/Group.dart';
import 'package:duel_links_meta/store/BanCardStore.dart';
import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BanStatusCardView extends StatefulWidget {
  const BanStatusCardView({super.key});

  @override
  State<BanStatusCardView> createState() => _BanStatusCardViewState();
}

class _BanStatusCardViewState extends State<BanStatusCardView> with AutomaticKeepAliveClientMixin {
  BanCardStore banCardsStore = Get.put(BanCardStore());

  List<Group<MdCard>> get groups1 => [
        Group(key: 'Forbidden', data: banCardsStore.group.value['Forbidden'] ?? []),
        Group(key: 'Limited 1', data: banCardsStore.group.value['Limited 1'] ?? []),
        Group(key: 'Limited 2', data: banCardsStore.group.value['Limited 2'] ?? []),
        Group(key: 'Limited 3', data: banCardsStore.group.value['Limited 3'] ?? [])
      ];

  var _initFlag = false;

  //
  void handleTapCardItem(List<MdCard> cards, int index) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog.fullscreen(
        backgroundColor: Colors.black87.withOpacity(0.3),
        child: CardsViewpagerPage(cards: cards, index: index),
      ),
    );
  }

  Future<void> init() async {
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() {
      _initFlag = true;
    });
  }

  Future<void> _handleRefresh() async {
    await banCardsStore.fetchData();
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Obx(
            () => AnimatedOpacity(
              opacity: (banCardsStore.pageStatus.value == PageStatus.success && _initFlag) ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Column(
                  children: groups1
                      .map(
                        (group) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: SvgPicture.asset(
                                      'assets/images/icon_${group.key.toLowerCase()}.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    group.key,
                                    style: const TextStyle(fontSize: 20),
                                  ),
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
                                  itemCount: group.data.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 5,
                                    childAspectRatio: 0.57,
                                    crossAxisSpacing: 6,
                                  ),
                                  itemBuilder: (context, cardIndex) {
                                    return MdCardItemView2(
                                      id: group.data[cardIndex].oid,
                                      mdCard: group.data[cardIndex],
                                      onTap: (card) => handleTapCardItem(group.data, cardIndex),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          Obx(
            () {
              return banCardsStore.pageStatus.value == PageStatus.loading
                  ? const Positioned.fill(
                      child: Center(
                        child: Loading(),
                      ),
                    )
                  : const SizedBox();
            },
          ),
          Obx(() => banCardsStore.pageStatus.value == PageStatus.fail
              ? const SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                )
              : const SizedBox()),
          Obx(() => banCardsStore.pageStatus.value == PageStatus.fail
              ? const Center(
                  child: Text('Loading failed'),
                )
              : const SizedBox(),),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
