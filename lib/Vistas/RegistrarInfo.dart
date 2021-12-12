import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veci/main.dart';

class RegistrarInfo extends StatefulWidget {
  final String userid;
  RegistrarInfo(this.userid);

  @override
  _RegistrarInfoState createState() => _RegistrarInfoState();
}

class _RegistrarInfoState extends State<RegistrarInfo> {
  final firebase = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();

  registroUsuario() async {
    try {
      await firebase.collection("Usuarios").doc(widget.userid).set({
        "Nombre": _nombreController.text,
        "Direccion": _direccionController.text,
        "Telefono": _telefonoController.text,
        "Celular": _celularController.text,
        "Estado": true
      });
      mensaje("Correcto", "Registro correto", context);
    } catch (e) {

      mensaje("Error...", "" + e.toString(),context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Informacion para el registo'),
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
                        onPressed: () async{
                          if (_formKey.currentState!.validate()) {
                            await registroUsuario();
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



  void mensaje(String titulo, String mess, BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context ) {
          return AlertDialog(
            title: Text(titulo),
            content:  Text(mess),
            actions:<Widget> [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => tiendas()));
                },
                child:
                    Text("Aceptar", style: TextStyle(color: Colors.deepOrange)),
              ),
            ],
          );
        });
  }
}
