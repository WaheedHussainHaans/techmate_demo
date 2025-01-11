part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FormCreateRequested extends FormEvent {
  final FormData formData;

  FormCreateRequested({required this.formData});

  @override
  List<Object?> get props => [formData];
}

class FormGetRequested extends FormEvent {}

class FormSyncRequested extends FormEvent {}
