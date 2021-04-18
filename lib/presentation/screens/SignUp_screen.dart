import 'package:easacc_task/common_widgets/custom_raised_button.dart';
import 'package:easacc_task/common_widgets/gradient_button.dart';
import 'package:easacc_task/common_widgets/platform_exception_alert_dialog.dart';
import 'package:easacc_task/data/models/signUpModel.dart';
import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:easacc_task/logic/signUpBloc.dart';
import 'package:easacc_task/presentation/screens/HomePage.dart';
import 'package:easacc_task/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  final EmailSignUpBloc bloc;

  const SignUp({Key key, this.bloc}) : super(key: key);
  static Widget create(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return Provider<EmailSignUpBloc>(
      create: (context) => EmailSignUpBloc(auth: auth),
      child: Consumer<EmailSignUpBloc>(
        builder: (context, bloc, _) => SignUp(bloc: bloc),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _State createState() => _State();
}

class _State extends State<SignUp> {
  FocusNode _emailFn = FocusNode();
  FocusNode _pass = FocusNode();

  FocusNode _confirmPass = FocusNode();
  final _passwordController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'name': '',
  };
  final GlobalKey<FormState> _formKey = GlobalKey();

  Future<void> _submit(EmailSignUpBloc bloc) async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    try {
      await bloc.submit();
      Navigator.of(context).popAndPushNamed(Home.routeName);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return StreamBuilder<EmailSignInModel>(
    //     stream: bloc.modelStream,
    //     initialData: EmailSignInModel(),
    //     builder: (ctx, snapshot) {
    //       final EmailSignInModel model = snapshot.data;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff82E6B2),
                  Color(0xff62E1FB),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0, 1],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .95,
                      width: MediaQuery.of(context).size.width * .95,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        elevation: 8.0,
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 16, left: 12, right: 14),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        // child: Image(
                                        //     image: AssetImage(
                                        //         '')),

                                        backgroundColor: Color(0xff82E6B2),
                                        radius: 80,
                                      ),
                                      TextButton.icon(
                                          //   color: Color(0xff82E6B2),
                                          label: Text(
                                            'select your profile pic',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff82E6B2)),
                                          ),
                                          icon: Icon(
                                            Icons.image_outlined,
                                            color: Color(0xff82E6B2),
                                          ),
                                          onPressed: () {})
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff82E6B2)),
                                        labelText: 'Name',
                                        prefixIcon: Icon(
                                          Icons.person_outlined,
                                          color: Color(0xff82E6B2),
                                        )),
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(color: Color(0xff82E6B2)),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please entet your anme!';
                                      }
                                    },
                                    onSaved: (value) {
                                      print(widget.bloc.modelStream.toString());
                                      //  model.copyWith(displayName: value);
                                      widget.bloc.updateName(value);
                                      //  _authData['name'] = value;
                                    },
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_emailFn);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  child: TextFormField(
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_pass);
                                    },
                                    focusNode: _emailFn,
                                    decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff82E6B2)),
                                        labelText: 'E-Mail',
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Color(0xff82E6B2),
                                        )),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    style: TextStyle(color: Color(0xff82E6B2)),
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          !value.contains('@')) {
                                        return 'Invalid email!';
                                      }
                                    },
                                    onSaved: (value) {
                                      widget.bloc.updateEmail(value);
                                      _authData['email'] = value;
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
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff82E6B2)),
                                        labelText: 'Password',
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Color(0xff82E6B2),
                                        )),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    controller: _passwordController,
                                    style: TextStyle(color: Color(0xff82E6B2)),
                                    validator: (value) {
                                      if (value.isEmpty || value.length < 4) {
                                        return 'Invalid Passord!';
                                      }
                                    },
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_confirmPass);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 6, left: 12, right: 12, bottom: 12),
                                  child: TextFormField(
                                    focusNode: _confirmPass,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        labelStyle: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff82E6B2)),
                                        labelText: 'Confirm Password',
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                          color: Color(0xff82E6B2),
                                        )),
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.done,
                                    style: TextStyle(color: Color(0xff82E6B2)),
                                    validator: (value) {
                                      if (_passwordController.text != value) {
                                        return 'Passords is not the same!';
                                      }
                                    },
                                    onSaved: (value) {
                                      widget.bloc.updatePassword(value);
                                      _authData['password'] = value;
                                    },
                                  ),
                                ),
                                StreamBuilder<SignUpModel>(
                                    initialData: SignUpModel(),
                                    stream: widget.bloc.model2Stream,
                                    builder: (context, snapshot) {
                                      print('rebuild.......' +
                                          snapshot.data.isLoading.toString());
                                      bool isLoading = snapshot.data.isLoading;
                                      return isLoading
                                          ? CircularProgressIndicator()
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 16),
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
                                                  onPressed: () {
                                                    _submit(widget.bloc);
                                                  },
                                                  child: Text('Sign Up',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20)),
                                                ),
                                              ),
                                            );
                                    }),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              Login.routeName);
                                    },
                                    child: Text(
                                      'Log In',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Color(0xff82E6B2),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .39,
                                        child: Divider(
                                          color: Colors.black54,
                                          thickness: 1,
                                        ),
                                      ),
                                      Text(
                                        ' or ',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: Colors.black54,
                                          thickness: 1,
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: CustomRaisedButton(
                                    height: 50,
                                    borderRadius: 30,
                                    onPressed: () async {
                                      await widget.bloc
                                          .signInWithGoogle(context);
                                      Navigator.of(context)
                                          .pushReplacementNamed(Home.routeName);
                                    },
                                    color: Colors.black12,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: Image.asset(
                                                'assets/images/google.png')),
                                        Text('   Continue with google',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20))
                                      ],
                                    ),
                                    //   );
                                    // }
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: CustomRaisedButton(
                                    height: 50,
                                    borderRadius: 30,
                                    onPressed: () {
                                      widget.bloc.signInWithGoogle(context);
                                    },
                                    color: Colors.black12,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            height: 35,
                                            width: 35,
                                            child: Image.asset(
                                                'assets/images/facebook.png')),
                                        Text('   Continue with facebook',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20))
                                      ],
                                    ),
                                  ),
                                ),
                                //   FlatButton(onPressed: (){} , label: Text('Continue with google'))
                              ],
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ]),
      ),
    );

    //  });
  }
}
