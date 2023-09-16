/**
 * Tuple class, useful when you need to return more than one object from a function.
 */
class Tuple<L, R> {
  final L left;
  final R right;
  Tuple({
    required this.left,
    required this.right,
  });
}
