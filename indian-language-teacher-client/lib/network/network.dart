import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:indian_language_teacher/Screens/home_screen.dart';
import 'package:indian_language_teacher/data/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Networker {
  static const remote = true;
  static const String baseUrl = "http://veermetri05.pythonanywhere.com/api/";
  static const String baseUrlStaticData = remote
      ? "http://veermetri05.pythonanywhere.com/static/Language/"
      : "http://192.168.1.3/ILT/Language/";
  static final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  static final Dio _dioStaticData = Dio(BaseOptions(
    baseUrl: baseUrlStaticData,
  ));

  static setLocalToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userToken", token);
  }

  static Future<String?> getLocalToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("userToken");
  }

  static Future removeLocalToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("userToken");
    return;
  }

  static getUserToken(
      {required String phoneNumber, required String firebaseToken}) async {
    Response res = await _dio.post("login",
        data: {"ph_number": phoneNumber, "firebase_token": firebaseToken});
    return await res.data;
  }

  static Future<Response> getLanguage(String langName) async {
    try {
      return await _dioStaticData.get("$langName/language.json");
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<String> getSavedLanguage() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("language") ?? "English";
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future setSavedLanguage(String langName) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("language", langName);
      return;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<UnitButton>> getBasicCharUnits(
      String langName, Function updateParent) async {
    try {
      int progress = await getUnitProgress(availableLanguagesAbbr[
          availableLanguages.indexOf(await getSavedLanguage())]);
      debugPrint("Progress in $langName is $progress");
      Response res = await _dioStaticData.get("$langName/language.json");
      List<UnitButton> unitButtons = [];
      debugPrint(res.data['units'].toString());
      for (var lessonButton in res.data['units']) {
        String unitId = lessonButton['unitID'].toString();
        unitButtons.add(UnitButton(
          type: lessonButton["type"],
          isCompleted: lessonButton["unitID"] <= progress,
          updateParent: updateParent,
          image: Image.network(
              "$baseUrlStaticData$langName/units/${lessonButton["unitIcon"]}"),
          unitName: lessonButton['title'],
          unitPath: "$langName/Units/$unitId.json",
        ));
      }
      return unitButtons;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> getUnit(String unitPath) async {
    try {
      debugPrint(_dioStaticData.get(unitPath).toString());
      return await _dioStaticData.get(unitPath);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<Response> updateUnitProgress(unitID) async {
    try {
      debugPrint(await getSavedLanguage());
      return await _dio.post('/adduserprogress', data: {
        'token': await getLocalToken(),
        'language_code': availableLanguagesAbbr[
            availableLanguages.indexOf(await getSavedLanguage())],
        'progress': unitID
      });
    } on DioError catch (e) {
      debugPrint(e.response!.data.toString());
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<int> getUnitProgress(String langCode) async {
    try {
      Response res = await _dio.get('get_user_progress', queryParameters: {
        "token": await getLocalToken(),
        "language_code": langCode
      });
      return res.data['progress'];
    } on DioError catch (e) {
      debugPrint(e.toString());
      return Future.error(e);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<int> getStreakCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt("streakCount") ?? 0;
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future setStreakCount(int streakCount) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt("streakCount", streakCount);
      return;
    } catch (e) {
      return Future.error(e);
    }
  }

  // a function to update the streak count by checking today's date
  static Future updateStreakCount() async {
    // get the today's day
    final today = DateTime.now();

    try {
      final prefs = await SharedPreferences.getInstance();
      final lastUpdated = prefs.getString("lastUpdated");
      if (lastUpdated == null) {
        await prefs.setInt("streakCount", 0);
        return;
      }
      await prefs.setString("lastUpdated", today.toString());
      final lastUpdatedDate = DateTime.parse(lastUpdated);
      final difference = today.difference(lastUpdatedDate).inDays;
      debugPrint("Last updated: $lastUpdatedDate");
      debugPrint("Difference: $difference");
      if (difference == 1) {
        final streakCount = prefs.getInt("streakCount") ?? 0;
        await prefs.setInt("streakCount", streakCount + 1);
        return;
      }
      await prefs.setInt("streakCount", 0);

      return;
    } catch (e) {
      return Future.error(e);
    }
  }
}
