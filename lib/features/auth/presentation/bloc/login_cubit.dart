import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/auth_local_data_source.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());
  void onEmailChanged(String value) {
    String? error;
    if (value.isEmpty) {
      error = 'البريد الإلكتروني لا يمكن أن يكون فارغاً';
    } else if (!value.contains('@') || !value.contains('.')) {
      error = 'صيغة البريد الإلكتروني غير صحيحة';
    }
    emit(state.copyWith(email: value, emailError: error));
  }

  void onPasswordChanged(String value) {
    String? error;
    if (value.isEmpty) {
      error = 'كلمة المرور لا يمكن أن تكون فارغة';
    } else if (value.length < 6) {
      error = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    }
    emit(state.copyWith(password: value, passwordError: error));
  }

  final AuthLocalDataSource _localDataSource = AuthLocalDataSource();

  Future<void> login() async {
    if (state.email.isEmpty ||
        state.password.isEmpty ||
        state.emailError != null ||
        state.passwordError != null) {
      emit(state.copyWith(errorMessage: 'يرجى التأكد من صحة البيانات المدخلة'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading));

    try {
      await Future.delayed(const Duration(seconds: 2));

      await _localDataSource.saveToken("mocked_jwt_token_from_server");

      emit(state.copyWith(status: AuthStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.error, errorMessage: 'حدث خطأ غير متوقع'));
    }
  }
}
