import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_app_test/presentation/bloc/login/login_bloc.dart';
import 'package:you_app_test/routes/routes_names.dart';
import 'package:you_app_test/widgets/rounded_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isClicked = true;
  bool _usernameFocus = false;
  bool _passwordFocus = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginBloc(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, RoutesNames.home);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      radius: 2.5,
                      center: Alignment(1, -1),
                      colors: [
                        Color(0xFF1F4247),
                        Color(0xFF0D1D23),
                        Color(0xFF09141A),
                      ],
                    ),
                  ),
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
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              _usernameFocus = hasFocus;
                            });
                          },
                          child: TextField(
                            controller: _usernameController,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white12,
                              hintText: 'Enter Username/Email',
                              hintStyle: const TextStyle(color: Colors.white38),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              _passwordFocus = hasFocus;
                            });
                          },
                          child: TextField(
                            controller: _passwordController,
                            obscureText: _isClicked,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              // add background color
                              filled: true,
                              fillColor: Colors.white12,
                              hintText: 'Enter Password',
                              suffixIcon: ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    colors: <Color>[
                                      Color(0xFF94783E),
                                      Color(0xFFF3EDA6),
                                      Color(0xFFF8FAE5),
                                      Color(0xFFFFE2BE),
                                      Color(0xFFD5BE88),
                                      Color(0xFFF8FAE5),
                                      Color(0xFFD5BE88),
                                    ],
                                  ).createShader(bounds);
                                },
                                child: IconButton(
                                  icon: _isClicked
                                      ? const Icon(
                                          Icons.visibility_off_outlined)
                                      : const Icon(Icons.visibility_outlined),
                                  color: Colors.white,
                                  iconSize: 30,
                                  onPressed: () {
                                    setState(() {
                                      _isClicked = !_isClicked;
                                    });
                                  },
                                ),
                              ),
                              hintStyle: const TextStyle(color: Colors.white38),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.transparent,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        RoundedButtonWidget(
                          buttonText: state is LoginLoading ? null : 'Login',
                          width: MediaQuery.of(context).size.width,
                          isClicked: _usernameFocus || _passwordFocus,
                          onpressed: state is LoginLoading
                              ? null
                              : () {
                                  final username =
                                      _usernameController.text.trim();
                                  final password =
                                      _passwordController.text.trim();

                                  if (username.isEmpty || password.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Please fill all fields')),
                                    );
                                    return;
                                  }

                                  final isEmailInput = RegExp(
                                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                      .hasMatch(username);

                                  context.read<LoginBloc>().add(
                                        LoginRequested(
                                          email: isEmailInput ? username : '',
                                          username:
                                              isEmailInput ? '' : username,
                                          password: password,
                                        ),
                                      );
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
                              'No account?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: <Color>[
                                    Color(0xFF94783E),
                                    Color(0xFFF3EDA6),
                                    Color(0xFFF8FAE5),
                                    Color(0xFFFFE2BE),
                                    Color(0xFFD5BE88),
                                    Color(0xFFF8FAE5),
                                    Color(0xFFD5BE88),
                                  ],
                                ).createShader(bounds);
                              },
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Register here',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    // add underline
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
