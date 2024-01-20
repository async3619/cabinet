extension Unique<E, Id> on List<E> {
  List<E> unique([Id Function(E element)? id]) {
    final ids = <Id>{};
    var list = List<E>.from(this);
    list.retainWhere((x) => ids.add(id != null ? id(x) : x as Id));

    return list;
  }
}
