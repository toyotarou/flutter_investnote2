import 'package:isar/isar.dart';

part 'stock.g.dart';

@collection
class Stock {
  Id id = Isar.autoIncrement;

  late String frame;

  late String name;
}
