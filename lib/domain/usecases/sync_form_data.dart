import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../repositories/form_repository.dart';

class SyncFormData {
  final FormRepository repository;

  SyncFormData(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.syncFormData();
  }
}
