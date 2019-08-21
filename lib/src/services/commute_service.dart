import 'dart:async';
import 'package:mbta_companion/src/models/commute.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mbta_companion/src/services/config.dart';

class CommuteService {
  static Future<Commute> getCommute() async {
    try {
      String udid = await FlutterUdid.udid;

      final stage = FIREBASE_STAGE;

      var docRef = Firestore.instance
          .collection(stage)
          .document(stage)
          .collection("users")
          .document(udid);

      var doc = await docRef.get();
      if (!doc.exists) {
        return null;
      }
      return Commute.fromJson(Map<String, dynamic>.from(doc.data));
    } catch (e) {
      print('$e');
      throw new Exception("Could not load commute");
    }
  }

  static Future<void> saveCommute(Commute commute) async {
    try {
      String udid = await FlutterUdid.udid;

      final stage = FIREBASE_STAGE;

      var docRef = Firestore.instance
          .collection(stage)
          .document(stage)
          .collection("users")
          .document(udid);
      await docRef.setData(commute.toJson());
    } catch (e) {
      throw new Exception("Could not save commute");
    }
  }

  static Future<void> deleteCommute(Commute commute) async {
    try {
      String udid = await FlutterUdid.udid;

      final stage = FIREBASE_STAGE;

      var docRef = Firestore.instance
          .collection(stage)
          .document(stage)
          .collection("users")
          .document(udid);
      await docRef.delete();
    } catch (e) {
      throw new Exception("Could not delete commute");
    }
  }
}
