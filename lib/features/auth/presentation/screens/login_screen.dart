import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/features/auth/presentation/screens/sign_up_screen.dart';
import '../../../projects/presentation/screens/projects_screen.dart';
import '../bloc/login_cubit.dart';
import '../bloc/login_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == AuthStatus.success) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProjectsScreen()),
              );
            } else if (state.status == AuthStatus.error ||
                state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.errorMessage ?? 'خطأ في البيانات')),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.emailError != current.emailError,
                  builder: (context, state) {
                    return TextField(
                      onChanged: (value) =>
                          context.read<LoginCubit>().onEmailChanged(value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        errorText: state
                            .emailError, 
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.passwordError != current.passwordError,
                  builder: (context, state) {
                    return TextField(
                      onChanged: (value) =>
                          context.read<LoginCubit>().onPasswordChanged(value),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'كلمة المرور',
                        errorText: state.passwordError,
                        border: const OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                BlocBuilder<LoginCubit, LoginState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status,
                  builder: (context, state) {
                    return state.status == AuthStatus.loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () => context.read<LoginCubit>().login(),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('دخول'),
                          );
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text('ليس لديك حساب؟ سجل الآن'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
