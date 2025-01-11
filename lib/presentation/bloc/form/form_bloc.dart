import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/form_data.dart';
import '../../../domain/usecases/create_form_data.dart';
import '../../../domain/usecases/get_form_data.dart';
import '../../../domain/usecases/sync_form_data.dart';
part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final CreateFormData createFormData;
  final GetFormData getFormData;
  final SyncFormData syncFormData;

  FormBloc({
    required this.createFormData,
    required this.getFormData,
    required this.syncFormData,
  }) : super(FormInitial()) {
    on<FormCreateRequested>(_onFormCreateRequested);
    on<FormGetRequested>(_onFormGetRequested);
    on<FormSyncRequested>(_onFormSyncRequested);
  }

  void _onFormCreateRequested(
      FormCreateRequested event, Emitter<FormState> emit) async {
    emit(FormLoading());
    final result = await createFormData(event.formData);
    result.fold(
      (failure) => emit(FormFailure(message: 'Failed to create form data')),
      (_) => emit(FormSuccess()),
    );
  }

  void _onFormGetRequested(
      FormGetRequested event, Emitter<FormState> emit) async {
    emit(FormLoading());
    final result = await getFormData();
    result.fold(
      (failure) => emit(FormFailure(message: 'Failed to get form data')),
      (formDataList) => emit(FormLoaded(formDataList: formDataList)),
    );
  }

  void _onFormSyncRequested(
      FormSyncRequested event, Emitter<FormState> emit) async {
    emit(FormLoading());
    final result = await syncFormData();
    result.fold(
      (failure) => emit(FormFailure(message: 'Failed to sync form data')),
      (_) => emit(FormSynced()),
    );
  }
}
