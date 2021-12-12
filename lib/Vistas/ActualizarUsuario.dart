import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:veci/Modelos/Usuario.dart';
import 'package:veci/main.dart';
import 'Ingresar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActualizarUsuario extends StatefulWidget {
  final Usuario usuario;
  ActualizarUsuario(this.usuario);


  @override
  _ActualizarUsuarioState createState() => _ActualizarUsuarioState();
}

class _ActualizarUsuarioState extends State<ActualizarUsuario> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nombreController;
  late TextEditingController _direccionController;
  late TextEditingController _telefonoController;
  late TextEditingController _celularController;
  final firebase = FirebaseFirestore.instance;
  final User? user = auth.currentUser;


  @override
  void initState() {
    super.initState();

    _nombreController = new TextEditingController(text: widget.usuario.nombre);
    _direccionController = new TextEditingController(text: widget.usuario.direccion);
    _telefonoController = new TextEditingController(text: widget.usuario.telefono);
    _celularController = new TextEditingController(text: widget.usuario.celular);
  }


  ActualizarDatos() async {
    try {
      await firebase.collection("Usuarios").doc(user!.uid).set({
        "Nombre": _nombreController.text,
        "Direccion": _direccionController.text,
        "Telefono": _telefonoController.text,
        "Celular": _celularController.text,
        "Estado": true
      });
      mensaje("Mensaje", "Actualizacion de datos correcta");
    } catch (e) {

     mensaje("Error...", "" + e.toString());
    }
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
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        appBar: AppBar(
          title: Text('Actualizar Datos'),
          automaticallyImplyLeading: false,
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
                          controller: _nombreController,

                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Ingrese Nombre Completo';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15, bottom: 0),
                        child: TextFormField(
                          controller: _direccionController,

                          decoration: const InputDecoration(
                            labelText: 'Direccion',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Ingrese la direccion';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15, bottom: 0),
                        child: TextFormField(
                          controller: _telefonoController,

                          decoration: const InputDecoration(
                            labelText: 'Telefono',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Ingrese el Telefono';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15, bottom: 0),
                        child: TextFormField(
                          controller: _celularController,

                          decoration: const InputDecoration(
                            labelText: 'Celular',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Ingrese el Celular';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        alignment: Alignment.center,
                        child: SignInButtonBuilder(
                          icon: Icons.person_add,
                          backgroundColor: Colors.deepOrangeAccent,
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await ActualizarDatos();
                              _nombreController.clear();
                              _direccionController.clear();
                              _nombreController.clear();
                              _telefonoController.clear();
                              _celularController.clear();
                            }
                          },
                          text: 'Registrar',
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