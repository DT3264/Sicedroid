import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sicedroid/Models/status.dart';
import 'package:sicedroid/Routes/routes.dart';
import 'package:sicedroid/Utils/orientations.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Utils/theme.dart';
import 'package:sicedroid/Utils/strings.dart' as strings;
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/';
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String matricula = '';
  String clave = '';
  final textMatriculaNode = FocusNode();
  final textClaveFocusNode = FocusNode();
  var textMatriculaController = TextEditingController();
  var textClaveController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  bool isLogingIn = false;

  void initState() {
    super.initState();
    portraitModeOnly();
    try {
      Singleton.get().initSharedPrefs().then((v) {
        var sharedPrefs = Singleton.get().sharedPrefs;
        if (sharedPrefs.containsKey(strings.matricula) &&
            sharedPrefs.containsKey(strings.clave)) {
          matricula = sharedPrefs.get(strings.matricula);
          clave = sharedPrefs.get(strings.clave);
          textMatriculaController.text = matricula;
          textClaveController.text = clave;
          _login();
        }
      });
    } on Exception catch (e, s) {
      print(e);
      print(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldkey,
        body: SingleChildScrollView(child: _getBody(context)));
  }

  Widget _getBody(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var textMatricula = TextFormField(
      controller: textMatriculaController,
      decoration: InputDecoration(
          labelText: 'Matrícula',
          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
      focusNode: textMatriculaNode,
      onFieldSubmitted: (s) {
        _setMatricula(s);
        FocusScope.of(context).requestFocus(textClaveFocusNode);
      },
      textInputAction: TextInputAction.next,
      validator: (val) {
        if (val.isEmpty) {
          return 'Ingrese una matricula';
        }
        return null;
      },
    );
    var textClave = TextFormField(
      controller: textClaveController,
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Contraseña',
          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
      focusNode: textClaveFocusNode,
      onFieldSubmitted: (s) => _setClave(s),
      textInputAction: TextInputAction.done,
      validator: (val) {
        if (val.isEmpty) {
          return 'Ingrese una contraseña';
        }
        return null;
      },
    );
    var btnEnviar = RaisedButton(
      child: Text(
        'ENTRAR',
        style: TextStyle(color: Colors.white),
      ),
      color: primaryColor,
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _login();
        }
      },
    );
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
              child: Container(
            height: height * .45,
            color: primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'SICEDroid',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      backgroundColor: primaryColor),
                ),
              ],
            ),
          )),
          Container(
              height: height * .55,
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ListTile(title: textMatricula),
                      Divider(),
                      ListTile(title: textClave),
                      Divider(),
                      isLogingIn
                          ? CircularProgressIndicator()
                          : ListTile(title: btnEnviar),
                    ],
                  )))
        ],
      ),
    );
  }

  void _setMatricula(String matricula) {
    this.matricula = matricula;
  }

  void _setClave(String clave) {
    this.clave = clave;
  }

  Future<void> _login() async {
    setState(() {
      isLogingIn = true;
    });
    var s = Status.fromDynamic({"acceso": false});
    try {
      s = await Singleton.get().webServiceAlumnos.login(matricula, clave);
    } on DioError catch (e) {
      print(e);
    }
    if (s == null) {
      setState(() {
        isLogingIn = false;
      });
      _showSnackBar(strings.sinInternet);
      return;
    }
    if (s.acceso) {
      await Singleton.get().sharedPrefs.setString(strings.matricula, matricula);
      await Singleton.get().sharedPrefs.setString(strings.clave, clave);
      textMatriculaController.text = '';
      textClaveController.text = '';
      setState(() {
        isLogingIn = false;
      });
      Navigator.pushReplacementNamed(context, Routes.main);
    } else {
      setState(() {
        isLogingIn = false;
      });
      _showSnackBar('Matrícula o contraseña incorrectos');
    }
  }

  void _showSnackBar(String message) =>
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
}
