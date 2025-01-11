import 'package:hive/hive.dart';
import '../../domain/entities/form_data.dart';

part 'form_data_model.g.dart';

@HiveType(typeId: 0)
class FormDataModel extends FormData {
  @override
  @HiveField(0)
  final String name;
  @override
  @HiveField(1)
  final String email;
  @override
  @HiveField(2)
  final String picture;
  @override
  @HiveField(3)
  final String description;

  const FormDataModel({
    required this.name,
    required this.email,
    required this.picture,
    required this.description,
  }) : super(
            name: name,
            email: email,
            picture: picture,
            description: description);

  factory FormDataModel.fromJson(Map<String, dynamic> json) {
    return FormDataModel(
      name: json['name'],
      email: json['email'],
      picture: json['picture'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'picture': picture,
      'description': description,
    };
  }
}
