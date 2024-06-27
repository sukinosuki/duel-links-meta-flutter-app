class HttpCache {

  static Map<String, dynamic> store = {};

  static set(String key, dynamic value) {

    store[key] = value;
  }

  static get(String key) {
    return store[key];
  }
}