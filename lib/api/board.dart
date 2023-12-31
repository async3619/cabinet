abstract class BaseBoard {
  late String id;
  late String title;

  String getName();

  @override
  String toString() {
    return 'Board(id: $id, title: $title)';
  }
}
