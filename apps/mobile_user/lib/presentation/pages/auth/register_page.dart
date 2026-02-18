import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anandham_user/app/routes/route_names.dart';
import 'package:anandham_user/core/utils/validators.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_cubit.dart';
import 'package:anandham_user/presentation/blocs/auth/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submitSignUp() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    await context.read<AuthCubit>().signUp(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            RouteNames.home,
            (route) => false,
          );
        }

        if (state.status == AuthStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Create your account',
                    style: GoogleFonts.sourceSerif4(
                      textStyle: Theme.of(context).textTheme.headlineLarge,
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Join and start reading with a calm, focused experience.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Personal Details',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _fullNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: Validators.fullName,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('register_email'),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                    ),
                    validator: Validators.email,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Security',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    key: const Key('register_password'),
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText: 'Minimum 6 characters',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 14),
                  TextFormField(
                    key: const Key('register_confirm_password'),
                    controller: _confirmController,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submitSignUp(),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) => Validators.confirmPassword(
                      value,
                      _passwordController.text,
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      final isLoading = state.status == AuthStatus.loading;
                      return ElevatedButton(
                        onPressed: isLoading ? null : _submitSignUp,
                        child: isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Get started'),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, RouteNames.login);
                    },
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
