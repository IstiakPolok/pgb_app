import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pgb_app/core/theme/app_spacer.dart';
import 'package:pgb_app/core/theme/app_assets.dart';
import 'package:pgb_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pgb_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:pgb_app/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Login successful!')));
            context.go('/nav');
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    v40pad,
                    Center(
                      child: SvgPicture.asset(
                        isDark
                            ? AppAssets.darkLogoWithName
                            : AppAssets.logoWithName,
                        height: 100.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    v16pad,
                    Text(
                      'Welcome back',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    v8pad,
                    Text(
                      'Sign in to start your shift',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    v40pad,
                    Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    v8pad,
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 15.sp,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter Your Email',
                        prefixIcon: Icon(
                          Icons.mail_outline_rounded,
                          size: 22.r,
                        ),
                      ),
                    ),
                    v16pad,
                    Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    v8pad,
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, isObscured, child) {
                        return TextFormField(
                          controller: _passwordController,
                          obscureText: isObscured,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 15.sp,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter Your Password',
                            prefixIcon: Icon(
                              Icons.lock_outline_rounded,
                              size: 22.r,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isObscured
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 22.r,
                              ),
                              onPressed: () {
                                _obscurePassword.value = !isObscured;
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    v16pad,
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    v32pad,
                    // Sign In Button
                    ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              if (email.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your email'),
                                  ),
                                );
                                return;
                              }
                              if (password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your password'),
                                  ),
                                );
                                return;
                              }

                              context.read<AuthBloc>().add(
                                LoginSubmitted(
                                  email: email,
                                  password: password,
                                ),
                              );
                            },
                      child: state is AuthLoading
                          ? SizedBox(
                              height: 20.r,
                              width: 20.r,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Sign In'),
                    ),
                    v24pad,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.go('/register');
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
