import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/form/form_bloc.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/main_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthBloc>()..add(AuthCheckStatus()),
        ),
        BlocProvider(
          create: (context) => getIt<FormBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthSuccess) {
              return const MainPage();
            } else {
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}
