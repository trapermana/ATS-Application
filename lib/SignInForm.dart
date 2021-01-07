import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

var bgColor = const Color(0xff10375C);
var txColor = const Color(0xffF3C623);
var logo = 'assets/Group.png';
var font = 'Asap';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class FormFields extends StatefulWidget {
  @override
  _FormFieldsState createState() => _FormFieldsState();
}

class _FormFieldsState extends State<FormFields> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 30.0),
                width: 300,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  //initialValue: 'John Doe',
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter your email';
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(244, 246, 255, 1),
                    hintText: 'Username',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: txColor, width: 3.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: txColor, width: 3.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: txColor, width: 3.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: txColor, width: 3.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                width: 300,
                child: TextFormField(
                  controller: _passwordController,
                  validator: (String value) {
                    if (value.isEmpty) return 'Please enter your password';
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  autofocus: false,
                  //initialValue: 'John Doe',
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color.fromRGBO(244, 246, 255, 1),
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(
                          color: Color.fromRGBO(212, 168, 11, 1), width: 3.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: txColor, width: 3.0),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: txColor, width: 3.0),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: txColor, width: 3.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                  width: 300,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _signIn();
                      }
                    },
                    color: Color.fromRGBO(212, 168, 11, 1),
                    textColor: Color.fromRGBO(244, 246, 255, 1),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child: Text('LOGIN', style: TextStyle(fontSize: 20.0)),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("${user.email} signed in"),
            content: Text('Click OK to Continue'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("${user.email} signed in"),
      // ));
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("User is not Registered"),
            content: Text('Click OK to Continue'),
            actions: [
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        },
      );
      // Scaffold.of(context).showSnackBar(SnackBar(
      //   content: Text("Failed to sign in with Email & Password"),
      // ));
    }
  }
}

class FrontPage extends StatefulWidget {
  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  bool selections = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: bgColor,
        body: Container(
          //color: bgColor,
          child: Center(
            child: Stack(alignment: Alignment.center, children: [
              Positioned(
                top: 200,
                bottom: 50,
                child: Container(
                  color: bgColor,
                  child: FormFields(),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                top: selections ? 200 : 70,
                width: selections ? 500 : 400,
                height: selections ? 410 : 290,

                curve: selections
                    ? Curves.easeInBack
                    : Curves.easeInOutBack, //kanan buka, kiri tutup
                child: Container(
                  height: selections ? 410 : 250,
                  color: bgColor,
                  child: InkWell(
                    onTap: _animateIt,
                    child: Logos(),
                  ),
                ),
              ),
              Positioned(
                  bottom: 70,
                  child: Text(
                    selections ? 'Tap the logo to login!' : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: font,
                      fontSize: 24,
                      color: txColor,
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  void _animateIt() {
    FocusManager.instance.primaryFocus.unfocus();
    setState(() {
      selections = !selections;
    });
  }
}

class Logos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              logo,
              width: 150,
              height: 200,
            ),
            Text(
              "ATS CONTROL AND MONITORING",
              style: TextStyle(
                  color: txColor,
                  fontSize: 30.0,
                  fontFamily: font,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "APPLICATION",
              style: TextStyle(
                  color: txColor,
                  fontSize: 30.0,
                  fontFamily: font,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
