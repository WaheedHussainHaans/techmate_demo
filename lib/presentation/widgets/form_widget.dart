import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/utils/input_validators.dart';
import '../../data/datasources/firebase_data_source.dart';
import '../../domain/entities/form_data.dart';
import '../../injection.dart';

class FormWidget extends StatefulWidget {
  final Function(FormData) onFormSubmit;

  const FormWidget({super.key, required this.onFormSubmit});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _imagePath = '';
  String _imageUrl = '';
  bool _isUploading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_imagePath.isEmpty) {
      return;
    }
    setState(() {
      _isUploading = true;
    });
    try {
      final firebaseDataSource = getIt<FirebaseDataSource>();
      final imageFile = File(_imagePath);
      _imageUrl = await firebaseDataSource.uploadImage(imageFile);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload image')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await _uploadImage(context);
      final formData = FormData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        picture: _imageUrl,
        description: _descriptionController.text.trim(),
      );
      widget.onFormSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              return InputValidators.validateName(value)?.message;
            },
          ),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              return InputValidators.validateEmail(value)?.message;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description'),
            validator: (value) {
              return InputValidators.validateDescription(value)?.message;
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
              const SizedBox(width: 10),
              if (_imagePath.isNotEmpty)
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.file(File(_imagePath)),
                ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isUploading ? null : () => _submitForm(context),
            child: _isUploading
                ? const CircularProgressIndicator()
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
