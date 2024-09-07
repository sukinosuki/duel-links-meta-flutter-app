import 'package:duel_links_meta/type/pack_set/PackSet.dart';
import 'package:get/get.dart';

import 'http.dart';

class PackSetApi {
  factory PackSetApi(){
    return _instance;
  }
  PackSetApi._constructor();
  static final _instance = PackSetApi._constructor();

  Future<Response<List<PackSet>>> list() => http.get(
        '/api/v1/sets?sort=-release&limit=0',
        decoder: (data) => (data as List<dynamic>).map(PackSet.fromJson).toList(),
      );
}
