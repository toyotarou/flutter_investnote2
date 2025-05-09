import '../extensions/extensions.dart';

class ToushiShintakuModel {
  ToushiShintakuModel({
    required this.name,
    required this.date,
    required this.num,
    required this.shutoku,
    required this.cost,
    required this.price,
    required this.diff,
    required this.data,
  });

  factory ToushiShintakuModel.fromJson(Map<String, dynamic> json) => ToushiShintakuModel(
        name: json['name'].toString(),
        date: json['date'].toString(),
        num: json['num'].toString(),
        shutoku: json['shutoku'].toString(),
        cost: json['cost'].toString(),
        price: json['price'].toString(),
        diff: json['diff'].toString().toInt(),
        data: json['data'].toString(),
      );
  String name;
  String date;
  String num;
  String shutoku;
  String cost;
  String price;
  int diff;
  String data;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'date': date,
        'num': num,
        'shutoku': shutoku,
        'cost': cost,
        'price': price,
        'diff': diff,
        'data': data,
      };
}
