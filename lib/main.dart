// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// ignore: unused_import
import 'package:local_auth/local_auth.dart';
import 'Home_Screen.dart';

void main() {
  runApp(const HRPApp());
}

class HRPApp extends StatelessWidget {
  const HRPApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HRP App',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  @override
  void initState() {
    super.initState();
    testBiometricSupport();
    requestLocationPermission(); // add this
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }

  void testBiometricSupport() async {
    bool canCheck = await auth.canCheckBiometrics;
    bool isAvailable = await auth.isDeviceSupported();

    debugPrint("Can check biometrics: $canCheck");
    debugPrint("Is biometric supported: $isAvailable");
  }

  void handleLogin() {
    if (usernameController.text == "admin" &&
        passwordController.text == "1234") {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid credentials')));
    }
  }

  Future<void> handleBiometricLogin() async {
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool isAuthenticated = false;

    if (canCheckBiometrics) {
      try {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'Use fingerprint to login',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } catch (e) {
        debugPrint("Biometric error: $e");
      }

      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Biometric not available')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Company logo added here
              Image.asset(
                'assets/Image/Name Logo - Transparant PNG.png',
                height: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                'Login to HRP Portal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleLogin,
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              IconButton(
                icon: const Icon(Icons.fingerprint, size: 36),
                onPressed: handleBiometricLogin,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
