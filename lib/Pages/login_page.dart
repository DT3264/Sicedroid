import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:sicedroid/Models/status.dart';
import 'package:sicedroid/Utils/singleton.dart';
import 'package:sicedroid/Utils/theme.dart';
import 'package:sicedroid/Utils/strings.dart' as strings;
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String matricula = '';
  String clave = '';
  bool recordarUsuario = false;
  final textMatriculaNode = FocusNode();
  final textClaveFocusNode = FocusNode();
  var textMatriculaController = TextEditingController();
  var textClaveController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          textMatriculaNode.unfocus();
          textClaveFocusNode.unfocus();
        }
      },
    );
    try {
      storage.read(key: strings.matricula).then((val) {
        if (val != null) {
          this.matricula = val;
        }
        storage.read(key: strings.clave).then((val) {
          if (val != null) {
            this.clave = val;
          }
          if (matricula != null && clave != null && matricula.isNotEmpty && clave.isNotEmpty) {
            print('mat: $matricula - clave: $clave');
            textMatriculaController.text = matricula;
            textClaveController.text = clave;
            setState(() {
              recordarUsuario = true;
            });
            _login();
          }
        });
      });
    }on Exception catch (e, s){
      print(e);
      print(s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldkey, body: _getBody());
  }

  Widget _getBody() {
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
    var checkboxMantenerSesion = CheckboxListTile(
        title: Text('Mantener sesión'),
        activeColor: secondaryColor,
        //title: Text('Mantener sesión'),
        //checkColor: Colors.white,
        value: recordarUsuario,
        onChanged: (b) {
          _setRecordarUsuario(b);
          setState(() {
            recordarUsuario = b;
          });
        });
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: Container(
              height: MediaQuery.of(context).size.height * .45,
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
                height: MediaQuery.of(context).size.height * .55,
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ListTile(title: textMatricula),
                        ListTile(title: textClave),
                        ListTile(title: checkboxMantenerSesion),
                        ListTile(title: btnEnviar),
                      ],
                    )))
          ],
        ),
      ),
    );
  }

  void _setMatricula(String matricula) {
    this.matricula = matricula;
  }

  void _setClave(String clave) {
    this.clave = clave;
  }

  void _setRecordarUsuario(bool recordarUsuario) {
    this.recordarUsuario = recordarUsuario;
  }

  Future<void> _login() async {
    var s = Status.fromDynamic({"acceso": false});
    try{
    s = await Singleton.get().webServiceAlumnos.login(matricula, clave);
    } on DioError catch(e){
      print(e);
    }
    if(s==null){
      _showSnackBar('Internet no disponible, intente más tarde');
      return;
    }
    if (s.acceso) {
      if (recordarUsuario) {
        await storage.write(key: strings.matricula, value: matricula);
        await storage.write(key: strings.clave, value: clave);
      }
      else{
        await storage.write(key: strings.matricula, value: null);
        await storage.write(key: strings.clave, value: null);
      }
      _showSnackBar('Logeado exitosamente');
    } else {
      _showSnackBar('Matrícula o contraseña incorrectos');
    }
    print(s);
  }

  void _showSnackBar(String message) =>
      _scaffoldkey.currentState.showSnackBar(SnackBar(
        content: Text(message),
      ));
}
