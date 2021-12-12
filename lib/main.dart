import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:get/get.dart';
import 'package:veci/Vistas/ActualizarUsuario.dart';
import 'package:veci/Vistas/CarritoCompras.dart';
import 'Vistas/CambiarPass.dart';
import 'Vistas/ListadoCat.dart';
import 'Vistas/ListadoTiendas.dart';
import 'Vistas/Registrar.dart';
import 'Vistas/Ingresar.dart';
import 'Vistas/Buscar.dart';
import 'Vistas/RegistroTiendas.dart';
import 'Modelos/Usuario.dart';

bool _visible = true;
String _usuario = "Invitado";
final firebase = FirebaseFirestore.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

/// This is the main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'App para las tiendas del Barrio';

  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: tiendas(),
      duration: 6000,
      imageSize: 130,
      imageSrc: "assets/images/Veci_blanco.png",
      text: '''Bienvenidos a 
mi Veci''',
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Colors.yellow,
        Colors.deepOrange,
        Colors.purple,
        Colors.blue,
      ],
      backgroundColor: Colors.white,
    );
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: example1,
    );
  }
}

/// This is the stateless widget that the main application instantiates.
class tiendas extends StatefulWidget {
  const tiendas({Key? key}) : super(key: key);

  @override
  _tiendasState createState() => _tiendasState();
}

class _tiendasState extends State<tiendas> {
  Usuario usuario = new Usuario();

  Future<void> _signOut() async {
    await auth.signOut();
  }

  _tiendasState() {
    Checkuser();
    Checkemail();
  }
  void Checkemail() {
    final User? user = auth.currentUser;

    if (user?.email != null) {
      _usuario = "${user?.email}";
    } else {
      _usuario = "Invitados";
    }
  }

  void Checkuser() {
    final User? user = auth.currentUser;

    if (user?.uid != null) {
      _visible = false;
    } else {
      _visible = true;
    }
  }

  Future<void> encontrarUsuario() async {
    final User? user = auth.currentUser;

    await firebase.collection("Usuarios").doc(user?.uid).get().then((value) {
      print(value.data());

      usuario.nombre = value.data()!["Nombre"];
      usuario.direccion = value.data()!["Direccion"];
      usuario.telefono = value.data()!["Telefono"];
      usuario.celular = value.data()!["Celular"];
    });
  }

  Container Categorias(String imagenCat, String Heading) {
    return Container(
      width: 150.0,
      child: Card(
        shadowColor: Colors.deepOrange,
        elevation: 6,
        color: Colors.white70,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Wrap(
          children: <Widget>[
            Image.asset(imagenCat),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ListadoCat(Heading)));
              },
              title: Text(
                Heading,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardSection = Container(
      margin: EdgeInsets.symmetric(vertical: 15.0),
      height: 200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Categorias("assets/images/petshop.png", "Veterinarias"),
          Categorias("assets/images/supermarket.png", "Supermercados"),
          Categorias("assets/images/restaurant.png", "Restaurantes"),
          Categorias("assets/images/repair-shop.png", "Ferreterias"),
          Categorias("assets/images/pharmacy.png", "Droguerias"),
        ],
      ),
    );
    Widget titleSection = Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Productos y Servicios',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      //fontSize: ,
                      //color: Colors.blue[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    Color color = Theme.of(context).primaryColor;

    return Scaffold(
      drawer: Container(
        width: 250.0,
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text('Bienvenido'),
                accountEmail: Text(_usuario),
                currentAccountPicture: GestureDetector(
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person))),
                decoration: BoxDecoration(color: Colors.deepOrange)),
            ListTile(
                leading: Icon(Icons.app_registration, color: Colors.deepOrange),
                title: Text('Registrar'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Registrar();
                  }));
                }),
            Visibility(
              visible: _visible,
              child: ListTile(
                  leading: Icon(Icons.login, color: Colors.deepOrange),
                  title: Text('Ingresar'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Ingresar();
                    }));

                    setState(() {
                      Checkuser();
                    });
                  }),
            ),
            Visibility(
              visible: !_visible,
              child: ExpansionTile(
                  leading: Icon(Icons.storefront, color: Colors.deepOrange),
                  title: Text('Gestion de Tiendas'),
                  children: <Widget>[
                    ListTile(
                      title: Text("Registrar Tienda"),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return RegistroTiendas();
                        }));
                      },
                    ),
                    ListTile(
                      title: Text("Listado de Tiendas"),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return ListadoTiendas();
                            }));
                      },
                    ),
                  ]),
            ),
            Visibility(
              visible: !_visible,
              child: ExpansionTile(
                  leading: Icon(Icons.account_circle_sharp,
                      color: Colors.deepOrange),
                  title: Text('Gestion de Usuario'),
                  children: <Widget>[
                    ListTile(
                      title: Text("Cambiar Password"),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return CambiarPass();
                        }));
                      },
                    ),
                    ListTile(
                      title: Text("Actualizar datos"),
                      onTap: () {
                        encontrarUsuario();
                        print(usuario.nombre);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ActualizarUsuario(usuario)));
                      },
                    ),
                  ]),
            ),
            Visibility(
              visible: !_visible,
              child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.deepOrange),
                  title: Text('Salir'),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return tiendas();
                    }));
                    _signOut();
                    setState(() {
                      Checkuser();
                    });
                  }),
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('mi Veci'),
        actions: <Widget>[
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
          IconButton(
            tooltip: 'Carrito',
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CarritoCompras()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 0),
              child: Center(
                child: Container(
                  width: 200,
                  height: 200,
                  child: Image.asset('assets/images/Veci.png'),
                ),
              ),
            ),
            titleSection,
            cardSection,
          ],
        ),
      ),
    );
  }
}
