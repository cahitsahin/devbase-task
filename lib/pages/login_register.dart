import 'package:devbase/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _name;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text("Login Register Page"),
            bottom: TabBar(tabs: [
              Tab(
                text: "Login",
              ),
              Tab(
                text: "Register",
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              loginForm(userRepo),
              registerForm(userRepo),
            ],
          )),
    );
  }

  Form loginForm(UserRepository userRepo) {
    return Form(
      key: _loginFormKey,
      child: ListView(
        children: [
          _showEmailInput(),
          _showPasswordInput(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: MaterialButton(
              color: Colors.blue,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              child: new Text('LOGIN',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              onPressed: () => validateAndSubmit(userRepo, true),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Form registerForm(UserRepository userRepo) {
    return Form(
      key: _registerFormKey,
      child: ListView(
        children: [
          _showNameInput(),
          _showEmailInput(),
          _showPasswordInput(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36.0),
            child: MaterialButton(
              color: Colors.blue,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              child: new Text('REGISTER',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              onPressed: () => validateAndSubmit(userRepo, false),
            ),
          ),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: "Name",
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            prefixIcon: new Icon(
              Icons.person,
            )),
        validator: (value) => value.isEmpty ? 'Name can\'t be empty' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: "Email",
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            prefixIcon: new Icon(
              Icons.mail,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            labelText: 'Password',
            border: new OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            prefixIcon: new Icon(
              Icons.lock,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  void validateAndSubmit(UserRepository userRepo, bool isLoginForm) async {
    if (isLoginForm) {
      if (_loginFormKey.currentState.validate()) {
        _loginFormKey.currentState.save();
        setState(() {
          _isLoading = true;
        });
        String msg = await userRepo.signIn(_email, _password);
        setState(() {
          _isLoading = false;
        });
        showInSnackBar(msg);
      }
    } else {
      if (_registerFormKey.currentState.validate()) {
        _registerFormKey.currentState.save();
        setState(() {
          _isLoading = true;
        });
        String msg = await userRepo.signUp(_email, _password);
        setState(() {
          _isLoading = false;
        });
        showInSnackBar(msg);
      }
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }
}
