import 'package:isar/isar.dart';

part 'invest_name.g.dart';

@collection
class InvestName {
  Id id = Isar.autoIncrement;

  late String kind;

  late String frame;

  late String name;

  late int dealNumber;

  late int relationalId;
}
