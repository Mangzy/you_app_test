import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_app_test/core/gradients/gradient_colors.dart';
import 'package:you_app_test/presentation/bloc/register/register_bloc.dart';
import 'package:you_app_test/presentation/bloc/login/login_bloc.dart';
import 'package:you_app_test/routes/routes_names.dart';
import 'package:you_app_test/widgets/rounded_button.dart';
import 'package:you_app_test/widgets/text_gradient.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;
  bool _emailFocus = false;
  bool _usernameFocus = false;
  bool _passwordFocus = false;
  bool _confirmPasswordFocus = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration successful')),
            );
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesNames.login, (route) => false);
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Container(
                height: 1000,
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    radius: 2.5,
                    center: Alignment(1, -1),
                    colors: GradientColors.blackGradient,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 150),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildFocusTextField(
                          controller: _emailController,
                          hintText: 'Enter Email',
                          isObscure: false,
                          isFocused: _emailFocus,
                          onFocusChange: (focus) {
                            setState(() {
                              _emailFocus = focus;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildFocusTextField(
                          controller: _usernameController,
                          hintText: 'Create Username',
                          isObscure: false,
                          isFocused: _usernameFocus,
                          onFocusChange: (focus) {
                            setState(() {
                              _usernameFocus = focus;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildFocusTextField(
                          controller: _passwordController,
                          hintText: 'Create Password',
                          isObscure: _isPasswordVisible,
                          isFocused: _passwordFocus,
                          onFocusChange: (focus) {
                            setState(() {
                              _passwordFocus = focus;
                            });
                          },
                          toggleVisibility: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildFocusTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          isObscure: _isConfirmPasswordVisible,
                          isFocused: _confirmPasswordFocus,
                          onFocusChange: (focus) {
                            setState(() {
                              _confirmPasswordFocus = focus;
                            });
                          },
                          toggleVisibility: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(height: 50),
                        RoundedButtonWidget(
                          buttonText: state is LoginLoading ? null : 'Register',
                          width: MediaQuery.of(context).size.width,
                          isClicked: _emailFocus ||
                              _usernameFocus ||
                              _passwordFocus ||
                              _confirmPasswordFocus,
                          onpressed: () {
                            final email = _emailController.text.trim();
                            final username = _usernameController.text.trim();
                            final password = _passwordController.text.trim();
                            final confirmPassword =
                                _confirmPasswordController.text.trim();

                            if (email.isEmpty ||
                                username.isEmpty ||
                                password.isEmpty ||
                                confirmPassword.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please fill all fields')),
                              );
                              return;
                            }

                            if (password != confirmPassword) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Password and Confirm Password must match')),
                              );
                              return;
                            }

                            context.read<RegisterBloc>().add(RegisterUser(
                                  email: email,
                                  username: username,
                                  password: password,
                                ));
                          },
                          child: state is LoginLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                  strokeWidth: 2,
                                )
                              : null,
                        ),
                        const SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextGradient(
                              text: 'Login Here',
                              onPressed: () {
                                Navigator.pushNamed(context, RoutesNames.login);
                              },
                              size: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildAppBar(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFocusTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isObscure,
    required bool isFocused,
    required ValueChanged<bool> onFocusChange,
    VoidCallback? toggleVisibility,
  }) {
    return Focus(
      onFocusChange: onFocusChange,
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: isFocused ? Colors.white24 : Colors.white12,
          hintText: hintText,
          suffixIcon: toggleVisibility != null
              ? ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: GradientColors.goldGradient,
                    ).createShader(bounds);
                  },
                  child: IconButton(
                    icon: isObscure
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility_outlined),
                    color: Colors.white,
                    iconSize: 20,
                    onPressed: toggleVisibility,
                  ),
                )
              : null,
          hintStyle: const TextStyle(color: Colors.white38),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.only(top: 50),
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  Text(
                    'Back',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
