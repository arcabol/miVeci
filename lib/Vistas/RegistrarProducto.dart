import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:veci/Vistas/DetalleTienda.dart';
import 'package:veci/Vistas/Buscar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegistrarProducto extends StatefulWidget {
  final String idTienda;
  RegistrarProducto(this.idTienda);

  @override
  _RegistrarProductoState createState() => _RegistrarProductoState();
}

class _RegistrarProductoState extends State<RegistrarProducto> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final firebase = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();

  File? _imagen;
  final picker = ImagePicker();
  String? _uploadedFileURL;

  Future selImagen(op) async {
    var pickedFile;
    if (op == 1) {
      pickedFile = await picker.pickImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }
    setState(() {
      if (pickedFile != null) {
        _imagen = File(pickedFile.path);
        subirImagen();
      } else {
        print("no seleccionaste ninguna foto");
      }
    });
    Navigator.of(context).pop();
  }

  opciones(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
                child: Column(children: [
              InkWell(
                  onTap: () {
                    selImagen(1);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Tome una foto",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.camera_alt,
                          color: Colors.deepOrange,
                        )
                      ],
                    ),
                  )),
              InkWell(
                  onTap: () {
                    selImagen(2);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Seleccionar una foto",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.image,
                          color: Colors.deepOrange,
                        )
                      ],
                    ),
                  )),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar", style: TextStyle(color: Colors.white)),
              ),
            ])),
          );
        });
  }

  subirImagen() async {
    var imageName = Uuid().v1();
    var imagePath = '$imageName.jpg';
    if (_imagen != null) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images')
          .child(imagePath);
      firebase_storage.UploadTask task = ref.putFile(_imagen!);
      try {
        await task;
        ref.getDownloadURL().then((fileURL) {
          print(fileURL);
          _uploadedFileURL = fileURL;
        });
      } on firebase_core.FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        }
      }
    }
  }

  registroProducto() async {
    try {
      await firebase.collection("Productos").doc().set({
        "Nombre": _nombreController.text,
        "Descripcion": _descripcionController.text,
        "Precio": int.parse(_precioController.text),
        "Imagen": _uploadedFileURL,
        "IdTienda": widget.idTienda,
        "Estado": true
      });
      mensaje("Correcto", "Registro correto", context);
    } catch (e) {
      mensaje("Error...", "" + e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Productos'),
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
                            return 'Ingrese Nombre del Producto';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 0),
                      child: TextFormField(
                        controller: _descripcionController,
                        decoration: const InputDecoration(
                          labelText: 'Descripcion del producto',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Ingrese descripcion';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 0),
                      child: TextFormField(
                        controller: _precioController,
                        decoration: const InputDecoration(
                          labelText: 'Precio',
                          border: OutlineInputBorder(),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Ingrese el precio';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 15, top: 15, right: 15, bottom: 0),
                      child: Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.add_a_photo),
                            color: Colors.deepOrange,
                            onPressed: () {
                              opciones(context);
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          _imagen == null ? Center() : Image.file(_imagen!),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      alignment: Alignment.center,
                      child: SignInButtonBuilder(
                        icon: Icons.add_business,
                        backgroundColor: Colors.deepOrangeAccent,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {

                            await registroProducto();
                            _nombreController.clear();
                            _descripcionController.clear();
                            _precioController.clear();
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
        builder: (context) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mess),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Buscar()));
                },
                child: Text("Aceptar", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
  }
}
