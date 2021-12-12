import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Ingresar.dart';

class ListadoTiendas extends StatefulWidget {
  const ListadoTiendas({Key? key}) : super(key: key);

  @override
  _ListadoTiendasState createState() => _ListadoTiendasState();
}

class _ListadoTiendasState extends State<ListadoTiendas> {
  final User? user = auth.currentUser;
  final firebase = FirebaseFirestore.instance;


/*  @override
  void initState() {
    datalist = firebase.collection('Clientes')
        //.where('Nombre', isEqualTo: 'Hornitos')

        .snapshots();

    super.initState();
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Listado de Tiendas"),
        ),
        body: SingleChildScrollView(
            child: Container(
          child: Center(
            child: StreamBuilder(
                stream: firebase.collection('Clientes')
                .where('idUsuario', isEqualTo: user!.uid)
                    .where('Estado', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                       // if(snapshot.data!.docs[index].get("idUsuario") == user?.uid ) {
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
                                  flex: 12,
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                            snapshot.data!.docs[index]["Nombre"]
                                            ,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          'Direccion: ${snapshot.data!
                                              .docs[index].get("Direccion")}',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.w300),
                                        ),
                                        Text(
                                          'Telefono: ${snapshot.data!
                                              .docs[index].get("Telefono")}',
                                          style: TextStyle(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () {
                                                      setState(() {});
                                                    },
                                                    color: Colors.deepOrange,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(Icons.delete),
                                                    onPressed: () {
                                                      setState(() {});
                                                    },
                                                    color: Colors.deepOrange,
                                                  ),
                                                ],
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
                        //}else{
                        //  return new Card();
                         //   }
                      });
                }),
          ),
        )));
  }
}
