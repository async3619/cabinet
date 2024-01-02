abstract class BaseTask {
  final Function()? _onStart;
  final Function()? _onComplete;
  final Function(dynamic)? _onError;
  final Function()? _onDone;

  BaseTask({
    dynamic Function()? onStart,
    dynamic Function()? onComplete,
    dynamic Function(dynamic)? onError,
    dynamic Function()? onDone,
  })  : _onStart = onStart,
        _onComplete = onComplete,
        _onError = onError,
        _onDone = onDone;

  Future<void> run() {
    if (_onStart != null) {
      _onStart();
    }

    return doTask().then((value) {
      if (_onComplete != null) {
        _onComplete();
      }
    }).catchError((error) {
      handleError(error);
    }).whenComplete(() {
      if (_onDone != null) {
        _onDone();
      }
    });
  }

  Future<void> doTask();

  void handleError(dynamic error) {
    if (_onError != null) {
      _onError(error);
    }
  }
}
