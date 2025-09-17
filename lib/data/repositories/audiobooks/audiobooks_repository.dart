class AudiobooksRepository {
  /// Fetches Author List from server or local (if available)
  /// First checks if the "data_version" from realtime database
  /// and compares with locally saved in shared prefs
  /// - updates local text data, if obsolete
  /// - downloads any author images, if missing or obsolete
  // Future<List<Author>> fetchAuthorList()
}
