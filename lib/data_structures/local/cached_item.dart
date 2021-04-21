class CachedItem<T> {
  Future<T> data;
  DateTime time;

  Duration age() {
    return DateTime.now().difference(time);
  }
}