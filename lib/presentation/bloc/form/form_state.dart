part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormInitial extends FormState {}

class FormLoading extends FormState {}

class FormSuccess extends FormState {}

class FormLoaded extends FormState {
  final List<FormData> formDataList;

  FormLoaded({required this.formDataList});

  @override
  List<Object?> get props => [formDataList];
}

class FormSynced extends FormState {}

class FormFailure extends FormState {
  final String message;

  FormFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
