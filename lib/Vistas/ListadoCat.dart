import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'DetalleTienda.dart';

class ListadoCat extends StatefulWidget {
  final String cat;

  ListadoCat(this.cat);

  @override
  _ListadoCatState createState() => _ListadoCatState();
}

class _ListadoCatState extends State<ListadoCat> {
  final firebase = FirebaseFirestore.instance;
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
                        .where('Categoria', isEqualTo: widget.cat)
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
                            return GestureDetector(
                                onTap: () {
                              Get.to(DetalleTienda(),
                                  transition: Transition.downToUp,
                                  arguments: snapshot.data!.docs[index]);
                            },
                            child: Card(
                              shadowColor: Colors.orange,
                              elevation: 5,
                              color: Colors.white70,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.all(5),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      snapshot.data!.docs[index].get('Imagen')),
                                ),
                                title: Text(
                                  snapshot.data!.docs[index].get('Nombre'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22.0),
                                ),
                                subtitle: Text(
                                  snapshot.data!.docs[index].get('Direccion'),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                              ),
                            ));
                            //}else{
                            //  return new Card();
                            //   }
                          });
                    }),
              ),
            )));
  }
}
