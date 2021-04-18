import 'package:easacc_task/common_widgets/gradient_button.dart';
import 'package:easacc_task/common_widgets/platform_exception_alert_dialog.dart';
import 'package:easacc_task/data/models/email_sign_in_model.dart';
import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:easacc_task/logic/email_sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LoginWithEmailAndPass extends StatefulWidget {
  LoginWithEmailAndPass({@required this.bloc});
  final EmailSignInBloc bloc;
  static Widget create(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => LoginWithEmailAndPass(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _LoginWithEmailAndPassState createState() => _LoginWithEmailAndPassState();
}

class _LoginWithEmailAndPassState extends State<LoginWithEmailAndPass> {
  FocusNode _emailFn = FocusNode();

  FocusNode _pass = FocusNode();

  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFn.dispose();
    _pass.dispose();
    super.dispose();
  }

  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    try {
      await widget.bloc.submit(true);
      // Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Log in failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (ctx, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: TextFormField(
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_pass);
                    },
                    controller: _emailController,
                    focusNode: _emailFn,
                    decoration: InputDecoration(
                        labelStyle:
                            TextStyle(fontSize: 12, color: Color(0xff82E6B2)),
                        labelText: 'E-Mail',
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Color(0xff82E6B2),
                        )),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(color: Color(0xff82E6B2)),
                    validator: (value) {
                      if (value.isEmpty || !value.contains('@')) {
                        return 'Invalid email!';
                      }
                    },
                    onSaved: (value) {
                      widget.bloc.updateEmail(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 6, left: 12, right: 12, bottom: 12),
                  child: TextFormField(
                    focusNode: _pass,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelStyle:
                            TextStyle(fontSize: 12, color: Color(0xff82E6B2)),
                        labelText: 'Password',
                        prefixIcon: Icon(
                          Icons.lock_outline,
                          color: Color(0xff82E6B2),
                        )),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    controller: _passwordController,
                    style: TextStyle(color: Color(0xff82E6B2)),
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return 'Invalid Passord!';
                      }
                    },
                    onSaved: (value) {
                      widget.bloc.updatePassword(value);
                    },
                  ),
                ),

                model.isLoading
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: RaisedGradientButton(
                            height: 33,
                            radius: 40,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff82E6B2),
                                Color(0xff62E1FB),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: [0, 1],
                            ),
                            onPressed: _submit,
                            child: Text('Log In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                        ),
                      ),

                //   FlatButton(onPressed: (){} , label: Text('Continue with google'))
              ],
            ),
          );
        });
  }
}
