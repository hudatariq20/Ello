import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voice_input/features/auth/core/utils/validation.dart';
import 'package:voice_input/features/auth/core/utils/validator.dart';
import 'package:voice_input/features/auth/presentation/controllers/auth_controller.dart';
import 'package:voice_input/features/auth/presentation/screens/verify_email_screen.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/gradient_background.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _resetformKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    // Delay initialization of _colorAnimation until theme is available in build
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(personaThemeProvider);

    _colorAnimation = ColorTween(
      begin: Theme.of(context).colorScheme.primary,
      end: Theme.of(context).colorScheme.secondary,
    ).animate(_controller);
    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: _resetformKey,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          //alignment: Alignment.centerLeft,
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.deepPurpleAccent,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Reset Password',
                          style: GoogleFonts.urbanist(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurpleAccent),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Enter your email to reset your password and\n we will send you a link to reset your password',
                      style: GoogleFonts.urbanist(
                          fontSize: 16, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    _EmailInputField(controller: _emailController),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () async {
                        if (_resetformKey.currentState!.validate()) {
                          debugPrint('Email: ${_emailController.text}');
                          await ref
                              .read(authControllerProvider.notifier)
                              .forgotPassword(email: _emailController.text);
                          //clear the email controller...
                          _emailController.clear();
                          //navigate to the verify email screen
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const VerifyEmailScreen()));
                          //ref.read(authControllerProvider.notifier).resetPassword(_emailController.text);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        height: 48,
                        decoration: BoxDecoration(
                          //olor: Theme.of(context).colorScheme.primary,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _colorAnimation.value!,
                              theme.buttonColors[0].withOpacity(0.8),
                              theme.buttonColors[1].withOpacity(0.8),
                              theme.buttonColors[2].withOpacity(0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Send',
                            style: GoogleFonts.urbanist(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailInputField extends StatelessWidget {
  const _EmailInputField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: TextFormField(
        controller: controller,
        validator: Validator.apply(context, [
          RequiredValidation(),
          const EmailValidation(),
        ]),
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.surface, width: 2),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
