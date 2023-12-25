abstract class BaseTask {
  final Function()? onStart;
  final Function()? onComplete;
  final Function(dynamic)? onError;
  final Function()? onDone;

  BaseTask({
    this.onStart,
    this.onComplete,
    this.onError,
    this.onDone,
  });

  Future<void> run() {
    if (onStart != null) {
      onStart!();
    }

    return doTask().then((value) {
      if (onComplete != null) {
        onComplete!();
      }
    }).catchError((error) {
      if (onError != null) {
        onError!(error);
      }
    }).whenComplete(() {
      if (onDone != null) {
        onDone!();
      }
    });
  }

  Future<void> doTask();
}
