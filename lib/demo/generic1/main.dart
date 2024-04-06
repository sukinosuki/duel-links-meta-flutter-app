void main() {
  var box1 = Box('111');

  print('box1.content: ${box1.content}, type: ${box1.content.runtimeType}');

  var box2 = box1.rebox((value) => int.parse(value) + 233);

  print('box2.content: ${box2.content}, ${box2.content.runtimeType}');

  var list1 = [1, 2, 3];
  var list2 = [4, 5, 6];

  var list3 = [7, 8, ...list1, ...list2];

  print('list3: ${list3}');

}

class Box<T> {
  T content;

  Box(this.content);

  // Box<R> rebox<R>(R callback(T value)) {
  Box<R> rebox<R>(R Function(T value) callback) {
    return Box<R>(callback(this.content));
  }
}
