import 'package:isar/isar.dart';

part 'invest.g.dart';

@collection
class Invest {
  Id id = Isar.autoIncrement;

  @Index()
  late String date;
  late String time;

  late String? frame;
  late String name;
  late String kind;
  late int? kindId;

  late String unit;
  late int cost;
  late int price;
}
