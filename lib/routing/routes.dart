abstract final class Routes {
  static const home = "/";
  static const discover = "/$discoverRelative";
  static const discoverRelative = "discover";
  static const library = "/$libraryRelative";
  static const libraryRelative = "library";
  static const author = "/$authorRelative";
  static const authorRelative = "author";
  static String authorWithId(String id) => '$author/$id';
  static const audiobook = "/$audiobookRelative";
  static const audiobookRelative = "audiobook";
  static String audiobookWithId(String id) => '$audiobook/$id';
  static const settingsRelative = "settings";
  static const settings = "/$settingsRelative";
  static const playerRelative = "player";
  static const player = "/$playerRelative";
}
