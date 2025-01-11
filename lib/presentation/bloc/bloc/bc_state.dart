part of 'bc_bloc.dart';

sealed class BcState extends Equatable {
  const BcState();
  
  @override
  List<Object> get props => [];
}

final class BcInitial extends BcState {}
