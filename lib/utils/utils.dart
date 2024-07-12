class Utils {
  static String capitalize(String text) {
    return text
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
