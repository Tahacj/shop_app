class HttpExcaption implements Exception {
  final String msg;

  HttpExcaption(this.msg);

  @override
  String toString() {
    return msg;
  }
}
