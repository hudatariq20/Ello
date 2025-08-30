import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_input/features/auth/core/utils/validation.dart';
import 'package:voice_input/features/auth/core/utils/validator.dart';
import 'package:voice_input/features/auth/domain/entities/app_user.dart';
import 'package:voice_input/features/auth/presentation/controllers/auth_controller.dart';
import 'package:voice_input/features/auth/presentation/screens/login_screen.dart';
import 'package:voice_input/features/onboarding/onboarding_flow.dart';
import 'package:voice_input/shared/models/personaTheme_model.dart';
import 'package:voice_input/shared/providers/personaTheme_provider.dart';
import 'package:voice_input/shared/widgets/gradient_background.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  // Text editing controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() async {
    if (!_signupFormKey.currentState!.validate()) {
      return; // If validation fails, exit
    }
    // Read text from controllers
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Basic validation
    // if (name.isEmpty ||
    //     email.isEmpty ||
    //     password.isEmpty ||
    //     confirmPassword.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Please fill in all fields')),
    //   );
    //   return;
    // }

    // if (password != confirmPassword) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Passwords do not match')),
    //   );
    //   return;
    // }

    debugPrint('Name: $name');
    debugPrint('Email: $email');
    debugPrint('Password: $password');

    // TODO: Implement actual signup logic
    final newUser = new AppUser(name: name, email: email, selectedPersona: "");

    await ref
        .read(authControllerProvider.notifier)
        .signUp(user: newUser, password: password);
    //MOVE THE SIGN UP SCREEN LOGIC TO THE BUILD MEHTOD SINCE IT IS NOT WORKING
    // Move navigation + SnackBar into ref.listen() inside build()
    //ref.listen is only triggered when the state changes and the widget doeesn't rebuild.
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(personaThemeProvider);
    final authState = ref.watch(authControllerProvider);

    // Listen to auth state changes for navigation
    ref.listen<AsyncValue<void>>(authControllerProvider,
        (previous, next) async {
      if (next is AsyncData) {
        final currentUser = FirebaseAuth.instance.currentUser;
        debugPrint("currentUser: $currentUser");
        //if the user is not mounted or the modal route is not current, return
        if (!mounted || ModalRoute.of(context)?.isCurrent != true) return;
        if (currentUser != null) {
          // Show success message first
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(milliseconds: 1500),
            ),
          );

          // Add a small delay before navigation for better UX
          await Future.delayed(const Duration(milliseconds: 800));

          if (mounted) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const OnboardingFlow(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.1),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    ),
                  );
                },
                transitionDuration: const Duration(milliseconds: 600),
              ),
            );
          }
        }
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    _colorAnimation = ColorTween(
      begin: theme.buttonColors.first,
      end: theme.buttonColors.last,
    ).animate(_controller);

    return GradientBackground(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ZoomIn(
              duration:
                  const Duration(seconds: 2), // Adjust duration to slow down
              child: authState.when(
                data: (_) => _buildUIForm(context, theme),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Signup failed: $error"),
                    const SizedBox(height: 16),
                    // _buildFormUI(theme), // Allow retry
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    /////
  }

  Form _buildUIForm(BuildContext context, PersonaTheme theme) {
    return Form(
      key: _signupFormKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            //the asset bouncing
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -50 * _controller.value),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: child,
                  ),
                );
              },
              child: Lottie.asset(
                'assets/images/AI.json',
                repeat: true,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  debugPrint(
                      "✅ Lottie loaded with duration: ${composition.duration}");
                },
              ),
            ),
            Text(
              'Ello! Let\'s Get\nYou Started',
              textAlign: TextAlign.center,
              style: GoogleFonts.urbanist(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            //const SizedBox(height: 20),
            _NameInputField(controller: _nameController),
            _EmailInputField(controller: _emailController),
            _PasswordInputField(controller: _passwordController),

            _ConfirmPasswordInputField(
              controller: _confirmPasswordController,
              passwordController: _passwordController,
            ),

            //Create Account Button
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: AnimatedBuilder(
                animation: _colorAnimation,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: _handleSignup,
                    child: Container(
                      width: double.infinity,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _colorAnimation.value!,
                            theme.buttonColors[0],
                            theme.buttonColors[1],
                            theme.buttonColors[2],
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'Create Account',
                          style: GoogleFonts.urbanist(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            //Forgot Password Button
            //Dont have an account? Sign up
            const SizedBox(height: 20),
            Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "I am already a member",
                  style: GoogleFonts.urbanist(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: Text(
                      "login",
                      style: GoogleFonts.urbanist(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepPurple,
                      ),
                    )),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class _NameInputField extends StatelessWidget {
  final TextEditingController controller;
  const _NameInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
      child: TextFormField(
        validator: Validator.apply(context, [
          RequiredValidation(),
        ]),
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Name',
          hintStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
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

class _EmailInputField extends StatelessWidget {
  final TextEditingController controller;
  const _EmailInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0),
      child: TextFormField(
        validator: Validator.apply(context, [
          RequiredValidation(),
          const EmailValidation(),
        ]),
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
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

class _PasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  const _PasswordInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        top: 16.0,
      ),
      child: TextFormField(
        validator: Validator.apply(context, [
          RequiredValidation(),
          const PasswordValidation(),
        ]),
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
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

class _ConfirmPasswordInputField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  const _ConfirmPasswordInputField({
    super.key,
    required this.controller,
    required this.passwordController,
  });
  @override
  Widget build(BuildContext context) {
    debugPrint(
        'passwordController: in the confirm password field ${passwordController.text}');
    return Padding(
      padding: const EdgeInsets.only(
          left: 24.0, right: 24.0, top: 16.0, bottom: 24.0),
      child: TextFormField(
        validator: (value) {
          debugPrint('🔍 CUSTOM VALIDATOR: Current confirm password: "$value"');
          debugPrint(
              '🔍 CUSTOM VALIDATOR: Reading password at validation time: "${passwordController.text}"');

          // Apply basic validations first
          final basicValidations =
              Validator.apply(context, <Validation<String>>[
            RequiredValidation<String>(),
            const PasswordValidation(),
          ])(value);

          if (basicValidations != null) return basicValidations;

          // Check password match using CURRENT password value
          if (value != passwordController.text) {
            //debugPrint('❌ CUSTOM VALIDATOR: Passwords do not match!');
            return 'Passwords do not match';
          }

          debugPrint('✅ CUSTOM VALIDATOR: Passwords match!');
          return null;
        },
        controller: controller,
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          hintStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
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
