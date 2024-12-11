import '../extensions/extensions.dart';

class FundModel {
  FundModel({
    required this.id,
    required this.year,
    required this.month,
    required this.day,
    required this.fundname,
    required this.basePrice,
    required this.compareFront,
    required this.yearlyReturn,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) => FundModel(
        id: json['id'].toString().toInt(),
        year: json['year'].toString(),
        month: json['month'].toString(),
        day: json['day'].toString(),
        fundname: fundnameValues.map[json['fundname']]!,
        basePrice: json['base_price'].toString().toInt(),
        compareFront: json['compare_front'].toString(),
        yearlyReturn: json['yearly_return'].toString(),
      );
  int id;
  String year;
  String month;
  String day;
  Fundname fundname;
  int basePrice;
  String compareFront;
  String yearlyReturn;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'year': year,
        'month': month,
        'day': day,
        'fundname': fundnameValues.reverse[fundname],
        'base_price': basePrice,
        'compare_front': compareFront,
        'yearly_return': yearlyReturn,
      };
}

enum Fundname {
  EMERGING,
  E_MAXIS_SLIM_ALL_COUNTRY,
  E_MAXIS_SLIM_SP500,
  RAKUTEN_ALL_AMERICA_INDEX_FUND,
  E_MAXIS_SLIM_ALL_AMERICA_SP500,
  I_FREE_NEXT_INDIA,
  IFREE_SP500,
  ITRUST_INDIA,
  NZAM_SP500,
  TAWARA_SP500
}

// ignore: always_specify_types
final EnumValues<Fundname> fundnameValues = EnumValues(<String, Fundname>{
  'エマージング・ボンド・ファンド・南アフリカランドコース（毎月分配型）(三井住友ＤＳアセットマネジメント)': Fundname.EMERGING,
  'eMAXIS　Slim　全世界株式（オール・カントリー）(三菱ＵＦＪアセットマネジメント)': Fundname.E_MAXIS_SLIM_ALL_COUNTRY,
  'eMAXIS　Slim　米国株式（S&P500）(三菱ＵＦＪアセットマネジメント)': Fundname.E_MAXIS_SLIM_SP500,
  '楽天・全米株式インデックス・ファンド(楽天投信投資顧問)': Fundname.RAKUTEN_ALL_AMERICA_INDEX_FUND,
  'eMAXIS　Slim　米国株式（S&P500）(三菱ＵＦＪ国際投信)': Fundname.E_MAXIS_SLIM_ALL_AMERICA_SP500,
  'iFreeNEXT　インド株インデックス(大和アセットマネジメント)': Fundname.I_FREE_NEXT_INDIA,
  'iFree　S&P500インデックス(大和アセットマネジメント)': Fundname.IFREE_SP500,
  'iTrustインド株式(ピクテ・ジャパン)': Fundname.ITRUST_INDIA,
  'NZAM・ベータ　S&P500(農林中金全共連アセットマネジメント)': Fundname.NZAM_SP500,
  'たわらノーロード　S&P500(アセットマネジメントOne)': Fundname.TAWARA_SP500
});

class EnumValues<T> {
  EnumValues(this.map);

  Map<String, T> map;
  late Map<T, String> reverseMap;

  Map<T, String> get reverse {
    // ignore: always_specify_types
    reverseMap = map.map((String k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
