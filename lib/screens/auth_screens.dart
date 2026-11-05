import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum _AuthMode { login, register, forgotPassword }

class AuthScreen extends StatefulWidget {
  const AuthScreen({required this.onAuthenticated, super.key});

  final Future<void> Function(String name, String email) onAuthenticated;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  _AuthMode _mode = _AuthMode.login;
  bool _showPassword = false;
  bool _rememberMe = true;
  bool _agreedToTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_mode == _AuthMode.register && !_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the terms to continue.')),
      );
      return;
    }
    if (_mode == _AuthMode.forgotPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password reset email is unavailable until an authentication service is connected.',
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.onAuthenticated(
        _mode == _AuthMode.register
            ? _nameController.text.trim()
            : _emailController.text.trim().split('@').first,
        _emailController.text.trim(),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open YGUIDE: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRegister = _mode == _AuthMode.register;
    final isForgotPassword = _mode == _AuthMode.forgotPassword;
    final title = isForgotPassword
        ? 'Reset your password'
        : isRegister
        ? 'Create your account'
        : 'Welcome back';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/auth-travel.jpg', fit: BoxFit.cover),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x330D123F),
                  Color(0x66301683),
                  Color(0xD9101029),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .18),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: .35),
                              ),
                            ),
                            child: const Icon(
                              Icons.explore_rounded,
                              color: Colors.white,
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 11),
                          const Text(
                            'YGUIDE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 34),
                      const Text(
                        'The world is waiting.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          height: 1.1,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find the places that stay with you.',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .97),
                          borderRadius: BorderRadius.circular(26),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x380B0B26),
                              blurRadius: 28,
                              offset: Offset(0, 14),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(
                                  color: AppColors.text,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isForgotPassword
                                    ? 'Enter your email to request a reset link.'
                                    : isRegister
                                    ? 'Join YGUIDE and plan your next adventure.'
                                    : 'Sign in to pick up where you left off.',
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (isRegister) ...[
                                TextFormField(
                                  key: const ValueKey('auth-name'),
                                  controller: _nameController,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                    labelText: 'Full name',
                                    prefixIcon: Icon(Icons.person_outline),
                                  ),
                                  validator: (value) =>
                                      value == null || value.trim().isEmpty
                                      ? 'Enter your name'
                                      : null,
                                ),
                                const SizedBox(height: 13),
                              ],
                              TextFormField(
                                key: const ValueKey('auth-email'),
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: isForgotPassword
                                    ? TextInputAction.done
                                    : TextInputAction.next,
                                decoration: const InputDecoration(
                                  labelText: 'Email address',
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                                validator: (value) =>
                                    value == null ||
                                        !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                                            .hasMatch(value.trim())
                                    ? 'Enter a valid email address'
                                    : null,
                              ),
                              if (!isForgotPassword) ...[
                                const SizedBox(height: 13),
                                TextFormField(
                                  key: const ValueKey('auth-password'),
                                  controller: _passwordController,
                                  obscureText: !_showPassword,
                                  textInputAction: isRegister
                                      ? TextInputAction.next
                                      : TextInputAction.done,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                    ),
                                    suffixIcon: IconButton(
                                      tooltip: _showPassword
                                          ? 'Hide password'
                                          : 'Show password',
                                      onPressed: () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                      ),
                                    ),
                                  ),
                                  validator: (value) =>
                                      value == null || value.length < 8
                                      ? 'Use at least 8 characters'
                                      : null,
                                ),
                              ],
                              if (isRegister) ...[
                                const SizedBox(height: 13),
                                TextFormField(
                                  key: const ValueKey('auth-confirm-password'),
                                  controller: _confirmPasswordController,
                                  obscureText: !_showPassword,
                                  decoration: const InputDecoration(
                                    labelText: 'Confirm password',
                                    prefixIcon: Icon(Icons.lock_reset_rounded),
                                  ),
                                  validator: (value) =>
                                      value != _passwordController.text
                                      ? 'Passwords do not match'
                                      : null,
                                ),
                                Material(
                                  color: Colors.transparent,
                                  child: CheckboxListTile(
                                    value: _agreedToTerms,
                                    onChanged: (value) => setState(
                                      () => _agreedToTerms = value ?? false,
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    title: const Text(
                                      'I agree to the Terms and Conditions',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                              ],
                              if (!isRegister && !isForgotPassword)
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 145,
                                      height: 38,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: _rememberMe,
                                            onChanged: (value) => setState(
                                              () =>
                                                  _rememberMe = value ?? false,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          const Flexible(
                                            child: Text(
                                              'Remember me',
                                              style: TextStyle(fontSize: 12),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: () => setState(
                                        () => _mode = _AuthMode.forgotPassword,
                                      ),
                                      child: const Text('Forgot password?'),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: FilledButton(
                                  onPressed: _isSubmitting ? null : _submit,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          height: 21,
                                          width: 21,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          isForgotPassword
                                              ? 'Send reset link'
                                              : isRegister
                                              ? 'Create account'
                                              : 'Log in',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Center(
                                child: TextButton(
                                  onPressed: () => setState(
                                    () => _mode = isForgotPassword
                                        ? _AuthMode.login
                                        : isRegister
                                        ? _AuthMode.login
                                        : _AuthMode.register,
                                  ),
                                  child: Text(
                                    isForgotPassword
                                        ? 'Back to log in'
                                        : isRegister
                                        ? 'Already have an account? Log in'
                                        : 'New here? Create an account',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(11),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3F0FF),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: AppColors.primary,
                                      size: 17,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Preview mode: authentication is not connected. No password is stored or verified.',
                                        style: TextStyle(
                                          color: AppColors.darkPurple,
                                          fontSize: 11,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
