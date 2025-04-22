// lib/injection_container.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensego/core/services/auth_service.dart';
import 'package:expensego/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:expensego/features/profile/domain/usecases/delete_account.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expensego/core/network/network_info.dart';

//Auth feature
import 'package:expensego/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:expensego/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:expensego/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:expensego/features/auth/domain/repositories/auth_repository.dart';
import 'package:expensego/features/auth/domain/usecases/get_current_user.dart';
import 'package:expensego/features/auth/domain/usecases/sign_in.dart';
import 'package:expensego/features/auth/domain/usecases/sign_out.dart';
import 'package:expensego/features/auth/domain/usecases/sign_up.dart';
import 'package:expensego/features/auth/presentation/blocs/auth_bloc.dart';

//Profile feature
import 'package:expensego/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:expensego/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:expensego/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:expensego/features/profile/domain/repositories/profile_repository.dart';
import 'package:expensego/features/profile/domain/usecases/update_profile.dart';
import 'package:expensego/features/profile/domain/usecases/change_password.dart';
import 'package:expensego/features/profile/presentation/blocs/profile_bloc.dart';

//Expense feature
import 'package:expensego/features/expense/data/datasources/expense_local_data_source.dart';
import 'package:expensego/features/expense/data/datasources/expense_local_data_source_impl.dart';
import 'package:expensego/features/expense/data/datasources/expense_remote_data_source.dart';
import 'package:expensego/features/expense/data/datasources/expense_remote_data_source_impl.dart';
import 'package:expensego/features/expense/data/repositories/expense_repository_impl.dart';
import 'package:expensego/features/expense/domain/repositories/expense_repository.dart';
import 'package:expensego/features/expense/domain/usecases/add_expense.dart';
import 'package:expensego/features/expense/domain/usecases/update_expense.dart';
import 'package:expensego/features/expense/domain/usecases/delete_expense.dart';
import 'package:expensego/features/expense/domain/usecases/get_expenses.dart';
import 'package:expensego/features/expense/presentation/blocs/expense_bloc.dart';

// injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => Connectivity());

  //Hive local database
  await Hive.initFlutter();
  sl.registerLazySingleton(() => Hive);

  final box = await Hive.openBox('expenses');
  sl.registerLazySingleton(() => box);

  // Core Services
  sl.registerLazySingleton<AuthService>(
    () => FirebaseAuthService(sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ===================== AUTH FEATURE ========================
  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<AuthService>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SignIn(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignUp(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignOut(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignInWithGoogle(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetCurrentUser(sl<AuthRepository>()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signIn: sl<SignIn>(),
      signUp: sl<SignUp>(),
      signOut: sl<SignOut>(),
      signInWithGoogle: sl<SignInWithGoogle>(),
      getCurrentUser: sl<GetCurrentUser>(),
      authService: sl(),
    ),
  );

  // ======================== EXPENSE FEATURE ========================
  // Data Source
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(firestore: sl(), auth: sl()),
  );

  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Usecase
  sl.registerLazySingleton(() => AddExpense(sl()));
  sl.registerLazySingleton(() => UpdateExpense(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => GetExpenses(sl()));

  // Bloc
  sl.registerFactory(
    () => ExpenseBloc(
      addExpense: sl(),
      updateExpense: sl(),
      deleteExpense: sl(),
      getExpenses: sl(),
    ),
  );

  // ========================  PROFILE PAGE FEATURE ========================
  // Data Source
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDataSource: sl(), networkInfo: sl()),
  );

  // UseCase
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => ChangePassword(sl()));
  sl.registerLazySingleton(() => DeleteAccount(sl()));

  // Bloc
  sl.registerFactory(
    () => ProfileBloc(
      updateProfile: sl(),
      changePassword: sl(),
      deleteAccount: sl(),
    ),
  );
}
