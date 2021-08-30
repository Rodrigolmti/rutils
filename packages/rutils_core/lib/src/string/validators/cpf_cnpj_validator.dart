class DocumentValidator {
  static bool validate(String? document) =>
      document != null && (document.length == 14 || document.length == 18);
}
