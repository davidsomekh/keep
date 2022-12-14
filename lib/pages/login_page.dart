import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../auth.dart';
import '../google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    if (!validateDetails()) {
      return;
    }
    try {
      await Auth().signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      showError('Welcome! ${_controllerEmail.text} 👋');
    } on FirebaseAuthException catch (e) {
      showError(e.message!);
    }
  }

  Future passwordReset({required String email}) async {
    if (!verifyUN()) {
      showError('We need your email!');
      return;
    }
    try {
      await Auth().passReset(email: email);

      showError('Reset instructions sent: ${_controllerEmail.text}');
    } on FirebaseAuthException catch (e) {
      showError(e.message!);
    }
  }

  bool validateDetails() {
    if (_controllerEmail.text.isEmpty) {
      showError("We need your email!");
      return false;
    }
    if (_controllerPassword.text.isEmpty) {
      showError("Password?");
      return false;
    }

    return true;
  }

  bool verifyUN() {
    return _controllerEmail.text.isNotEmpty;
  }

  Future signInWithApple() async {
    Auth().appleLogin();
  }

  Future<void> createUserWithEmailAndPassword() async {
    if (!validateDetails()) {
      return;
    }
    try {
      await Auth().createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      showError('Welcome! ${_controllerEmail.text} 👋');
    } on FirebaseAuthException catch (e) {
      showError(e.message!);
    }
  }

  Widget _title() {
    return const Text('Welcome to keeplist! 👋');
  }

  Widget _entryField(
    String title,
    Icon fieldIcon,
    TextEditingController controller,
    bool password,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: fieldIcon,
        ),
        labelText: title,
      ),
      obscureText: password,
    );
  }

  void showError(String msg) {
    var snackBar = SnackBar(content: Text(msg));

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed:
          isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Login' : 'Register'),
    );
  }

  Widget _googleButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, foregroundColor: Colors.white),
      onPressed: () {
        final provider =
            Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogin();
      },
      label: const Text("Login with Google"),
      icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
    );
  }

  Widget _appleButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, foregroundColor: Colors.white),
      onPressed: () {
        signInWithApple();
      },
      label: const Text("Login with Apple"),
      icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.red),
    );
  }

  Widget _forgotButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black, foregroundColor: Colors.white),
      onPressed: () {
        passwordReset(email: _controllerEmail.text);
      },
      label: const Text("Forgot your password?"),
      icon: const FaIcon(FontAwesomeIcons.lock, color: Colors.red),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'New user 👋' : 'Existing user 👋'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _entryField('email', const Icon(Icons.account_circle),
                    _controllerEmail, false),
                _entryField('password', const Icon(Icons.lock),
                    _controllerPassword, true),
                _submitButton(),
                _loginOrRegisterButton(),
                _googleButton(),
                const SizedBox(height: 6),
                _appleButton(),
                const SizedBox(height: 6),
                _forgotButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
