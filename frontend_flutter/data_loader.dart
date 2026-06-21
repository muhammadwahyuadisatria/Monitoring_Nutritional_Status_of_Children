import 'dart:convert';
import 'package:flutter/services.dart';

class DataLoader {
  static Future<List<dynamic>> loadTbuL() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/tbu_l.json',
    );
    return json.decode(jsonString);
  }

  static Future<List<dynamic>> loadTbuP() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/tbu_p.json',
    );
    return json.decode(jsonString);
  }

  static Future<List<dynamic>> loadBbtbL() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/bbtb_l.json',
    );
    return json.decode(jsonString);
  }

  static Future<List<dynamic>> loadBbtbP() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/bbtb_p.json',
    );
    return json.decode(jsonString);
  }

  static Future<List<dynamic>> loadBbpbL() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/bbpb_l.json',
    );
    return json.decode(jsonString);
  }

  static Future<List<dynamic>> loadBbpbP() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/bbpb_p.json',
    );
    return json.decode(jsonString);
  }
}
