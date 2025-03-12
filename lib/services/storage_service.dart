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

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Scroller.fromJson(json)).toList();
    } catch (e) {
      print('Error loading scrollers: $e');
      // 出現錯誤時返回空列表，避免應用崩潰
      return [];
    }
  }

  Future<bool> saveScrollers(List<Scroller> scrollers) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 將每個 Scroller 轉換為 JSON 並打印，用於調試
      final jsonList = scrollers.map((scroller) {
        final json = scroller.toJson();
        print('Saving scroller: ${scroller.id} with text: ${scroller.text}');
        print('JSON: $json');
        return json;
      }).toList();

      // 將整個列表序列化並保存
      final jsonString = jsonEncode(jsonList);
      final result = await prefs.setString(_scrollersKey, jsonString);

      print('Save result: $result');
      print('Saved JSON string length: ${jsonString.length}');

      return result;
    } catch (e) {
      print('Error saving scrollers: $e');
      return false;
    }
  }

  // Groups
  Future<List<ScrollerGroup>> getGroups() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_groupsKey);

    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => ScrollerGroup.fromJson(json)).toList();
    } catch (e) {
      print('Error loading groups: $e');
      // 出現錯誤時返回空列表，避免應用崩潰
      return [];
    }
  }

  Future<bool> saveGroups(List<ScrollerGroup> groups) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 將每個 Group 轉換為 JSON 並打印，用於調試
      final jsonList = groups.map((group) {
        final json = group.toJson();
        print('Saving group: ${group.id} with name: ${group.name}');
        print('JSON: $json');
        return json;
      }).toList();

      // 將整個列表序列化並保存
      final jsonString = jsonEncode(jsonList);
      final result = await prefs.setString(_groupsKey, jsonString);

      print('Save result: $result');
      print('Saved JSON string length: ${jsonString.length}');

      return result;
    } catch (e) {
      print('Error saving groups: $e');
      return false;
    }
  }
}