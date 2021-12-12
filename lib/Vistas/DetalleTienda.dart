import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:veci/Modelos/Carrito.dart';
import 'package:veci/Vistas/CarritoCompras.dart';

import 'package:veci/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Ingresar.dart';
import 'RegistrarProducto.dart';

bool _visible = true;

final firebase = FirebaseFirestore.instance;

class DetalleTienda extends StatefulWidget {
  const DetalleTienda({Key? key}) : super(key: key);

  @override
  _DetalleTiendaState createState() => _DetalleTiendaState();
}

class _DetalleTiendaState extends State<DetalleTienda> {
  _DetalleTiendaState() {
    Checkuser();
  }
  void Checkuser() {
    final User? user = auth.currentUser;
    if (user?.uid != null) {
      _visible = true;
    } else {
      _visible = false;
    }
  }

  String idTienda = Get.arguments.id;
  agregarCarrito(Carrito cartShopping) async {
    try {
      await firebase.collection("Carrito").doc().set({
        "UsuarioId": cartShopping.idUser,
        "NombreTienda": cartShopping.nombreTienda,
        "ProductoId": cartShopping.idItem,
        "PrecioItem": cartShopping.precioProd,
        "NombreItem": cartShopping.nombreProd,
        "Descripcion": cartShopping.descripcion,
        "Cantidad": cartShopping.cantidad,
        "ValorProducto": cartShopping.valorProd,
      });
      mensaje("Correcto", "Registro correto");
    } catch (e) {
      print(e);
      mensaje("Error...", "" + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(Get.arguments['Nombre'],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    Color color = Theme.of(context).primaryColor;
    Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButtonColumn(
            color, Icons.web, 'Pagina Web', Get.arguments['PaginaWeb']),
        _buildButtonColumn(color, Icons.location_on, 'Ubicacion',
            '${Get.arguments['Direccion']}'),
        _buildButtonColumn(color, Icons.local_phone, 'Contacto',
            '${Get.arguments['Telefono']}'),
        _buildButtonColumn(color, Icons.mobile_friendly, 'Celular',
            '${Get.arguments['Celular']}'),
      ],
    );
    Widget ListSection = (Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("Productos").snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.docs[index].get("IdTienda") ==
                      Get.arguments.id) {
                    return new Card(
                      shadowColor: Colors.orange,
                      elevation: 5,
                      color: Colors.white70,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(0),
                        child: Row(children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(snapshot
                                          .data!.docs[index]
                                          .get("Imagen")),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 12,
                            child: Container(
                              padding: const EdgeInsets.only(top: 2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(snapshot.data!.docs[index].get("Nombre"),
                                      style: TextStyle(
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.bold)),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        'Precio: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        snapshot.data!.docs[index]
                                            .get("Precio").toString(),
                                        style: TextStyle(fontSize: 10.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        snapshot.data!.docs[index]
                                            .get("Descripcion"),
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                            onPressed: () {},
                                            child: Text("DETALLE")),
                                         IconButton(
                                            icon: const Icon(
                                                Icons.add_shopping_cart),
                                            tooltip: "Agregar al carrito",
                                            onPressed: () {
                                              final User? user =
                                                  auth.currentUser;
                                              if (user?.uid == null) {
                                                mensaje("Atencion", "Loguearse para agregar al carrito y comprar");
                                              } else {


                                              Carrito cart = new Carrito();
                                              cart.descripcion = snapshot
                                                  .data!.docs[index]
                                                  .get("Descripcion");
                                              cart.nombreProd = snapshot
                                                  .data!.docs[index]
                                                  .get("Nombre");
                                              cart.nombreTienda =
                                                  Get.arguments['Nombre'];
                                              cart.idItem =
                                                  snapshot.data!.docs[index].id;
                                              cart.precioProd = snapshot
                                                  .data!.docs[index]
                                                  .get("Precio");
                                              cart.valorProd = snapshot
                                                  .data!.docs[index]
                                                  .get("Precio")*cart.cantidad;
                                              cart.idUser = user!.uid;

                                              agregarCarrito(cart);

                                              print(cart.idUser);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          CarritoCompras(
                                                              )));
                                            }
                                            }
                                          ),

                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  } else {
                    return new Card();
                  }
                },
              );
            })));

    return Scaffold(
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => RegistrarProducto(idTienda)));
          }),
      ),
      appBar: AppBar(
        title: const Text('Negocios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarritoCompras(),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => tiendas(),
                  ));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              titleSection,
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Center(
                  child: Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: NetworkImage(Get.arguments['Imagen']),
                      fit: BoxFit.contain,
                      //colorFilter: ColorFilter.mode(
                      // Colors.black45, BlendMode.darken)
                    )),
                  ),
                ),
              ),
              buttonSection,
              ListSection,
            ],
          ),
        ),
      ),
    );
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    ;
  }

  Column _buildButtonColumn(
      Color color, IconData icons, String label, String informacion) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(icons),
          color: color,
          onPressed: () {
            if (label == 'Pagina Web') {
              String url = informacion;
              launchURL(url);
            } else {
              mensaje(label, informacion);
            }
            ;
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  void mensaje(String titulo, String mess) {
    showDialog(
        context: context,
        builder: (builcontex) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(mess),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ),
            ],
          );
        });
  }
}
