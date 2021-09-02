/// Util class where you can encapsulate two object in one object
/// Usefull when you need to return more than one object from a function.
class Tuple<L, R> {
  final L left;
  final R right;
  Tuple({
    required this.left,
    required this.right,
  });
}
