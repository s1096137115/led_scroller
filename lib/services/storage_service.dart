import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/scroller.dart';
import '../models/group.dart';

/// 資料持久化服務
/// 負責將Scroller和Group資料儲存到本地SharedPreferences
/// 提供讀取和保存功能
class StorageService {
  static const String _scrollersKey = 'scrollers';
  static const String _groupsKey = 'groups';

  // Scrollers
  Future<List<Scroller>> getScrollers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_scrollersKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Scroller.fromJson(json)).toList();
  }

  Future<void> saveScrollers(List<Scroller> scrollers) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = scrollers.map((scroller) => scroller.toJson()).toList();
    await prefs.setString(_scrollersKey, jsonEncode(jsonList));
  }

  // Groups
  Future<List<ScrollerGroup>> getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_groupsKey);

    if (jsonString == null) {
      return [];
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => ScrollerGroup.fromJson(json)).toList();
  }

  Future<void> saveGroups(List<ScrollerGroup> groups) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = groups.map((group) => group.toJson()).toList();
    await prefs.setString(_groupsKey, jsonEncode(jsonList));
  }
}