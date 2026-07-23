import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:voice_input/features/auth/core/utils/auth_error_mapper.dart';
import 'package:voice_input/features/auth/core/utils/validation.dart';
import 'package:voice_input/features/auth/core/utils/validator.dart';
import 'package:voice_input/features/auth/presentation/controllers/auth_controller.dart';
import 'package:voice_input/features/auth/presentation/screens/auth_screen.dart';
import 'package:voice_input/shared/theme/persona_theme_model.dart';
import 'package:voice_input/shared/widgets/widgets.dart';
import '../../../../shared/providers/persona_theme_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  //late Animation<double> _animation;
  late Animation<Color?> _colorAnimation;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _loginSubmitted = false;
  bool _obscurePassword = true;

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
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    debugPrint('Password field content: "${_passwordController.text}"');

    if (!_loginFormKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      return; // If validation fails, exit
    }
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    debugPrint('Email: $email, Password: $password');

    //Here you can use the text values for signup logic
    debugPrint('Email: $email');
    debugPrint('Password: $password');

    _loginSubmitted = true;

    await ref
        .read(authControllerProvider.notifier)
        .logIn(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(personaThemeProvider);
    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<void>>(
      authControllerProvider,
      (previous, next) {
        if (!_loginSubmitted) return;

        if (next is AsyncData<void>) {
          _loginSubmitted = false;

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );

          // No Navigator call.
          // AppRouter rebuilds automatically from LoginScreen to Home.
        }

        if (next is AsyncError<void>) {
          _loginSubmitted = false;

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getLoginErrorMessage(next.error)),
              backgroundColor: Colors.red,
            ),
          );

          //Deferred to after this frame: requesting focus/selection here
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _passwordFocusNode.requestFocus();
            _passwordController.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _passwordController.text.length,
            );
          });
        }
      },
    );

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
              child: _buildloginFormUI(context, theme,
                  isLoading: authState.isLoading),
            ),
          ),
        ),
      ),
    );
  }

  Form _buildloginFormUI(BuildContext context, PersonaTheme theme,
      {required bool isLoading}) {
    return Form(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            'Welcome back to ELLO',
            style: GoogleFonts.urbanist(
              fontSize: 32,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),
          _EmailInputField(controller: _emailController),
          _PasswordInputField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            obscureText: _obscurePassword,
            onToggleObscureText: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
          //Forgot Password Button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: TextButton(
                onPressed: () {
                  debugPrint('Forgot Password Button Pressed');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()));
                  //ref.read(authControllerProvider.notifier).forgotPassword(email: _emailController.text);
                },
                child: Text(
                  'Forgot Password?',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          //Login Button
          Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return GestureDetector(
                  onTap: isLoading ? null : _handleLogin,
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
                      child: isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                        'Login',
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
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Not a member?",
                style: GoogleFonts.urbanist(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 7),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                  },
                  child: Text(
                    "Register Now",
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
    );
  }
}

class _EmailInputField extends StatelessWidget {
  const _EmailInputField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 24.0),
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
  const _PasswordInputField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.obscureText,
    required this.onToggleObscureText,
  });
  final TextEditingController controller;
  final FocusNode? focusNode;
  final bool obscureText;
  final VoidCallback onToggleObscureText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 16.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        validator: Validator.apply(context, [
          RequiredValidation(),
          const PasswordValidation(),
        ]),
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: 'Password',
          hintStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.primary,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: onToggleObscureText,
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
