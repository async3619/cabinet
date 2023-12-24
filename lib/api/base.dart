import 'package:http/http.dart' as http;

import 'board.dart';

abstract class BaseApi<TBoard extends BaseBoard> {
  final http.Client client = http.Client();

  Future<List<TBoard>> getBoards();
}
