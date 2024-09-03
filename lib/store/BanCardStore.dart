import 'package:duel_links_meta/type/MdCard.dart';
import 'package:duel_links_meta/type/enum/PageStatus.dart';
import 'package:get/get.dart';

class BanCardStore extends GetxController {

  RxList<MdCard> cards = <MdCard>[].obs;

  Rx<PageStatus> pageStatus = PageStatus.loading.obs;

  Map<String, MdCard> idToCardMap = {};

  Rx<Map<String, List<MdCard>>> group = Rx<Map<String, List<MdCard>>>({
    'Forbidden': [],
    'Limited 1': [],
    'Limited 2': [],
    'Limited 3': [],
  });

  void setCards(List<MdCard> data) {
    final _group = <String, List<MdCard>>{
      'Forbidden': [],
      'Limited 1': [],
      'Limited 2': [],
      'Limited 3': [],
    };
    data.forEach((item) {
      _group[item.banStatus]?.add(item);

      idToCardMap[item.oid] = item;
    });

    group.value = _group;
    cards.value = data;
  }

  void setPageStatus(PageStatus value) {
    pageStatus.value = value;
  }
}