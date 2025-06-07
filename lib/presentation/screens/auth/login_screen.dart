import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourism_app/app/auth/auth_bloc.dart'; // Adjust path
import 'package:tourism_app/presentation/screens/auth/signup_screen.dart'; // Adjust path

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/login';
  static Route route() => MaterialPageRoute(builder: (_) => const LoginScreen(), settings: RouteSettings(name: routeName));

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthEmailPasswordSignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated && state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          } else if (state.status == AuthStatus.error) {
             ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage ?? 'An unknown error occurred')));
          }
          // Navigation is handled by SplashScreen's BlocListener for AuthStatus.authenticated
        },
        builder: (context, state) {
          if (state.status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    },
                    child: const Text('Don\'t have an account? Sign Up'),
                  ),
                  const SizedBox(height: 20),
                  const Text("Or sign in with:"),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.g_mobiledata, color: Colors.red), // Example icon
                            label: const Text('Google'),
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthGoogleSignInRequested());
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white70),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.no_accounts),
                            label: const Text('Anonymous'),
                            onPressed: () {
                              context.read<AuthBloc>().add(AuthAnonymousSignInRequested());
                            },
                             style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300]),
                          ),
                        ],
                      )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
