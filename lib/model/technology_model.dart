import 'package:flutter/foundation.dart';

import '../services/database_service.dart';

class Technology {
  String? title;
  String? description;
  String? date;
  Technology({this.title, this.description, this.date});
  Technology.fromJson(Map<String, dynamic> json)
      : this(
          title: json['title']! as String,
          description: json['description']! as String,
          date: json['date']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}

class TechnologyModel extends ChangeNotifier {
  List<Technology> _technologyList = [];

  List<Technology> get getAllIdeas => _technologyList;

  void initialize(List<Technology> technologyList) {
    _technologyList = technologyList;
  }

  void addTechnology(Technology ideaItem) {
    _technologyList.add(ideaItem);
    DatabaseService().updateData(getAllIdeas);
    notifyListeners();
  }

  void deleteTechnology(Technology ideaItem) {
    _technologyList.remove(ideaItem);
    DatabaseService().updateData(getAllIdeas);
    notifyListeners();
  }
}
