import 'package:isar/isar.dart';

import '../collections/invest_name.dart';

class InvestNamesRepository {
  ///
  IsarCollection<InvestName> getCollection({required Isar isar}) => isar.investNames;

  ///
  Future<InvestName?> getInvestName({required Isar isar, required int id}) async {
    final investNamesCollection = getCollection(isar: isar);
    return investNamesCollection.get(id);
  }

  ///
  Future<List<InvestName>?> getInvestNameList({required Isar isar}) async {
    final investNamesCollection = getCollection(isar: isar);
    return investNamesCollection.where().findAll();
  }

  ///
  Future<List<InvestName>?> getInvestNameListByInvestKind({required Isar isar, required String investKind}) async {
    final investNamesCollection = getCollection(isar: isar);
    return investNamesCollection.filter().kindEqualTo(investKind).findAll();
  }

  ///
  Future<void> inputInvestName({required Isar isar, required InvestName investName}) async {
    final investNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => investNamesCollection.put(investName));
  }

  ///
  Future<void> updateInvestName({required Isar isar, required InvestName investName}) async {
    final investNamesCollection = getCollection(isar: isar);
    await investNamesCollection.put(investName);
  }

  ///
  Future<void> deleteInvestName({required Isar isar, required int id}) async {
    final investNamesCollection = getCollection(isar: isar);
    await isar.writeTxn(() async => investNamesCollection.delete(id));
  }
}
