import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/form_data.dart';
import '../repositories/form_repository.dart';

class CreateFormData {
  final FormRepository repository;

  CreateFormData(this.repository);

  Future<Either<Failure, void>> call(FormData formData) async {
    return await repository.createFormData(formData);
  }
}
