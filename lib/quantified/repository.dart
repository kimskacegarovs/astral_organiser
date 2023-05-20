import 'package:astral_organiser/utils.dart';
import 'package:astral_organiser/quantified/main_class.dart';
import 'dart:io';

class QuantifiedRepository {
  final String fileName = "quantified.json";
  late final Repository<Quantified> repository;

  QuantifiedRepository() {
    repository = Repository<Quantified>(fileName);
  }

  Future<List<Quantified>> readQuantified() => repository.readData(Quantified.fromMap);

  Future<File> writeQuantified(List<Quantified> quantified) => repository.writeData(quantified);

  Future<File> deleteQuantified(List<Quantified> quantified) => repository.deleteData(quantified);
}

class QuantifiedCategoryRepository {
  final String fileName = "quantified_categories.json";
  late final Repository<QuantifiedCategory> repository;

  QuantifiedCategoryRepository() {
    repository = Repository<QuantifiedCategory>(fileName);
  }

  Future<List<QuantifiedCategory>> read() => repository.readData(QuantifiedCategory.fromMap);

  Future<File> write(List<QuantifiedCategory> quantifiedCategories) => repository.writeData(quantifiedCategories);

  Future<File> delete(List<QuantifiedCategory> quantifiedCategories) => repository.deleteData(quantifiedCategories);
}
