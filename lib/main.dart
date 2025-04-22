// lib/main.dart

import 'package:flutter/material.dart';
import 'injection_container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:expensego/features/auth/presentation/pages/register_page.dart';
import 'package:expensego/features/auth/presentation/pages/login_page.dart';
import 'package:expensego/features/auth/presentation/blocs/auth_bloc.dart';
import 'package:expensego/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:expensego/features/profile/presentation/blocs/profile_bloc.dart';
import 'package:expensego/features/expense/data/models/expense_model.dart';
import 'package:expensego/features/expense/presentation/blocs/expense_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseModelAdapter());

  await init(); // Initialize dependency injection
  await sl.allReady(); // Wait for all async dependencies

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(AuthCheckRequested()),
        ),
        BlocProvider<ExpenseBloc>(create: (_) => sl<ExpenseBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
      ],
      child: MaterialApp(
        title: 'Expense GO',
        theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
        initialRoute: '/login',
        routes: {
          '/register': (_) => const RegisterPage(),
          '/login': (_) => const LoginPage(),
          '/dashboard': (_) => const DashboardPage(),
        },
      ),
    );
  }
}
