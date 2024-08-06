import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:urmytalk/models/models.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

class UrMyTalkServiceRepository {
  late final Ref ref;
  var urmytokenstorage = Hive.box<UrMyToken>('accesstoken');

  UrMyTalkServiceRepository({required this.ref});
}
