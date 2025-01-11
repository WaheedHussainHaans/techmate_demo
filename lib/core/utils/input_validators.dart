import '../errors/failures.dart';

class InputValidators {
  static ValidationFailure? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return const ValidationFailure(message: 'Name cannot be empty');
    }
    return null;
  }

  static ValidationFailure? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return const ValidationFailure(message: 'Email cannot be empty');
    }
    if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email)) {
      return const ValidationFailure(message: 'Invalid email format');
    }
    return null;
  }

  static ValidationFailure? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return const ValidationFailure(message: 'Password cannot be empty');
    }
    if (password.length < 6) {
      return const ValidationFailure(
          message: 'Password must be at least 6 characters');
    }
    return null;
  }

  static ValidationFailure? validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return const ValidationFailure(message: 'Description cannot be empty');
    }
    return null;
  }
}
