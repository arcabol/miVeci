import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:get/get.dart';
import 'package:veci/Vistas/DetalleTienda.dart';

class Buscar extends StatefulWidget {
  const Buscar({Key? key}) : super(key: key);

  @override
  _BuscarState createState() => _BuscarState();
}

class _BuscarState extends State<Buscar> {
  int? valor = 1;
  final TextEditingController search = TextEditingController();
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection('Clientes').snapshots();
  bool isExecuted = false;
  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  if (snapshot.data!.docs[index]
                      .get("Nombre")
                      .toString()
                      .toUpperCase()
                      .contains(search.text.toUpperCase())) {
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
                      ),
                    );
                  } else {
                    return new Card();
                  }
                });
          });
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.clear),
          onPressed: () {
            setState(() {
              search.clear();
              isExecuted = false;
            });
          }),
      appBar: AppBar(
        title: const Text("Busqueda"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, top: 25, right: 25, bottom: 0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Buscar', border: OutlineInputBorder()),
                controller: search,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: 0,
                  groupValue: valor,
                  onChanged: (int? value) {
                    setState(() {
                      valor = value;
                    });
                  },
                ),
                Text(
                  'Por tienda',
                  style: new TextStyle(fontSize: 12.0),
                ),
                Radio(
                  value: 1,
                  groupValue: valor,
                  onChanged: (int? value) {
                    setState(() {
                      valor = value;
                    });
                  },
                  //activeColor: Colors.deepOrangeAccent,
                ),
                Text(
                  'Por Producto',
                  style: new TextStyle(fontSize: 12.0),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SignInButtonBuilder(
                icon: Icons.search,
                backgroundColor: Colors.deepOrangeAccent,
                onPressed: () {
                  setState(() {
                    isExecuted = true;
                  });
                },
                text: 'Buscar',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: isExecuted ? searchedData() : Container(),
            ),
          ],
        ),
      ),
    );
  }
}
