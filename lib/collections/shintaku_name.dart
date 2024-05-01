import 'package:isar/isar.dart';

part 'shintaku_name.g.dart';

@collection
class ShintakuName {
  Id id = Isar.autoIncrement;

  late String frame;

  late String name;
}
