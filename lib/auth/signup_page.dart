import 'package:easy_chat/auth/signin_page.dart';
import 'package:easy_chat/home/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.230),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 6, 16, 33),
                        Color.fromARGB(255, 15, 84, 77),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 170,
                                  width: 170,
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: screenWidth * 0.270,
                                  child: TextFormField(
                                    controller: _nameController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.user,
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: screenWidth * 0.270,
                                  child: TextFormField(
                                    controller: _emailController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.white,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: screenWidth * 0.270,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.lock,
                                        color: Colors.white,
                                      ),
                                    ),
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      try {
                                        await _auth
                                            .createUserWithEmailAndPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                        );

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        String errorMessage =
                                            'Sign-up failed. Please try again.';
                                        if (e.code == 'email-already-in-use') {
                                          errorMessage =
                                              'This email is already registered. Please sign in.';
                                        }

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(errorMessage),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      } finally {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text('Sign Up'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                          height: 300,
                          width: 1,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            const SizedBox(height: 110),
                            TextButton.icon(
                              onPressed: () {
                                // Perform signup with Gmail
                              },
                              icon: const FaIcon(FontAwesomeIcons.google),
                              label: const Text('Signup with Gmail'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SigninPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                              ),
                              child:
                                  const Text('Already have an account? Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
