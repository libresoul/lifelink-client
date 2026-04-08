import 'package:flutter/material.dart';
import 'package:open_mail/open_mail.dart';
import 'package:lifelink/core/network/api_client.dart';
import 'package:lifelink/core/storage/session_store.dart';
import 'package:lifelink/screens/onboarding/onboarding_screen.dart';
import 'package:lifelink/widgets/loading_button.dart';

class ConfirmEmailPage extends StatefulWidget {
  final String email;
  final String password;
  final String userId;

  const ConfirmEmailPage({
    super.key,
    required this.email,
    required this.password,
    required this.userId,
  });

  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  bool _isLoading = false;
  bool _isMailLoading = false;
  List<MailApp> _availableApps = [];
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.password.isEmpty) {
      _passwordController.text = '';
    }
    _loadMailApps();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadMailApps() async {
    setState(() => _isMailLoading = true);
    try {
      final apps = await OpenMail.getMailApps();
      setState(() => _availableApps = apps);
    } catch (_) {
      setState(() => _availableApps = []);
    } finally {
      setState(() => _isMailLoading = false);
    }
  }

  Future<void> _openMailAppWithPicker() async {
    if (_availableApps.isEmpty) {
      showNoMailAppsDialog(context);
      return;
    }

    if (_availableApps.length == 1) {
      await OpenMail.openMailApp();
      return;
    }

    final selectedApp = await showDialog<MailApp>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Email App'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _availableApps.length,
            itemBuilder: (context, index) {
              final app = _availableApps[index];
              return ListTile(
                leading: const Icon(Icons.email),
                title: Text(app.name),
                onTap: () => Navigator.of(context).pop(app),
              );
            },
          ),
        ),
      ),
    );

    if (selectedApp != null) {
      await OpenMail.openSpecificMailApp(selectedApp.name);
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Mail Apps Found'),
        content: const Text(
          'There are no email apps installed on your device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _onDonePressed() async {
    final password = widget.password.isNotEmpty
        ? widget.password
        : _passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your password')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final loginResponse = await ApiClient().login(
        email: widget.email,
        password: password,
      );
      await SessionStore().save(
        accessToken: loginResponse.accessToken,
        refreshToken: loginResponse.refreshToken,
        userId: loginResponse.userId,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingScreen(userId: widget.userId),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final message = e.toString();
      if (message.toLowerCase().contains('confirm') ||
          message.toLowerCase().contains('verified') ||
          message.toLowerCase().contains('unconfirmed')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email not confirmed yet. Please check your mailbox and click the verification link.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex <= 1) return email;
    final name = email.substring(0, atIndex);
    final domain = email.substring(atIndex);
    final visible = name.length <= 2 ? name : name.substring(0, 2);
    return '$visible...$domain';
  }

  @override
  Widget build(BuildContext context) {
    final masked = _maskEmail(widget.email);

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm your email')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.mark_email_read, size: 72, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              'Check your inbox',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text('We sent a verification link to', textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(
              masked,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            LoadingButton(
              isLoading: _isMailLoading,
              onTapped: _openMailAppWithPicker,
              buttonColor: const Color(0xFFF4C9CA),
              labelColor: Colors.black,
              buttonLabel: _availableApps.length == 1
                  ? 'Open Mail App'
                  : 'Open my mailbox',
            ),
            const SizedBox(height: 12),
            if (widget.password.isEmpty) ...[
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 12),
            ],
            LoadingButton(
              isLoading: _isLoading,
              onTapped: _onDonePressed,
              buttonColor: const Color(0xFFE71B1E),
              labelColor: Colors.white,
              buttonLabel: 'Done',
            ),
            const SizedBox(height: 12),
            LoadingButton(
              isLoading: false,
              onTapped: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => OnboardingScreen(userId: widget.userId),
                ),
              ),
              buttonColor: const Color(0xFFF4C9CA),
              labelColor: Colors.black,
              buttonLabel: 'Skip for now',
            ),
          ],
        ),
      ),
    );
  }
}
