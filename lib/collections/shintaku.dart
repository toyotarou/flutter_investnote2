import 'package:isar/isar.dart';

part 'shintaku.g.dart';

@collection
class Shintaku {
  Id id = Isar.autoIncrement;

  late String frame;

  late String name;
}
