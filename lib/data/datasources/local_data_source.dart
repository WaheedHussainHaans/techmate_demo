import 'package:hive/hive.dart';
import '../../core/constants/constants.dart';
import '../../core/errors/exceptions.dart';
import '../models/form_data_model.dart';

abstract class LocalDataSource {
  Future<void> cacheFormData(FormDataModel formData);
  Future<List<FormDataModel>> getCachedFormData();
  Future<void> clearCachedFormData();
}

class LocalDataSourceImpl implements LocalDataSource {
  final HiveInterface hive;

  LocalDataSourceImpl({required this.hive});

  @override
  Future<void> cacheFormData(FormDataModel formData) async {
    try {
      final box = await hive.openBox<FormDataModel>(Constants.formBox);
      await box.add(formData);
      await box.close();
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<List<FormDataModel>> getCachedFormData() async {
    try {
      final box = await hive.openBox<FormDataModel>(Constants.formBox);
      final formDataList = box.values.toList();
      await box.close();
      return formDataList;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearCachedFormData() async {
    try {
      final box = await hive.openBox<FormDataModel>(Constants.formBox);
      await box.clear();
      await box.close();
    } catch (e) {
      throw CacheException();
    }
  }
}
