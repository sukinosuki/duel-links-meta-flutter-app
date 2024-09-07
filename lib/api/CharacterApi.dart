import 'package:get/get.dart';

import 'http.dart';

class CharacterApi {

  factory CharacterApi() {
    return _instance;
  }
  CharacterApi._constructor();

  static final _instance = CharacterApi._constructor();

  Future<Response<List>> list() => http.get('/api/v1/characters?npc[\$ne]=true&limit=0&sort=-linkedArticle.date');
}
