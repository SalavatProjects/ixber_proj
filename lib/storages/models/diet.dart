import 'package:isar/isar.dart';

part 'diet.g.dart';

@collection
class Diet {
  Id id = Isar.autoIncrement;

  List<String>? foodList;
  String? type;
  DateTime? date;
}