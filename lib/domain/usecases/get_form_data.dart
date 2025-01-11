import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/form_data.dart';
import '../repositories/form_repository.dart';

class GetFormData {
  final FormRepository repository;

  GetFormData(this.repository);

  Future<Either<Failure, List<FormData>>> call() async {
    return await repository.getFormData();
  }
}
