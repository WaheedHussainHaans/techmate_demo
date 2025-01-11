import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bc_event.dart';
part 'bc_state.dart';

class BcBloc extends Bloc<BcEvent, BcState> {
  BcBloc() : super(BcInitial()) {
    on<BcEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
