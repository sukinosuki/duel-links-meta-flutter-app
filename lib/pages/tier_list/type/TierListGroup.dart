import 'package:duel_links_meta/type/TierList_TopTier.dart';

class TierListGroup {
  int tier;
  List<TierList_TopTier> deckTypes;

  String desc;

  TierListGroup({required this.tier, required this.deckTypes, required this.desc});
}
