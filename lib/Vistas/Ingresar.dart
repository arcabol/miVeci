import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veci/main.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class Ingresar extends StatefulWidget {
  const Ingresar({Key? key}) : super(key: key);

  @override
  _IngresarState createState() => _IngresarState();
}

class _IngresarState extends State<Ingresar> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  int? _success;

  String _userEmail = '';
  String _userid = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 0),
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Ingrese email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 0),
                      child: TextFormField(
                        controller: _passController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingrese el password';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: SignInButtonBuilder(
                        icon: Icons.login,
                        backgroundColor: Colors.deepOrangeAccent,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _Ingresar();
                            if (_success! == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Ingreso Exitoso $_userEmail')));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        tiendas(),
                              )
                              );
                            }
                          }
                        },
                        text: 'Login',
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
  Future<void> _Ingresar() async {
    try {
      final User? user = (await auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,

      ))
          .user;

      if (user != null) {
        setState(() {
          _success = 1;
          _userEmail = user.email ?? '';
          _userid = user.uid;
        });
      } else {
        _success = 0;
      }
    } catch (e) {
      _success = 2;
    }
  }
}
