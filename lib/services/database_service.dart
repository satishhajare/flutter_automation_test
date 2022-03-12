import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import '../model/technology_model.dart';
import 'authentication_service.dart';

class DatabaseService {
  final AuthenticationService _authenticationService = AuthenticationService();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference ideas =
      FirebaseFirestore.instance.collection('add-technology');

  Future<String> getDocID(String userID) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('add-technology')
        .where('userID', isEqualTo: userID)
        .get();
    log(result.docs.length.toString());
    return result.docs[0].reference.id.toString();
  }

  Future<Map<String, dynamic>> readData(String userID) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('add-technology')
        .where('userID', isEqualTo: userID)
        .get();
    return result.docs.isNotEmpty
        ? result.docs[0].data() as Map<String, dynamic>
        : <String, dynamic>{};
  }

  Future<void> addNewUserData() async {
    return ideas.add({
      'userID': _authenticationService.getUserID,
      'technologyList': <Map<String, dynamic>>[]
    }).then((value) {
      debugPrint('UserData Added');
      getDocID(_authenticationService.getUserID);
    });
  }

  Future updateData(List<Technology> ideasList) async {
    final list = <Map<String, dynamic>>[];
    for (var element in ideasList) {
      list.add(element.toJson());
    }
    final docID = await getDocID(_authenticationService.getUserID);
    return ideas.doc(docID).update({'technologyList': list}).then<void>(
        (value) => debugPrint('technology Updated'));
  }
}
