import 'package:equatable/equatable.dart';

class FormData extends Equatable {
  final String name;
  final String email;
  final String picture;
  final String description;

  const FormData({
    required this.name,
    required this.email,
    required this.picture,
    required this.description,
  });

  @override
  List<Object?> get props => [name, email, picture, description];
}
