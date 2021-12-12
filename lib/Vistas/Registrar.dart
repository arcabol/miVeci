import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:veci/Vistas/RegistrarInfo.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Registrar extends StatefulWidget {
  const Registrar({Key? key}) : super(key: key);

  @override
  _RegistrarState createState() => _RegistrarState();
}

class _RegistrarState extends State<Registrar> {
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
        title: Text('Registrar'),
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
                        icon: Icons.next_plan,
                        backgroundColor: Colors.deepOrangeAccent,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _Registrar();
                            if (_success! == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Registro Exitoso $_userEmail')));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        RegistrarInfo(_userid)),
                              );
                            }
                          }
                        },
                        text: 'Continuar',
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // Example code for registration.
  Future<void> _Registrar() async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passController.text,

      ))
          .user;
      assert(await user?.getIdToken() != null);
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

      if (e
          .toString()
          .contains("The email address is already in use by another account")) {
        mensaje ("Email ya existe");
      }else{
      if (e
          .toString()
          .contains("The email address is badly formatted")) {
        mensaje ("Email incorrecto");
      }else{
      if (e
          .toString()
          .contains("Password should be at least")) {
        mensaje ("Password debe contener al menos 6 caracteres");
      }else{
      mensaje(e.toString());}}}
    }
  }

  void mensaje(String mess) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mess)));
  }
}
