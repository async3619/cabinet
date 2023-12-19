import 'package:cabinet/models/board/base.dart';
import 'package:http/http.dart' as http;

abstract class BaseApi<TBoard extends BaseBoard> {
  final http.Client client = http.Client();

  Future<List<TBoard>> getBoards();
}
