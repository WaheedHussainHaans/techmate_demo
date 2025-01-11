import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/form_data.dart';
import '../../injection.dart';
import '../bloc/form/form_bloc.dart';
import '../widgets/form_widget.dart';
import '../widgets/loading_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription<InternetConnectionStatus> _connectionSubscription;
  late NetworkInfo _networkInfo;

  ///
  ///
  ///
  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access BlocProvider here
    _networkInfo = getIt<NetworkInfo>();
    _connectionSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) async {
      if (status == InternetConnectionStatus.connected) {
        if (await _networkInfo.isConnected) {
          BlocProvider.of<FormBloc>(context).add(FormSyncRequested());
        }
      }
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }

  void _loadFormData() {
    BlocProvider.of<FormBloc>(context).add(FormGetRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocConsumer<FormBloc, FormState>(
        listener: (context, state) {
          if (state is FormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form data saved')),
            );
            _loadFormData();
          }
          if (state is FormSynced) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Form data synced')),
            );
            _loadFormData();
          }
          if (state is FormFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is FormLoading) {
            return const LoadingWidget();
          }
          if (state is FormLoaded) {
            return _buildFormList(state.formDataList);
          }
          return _buildFormWidget();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Form Data'),
              content: FormWidget(
                onFormSubmit: (formData) {
                  BlocProvider.of<FormBloc>(context)
                      .add(FormCreateRequested(formData: formData));
                  Navigator.of(context).pop();
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFormList(List<FormData> formDataList) {
    if (formDataList.isEmpty) {
      return const Center(child: Text('No form data available'));
    }
    return ListView.builder(
        itemCount: formDataList.length,
        itemBuilder: (context, index) {
          final formData = formDataList[index];
          log('formData ${formData.toString()}');
          return ListTile(
            title: Text(formData.name),
            subtitle: Text(formData.description),
            leading: formData.picture.isNotEmpty
                ? CircleAvatar(
                    backgroundImage: formData.picture.startsWith('http')
                        ? NetworkImage(formData.picture)
                        : FileImage(File(formData.picture)),
                  )
                : const SizedBox(),
          );
        });
  }

  Widget _buildFormWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
              'No form data available. Please add form data using the button below.'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Add Form Data'),
                  content: FormWidget(
                    onFormSubmit: (formData) {
                      BlocProvider.of<FormBloc>(context)
                          .add(FormCreateRequested(formData: formData));
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              );
            },
            child: const Text('Add Form Data'),
          ),
        ],
      ),
    );
  }
}
