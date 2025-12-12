import 'dart:ui';

// https://stackoverflow.com/a/65992768/10030480
extension FullName on Locale {
  String fullName() {
    switch (languageCode) {
      case "en":
        return "English";
      case "pa":
        return "ਪੰਜਾਬੀ";
    }
    return "";
  }
}
