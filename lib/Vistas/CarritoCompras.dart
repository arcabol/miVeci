import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veci/Vistas/Buscar.dart';
import 'package:veci/main.dart';
import 'Ingresar.dart';

class CarritoCompras extends StatefulWidget {
  @override
  _CarritoComprasState createState() => _CarritoComprasState();
}

class _CarritoComprasState extends State<CarritoCompras> {
  final User? user = auth.currentUser;
  final firebase = FirebaseFirestore.instance;
  int total = 0;

  num totalcompra = 0;

  borrarDocumento(String idItem) async {
    try {
      await firebase.collection("Carrito").doc(idItem).delete();
      calcularTotal();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    calcularTotal();
    super.initState();
  }

  confirmar(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
                child: Column(children: [
              InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Domicilio",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.home,
                          color: Colors.deepOrange,
                        )
                      ],
                    ),
                  )),
              InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey))),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Recoger en Tienda",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Icon(
                          Icons.store,
                          color: Colors.deepOrange,
                        )
                      ],
                    ),
                  )),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Aceptar", style: TextStyle(color: Colors.white)),
              ),
            ])),
          );
        });
  }

  actualizarCantidad(int _cant, String item, int precio) async {
    try {
      await firebase
          .collection("Carrito")
          .doc(item)
          .update({'Cantidad': _cant});

      await firebase
          .collection("Carrito")
          .doc(item)
          .update({'ValorProducto': _cant * precio});
    } catch (e) {
      print(e);
    }
  }

  String calcularTotal() {
    firebase
        .collection('Carrito')
        .where('UsuarioId', isEqualTo: user!.uid)
        .get()
        .then((value) {
      setState(() {
        totalcompra = 0;
        value.docs.forEach((element) {
          totalcompra = totalcompra + element.data()["ValorProducto"];
        });
      });
    });

    return totalcompra.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    Widget pagoTotal = (Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 120),
      height: 80,
      width: 400,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Text("Total:  \$${calcularTotal()}",
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.black))
        ],
      ),
    ));

    Widget ListSection = (Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Carrito").snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                if (snapshot.data!.docs[index].get("UsuarioId") == user!.uid) {
                  var cant = new List<int>.filled(snapshot.data!.docs.length,
                      snapshot.data!.docs[index].get("Cantidad"));

                  total = snapshot.data!.docs[index].get("PrecioItem") *
                      snapshot.data!.docs[index].get("Cantidad");

                  return Card(
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
                          flex: 12,
                          child: Container(
                            padding: const EdgeInsets.only(top: 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                    snapshot.data!.docs[index]
                                        .get("NombreItem"),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold)),
                                Text(
                                  'Precio: \$${snapshot.data!.docs[index].get("PrecioItem")}',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  'Total: \$${total}',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 8.0,
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.remove),
                                            onPressed: () {
                                              setState(() {
                                                if (cant[index] == 1) {
                                                  cant[index] = 1;
                                                } else {
                                                  cant[index] = cant[index] - 1;
                                                }
                                                actualizarCantidad(
                                                    cant[index],
                                                    snapshot
                                                        .data!.docs[index].id,
                                                    snapshot.data!.docs[index]
                                                        .get("PrecioItem"));

                                                calcularTotal();
                                              });
                                            },
                                            color: Colors.deepOrange,
                                          ),
                                          Text(cant[index].toString(),
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          IconButton(
                                            icon: Icon(Icons.add),
                                            onPressed: () {
                                              setState(() {
                                                cant[index] = cant[index] + 1;

                                                actualizarCantidad(
                                                    cant[index],
                                                    snapshot
                                                        .data!.docs[index].id,
                                                    snapshot.data!.docs[index]
                                                        .get("PrecioItem"));

                                                calcularTotal();
                                              });
                                            },
                                            color: Colors.deepOrange,
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                          icon: const Icon(
                                              Icons.delete_outline_outlined),
                                          tooltip: "Borrar del carrito",
                                          onPressed: () {
                                            borrarDocumento(
                                                snapshot.data!.docs[index].id);
                                          }),
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
          }),
    ));

    return Scaffold(
        appBar: AppBar(title: Text("Carrito de compras"), actions: <Widget>[
          IconButton(
            tooltip: 'Inicio',
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => tiendas()),
              );
            },
          ),
          IconButton(
            tooltip: 'Busqueda',
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Buscar()),
              );
            },
          ),
        ]),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                ListSection,
                pagoTotal,
                Padding(
                  padding: EdgeInsets.only(left: 0, top: 20),
                  child: SignInButtonBuilder(
                    icon: Icons.task_alt,
                    backgroundColor: Colors.deepOrangeAccent,
                    onPressed: () {
                      confirmar(context);
                    },
                    text: 'Confirmar compra',
                  ),
                ),
                //pagoTotal(totalProd),
              ],
            ),
          ),
        ));
  }
}
