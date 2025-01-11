import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/form_data.dart';

abstract class FormRepository {
  Future<Either<Failure, void>> createFormData(FormData formData);
  Future<Either<Failure, List<FormData>>> getFormData();
  Future<Either<Failure, void>> syncFormData();
}
