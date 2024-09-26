import 'dart:io';

import 'package:jymu/Models/UserModel.dart';

import 'TrainingModel.dart';

class CachedData {
  static final CachedData _instance = CachedData._internal();

  Map<String, TrainingModel> trainings = {};
  Map<String, UserModel> users = {};
  Map<String, File> images = {};
  Map<String, String> links = {};

  CachedData._internal();

  factory CachedData() {
    return _instance;
  }
}