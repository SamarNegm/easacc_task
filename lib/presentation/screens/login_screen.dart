import 'package:easacc_task/common_widgets/custom_raised_button.dart';
import 'package:easacc_task/data/repo/services/auth.dart';
import 'package:easacc_task/logic/SignInBloc.dart';
import 'package:easacc_task/presentation/screens/SignUp_screen.dart';
import 'package:easacc_task/presentation/screens/loginWithemailAndPass.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  static const routeName = '/login';
  final SignInBloc bloc;

  const Login({Key key, this.bloc}) : super(key: key);
  static Widget create(BuildContext context) {
    final AuthService auth = Provider.of<AuthService>(context);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth),
      dispose: (context, value) => value.dipose(),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, _) => Login(
          bloc: bloc,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // SignInBloc bloc = Provider.of<SignInBloc>(context);
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
          SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 30, right: 8, left: 8, top: 35),
                            child: Text(
                              'Login...',
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 30, right: 30, left: 30),
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .15,
                                width: MediaQuery.of(context).size.height * .15,
                                child: Image.asset('assets/images/logo.png')),
                          ),
                        ]),
                    StreamBuilder<bool>(
                        initialData: false,
                        stream: bloc.isLoadingStram,
                        builder: (context, snapshot) {
                          return Container(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .6,
                                      width: MediaQuery.of(context).size.width *
                                          .98,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                        ),
                                        elevation: 8.0,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 30,
                                                left: 16,
                                                right: 16,
                                                bottom: 30),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  LoginWithEmailAndPass.create(
                                                      context),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pushReplacementNamed(
                                                                SignUp
                                                                    .routeName);
                                                      },
                                                      child: Text(
                                                        'Sign Up',
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          color:
                                                              Color(0xff82E6B2),
                                                        ),
                                                      )),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              .37,
                                                          child: Divider(
                                                            color:
                                                                Colors.black54,
                                                            thickness: 1,
                                                          ),
                                                        ),
                                                        Text(
                                                          ' or ',
                                                          style: TextStyle(
                                                            fontSize: 30,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Divider(
                                                            color:
                                                                Colors.black54,
                                                            thickness: 1,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16),
                                                    child: CustomRaisedButton(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                              height: 35,
                                                              width: 35,
                                                              child: Image.asset(
                                                                  'assets/images/google.png')),
                                                          Text(
                                                              '   Continue with google',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 15))
                                                        ],
                                                      ),
                                                      color: Colors.black12,
                                                      height: 50,
                                                      borderRadius: 30,
                                                      onPressed: snapshot.data
                                                          ? null
                                                          : () {
                                                              print(
                                                                  'sin in wih goo........');
                                                              bloc.signInWithGoogle(
                                                                  context);

                                                              // FirebaseFirestore.instance
                                                              //     .collection('chats')
                                                              //     .snapshots()
                                                              //     .listen((event) {
                                                              //   print(event);
                                                              // });
                                                            },
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    child: CustomRaisedButton(
                                                      height: 50,
                                                      borderRadius: 30,
                                                      onPressed: snapshot.data
                                                          ? null
                                                          : () {
                                                              print(
                                                                  'facebook log in');
                                                              bloc.signInWithFacebook(
                                                                  context);
                                                            },
                                                      color: Colors.black12,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              height: 35,
                                                              width: 35,
                                                              child: Image.asset(
                                                                  'assets/images/facebook.png'),
                                                            ),
                                                            Text(
                                                                '   Continue with facebook',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15))
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //   FlatButton(onPressed: (){} , label: Text('Continue with google'))
                                                ],
                                              ),
                                            )),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ]),
            ),
          ),
        ]),
      ),
    );
  }
}
