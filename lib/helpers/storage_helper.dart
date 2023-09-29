import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> saveFavorites(List<int> movieIds) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(
        'favorites', movieIds.map((id) => id.toString()).toList());
  }

  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs
            .getStringList('favorites')
            ?.map((id) => int.parse(id))
            .toList() ??
        [];
  }
}
