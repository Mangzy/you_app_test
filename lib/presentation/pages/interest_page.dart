import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:you_app_test/core/gradients/gradient_colors.dart';
import 'package:you_app_test/presentation/bloc/profile/profile_bloc.dart';
import 'package:you_app_test/routes/routes_names.dart';

class InterestPage extends StatefulWidget {
  final List<String> initialInterests;

  const InterestPage({super.key, required this.initialInterests});

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List<String> interests = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isSaving = false;

  void _addInterest(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        interests.add(value.trim());
      });
      _textController.clear();
    }
    _focusNode.requestFocus();
  }

  void _removeInterest(String interest) {
    setState(() {
      interests.remove(interest);
    });
  }

  @override
  void initState() {
    interests = widget.initialInterests;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess && isSaving) {
            setState(() {
              isSaving = false; // Berhenti loading
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Interests updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is ProfileFailure && isSaving) {
            setState(() {
              isSaving = false; // Berhenti loading
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                radius: 2.5,
                center: Alignment(1, -1),
                colors: GradientColors.blackGradient,
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 100),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return const LinearGradient(
                                  colors: GradientColors.goldGradient,
                                ).createShader(bounds);
                              },
                              child: const Text('Tell everyone about yourself',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'What interests you?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: _buildInterest(),
                      ),
                    ],
                  ),
                ),
                _appBar(context),
                if (isSaving)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _appBar(BuildContext context) {
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
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutesNames.home, (route) => false);
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
          const Spacer(),
          TextButton(
            onPressed: isSaving
                ? null
                : () async {
                    setState(() {
                      isSaving = true; // Mulai loading
                    });
                    context.read<ProfileBloc>().add(UpdateInterests(interests));
                    Future.delayed(const Duration(seconds: 2));

                    Navigator.pushNamedAndRemoveUntil(
                        context, RoutesNames.home, (route) => false);
                  },
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: GradientColors.blueGradient,
                ).createShader(bounds);
              },
              child: const Text(
                'Save',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterest() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        children: [
          ...interests.map((interest) {
            return Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    interest,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () => _removeInterest(interest),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            );
          }),
          IntrinsicWidth(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              constraints: const BoxConstraints(
                minWidth: 300,
                maxWidth: 300,
              ),
              child: TextField(
                controller: _textController,
                focusNode: _focusNode,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                onSubmitted: _addInterest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
