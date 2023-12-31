abstract class BasePost {
  late int id;
  late String? title;
  late String? content;
  late String? author;
  late DateTime? createdAt;

  @override
  String toString() {
    return 'Post(id: $id, title: $title, content: $content, author: $author, createdAt: $createdAt)';
  }
}
