import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:veci/main.dart';


import '../main.dart';
import 'Ingresar.dart';

class CambiarPass extends StatefulWidget {
  const CambiarPass({Key? key}) : super(key: key);

  @override
  _CambiarPassState createState() => _CambiarPassState();
}

class _CambiarPassState extends State<CambiarPass> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;

  final TextEditingController _passNController = TextEditingController();
  final TextEditingController _passAController = TextEditingController();
  final User? user = auth.currentUser;
  int? _success;


  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _emailController = new TextEditingController(text: user!.email);
  }



  void mensaje(String titulo, String mess) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mess),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => tiendas()));
                },
                child: Text(
                    "Aceptar", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }
  void mensajeErr(String titulo, String mess) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mess),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                    "Aceptar", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }
  _changePassword(String userC, String currentPassword,
      String newPassword) async {
    // final User? user = auth.currentUser;
    final cred = EmailAuthProvider.credential(
        email: userC, password: currentPassword);

    user!.reauthenticateWithCredential(cred).then((value) {
      user!.updatePassword(newPassword).then((_) {


        auth.signOut();
        mensaje("Mensaje",
            "Password cambiado correctamente, debe loguearse nuevamente"
            );
      }).catchError((error) {
        if (error
            .toString()
            .contains("Password should be at least")) {
          mensajeErr(
              "Error", "Password debe contener al menos 6 caracteres");
        }else{
        mensajeErr("Error",
            "No se pudo cambiar el password"
            );
      }});
    }).catchError((err) {
      mensaje("Error",
          "Error Password actual"
          );
    });
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Cambio de Password'),
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
                        child: TextField(
                          enabled: false,
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),

                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15, bottom: 0),
                        child: TextFormField(
                          controller: _passAController,
                          decoration: const InputDecoration(
                            labelText: 'Password Actual',
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
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15, bottom: 0),
                        child: TextFormField(
                          controller: _passNController,
                          decoration: const InputDecoration(
                            labelText: 'Password Nuevo',
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
                          icon: Icons.change_circle,
                          backgroundColor: Colors.deepOrangeAccent,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await _changePassword(
                                  _emailController.text,
                                  _passAController.text,
                                  _passNController.text);

                              if (_success! == 1) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Cambio Exitoso $_emailController.text')));
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
                          text: 'Cambiar',
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      );
    }
  }



