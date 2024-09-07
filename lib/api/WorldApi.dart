import 'package:get/get.dart';

import 'http.dart';

class WorldApi {
  factory WorldApi() {
    return _instance;
  }

  WorldApi._constructor();

  static final _instance = WorldApi._constructor();

  Future<Response<List<dynamic>>> list() => http.get('/api/v1/worlds');
}
