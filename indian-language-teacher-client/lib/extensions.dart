extension ListExtension<E> on List<E> {
  List<List<E>> chunked(int size) {
    List<List<E>> chunks = [];
    for (int i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
