import 'package:flutter/material.dart';
import 'package:locapp/screens/trip_form_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/signup.dart';
import '../services/auth_services.dart';
import '../themes/theme.dart';
import '../widgets/custom_scaffold.dart';
import 'package:icons_plus/icons_plus.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});


  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formSignInKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool rememberPassword = true;
  late SharedPreferences prefs;

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void signIn() async {
    if(_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      var regBody = {
        "email": _emailController.text,
        "password" : _passwordController.text,
      };
      try {
        final responseData = await AuthServices.login('/auth/signin', regBody);
        print(responseData);

        if(responseData.containsKey('token')) {
          var currentToken  = responseData['token'];
          prefs.setString('token', currentToken);

          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  TripFormScreen(token: currentToken)),
            );
          }
        }else {
          print('Token not found in response');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
              child: SizedBox(
                height: 10,
              )
          ),
          Expanded(
            flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  )
                ),
                  child: SingleChildScrollView(
                    child: Form(
                        key: _formSignInKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            /*const SizedBox(
                          height: 25.0,
                        ),*/
                            Text(
                              'Bienvenue',
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.w900,
                                  color: lightColorScheme.primary
                              ),
                            ),
                            // email
                            const SizedBox(
                              height: 40.0,
                            ),
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Email';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('Email'),
                                hintText: 'Email',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            // password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              obscuringCharacter: '*',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                label: const Text('Mot de passe'),
                                hintText: 'Mot de passe',
                                hintStyle: const TextStyle(
                                  color: Colors.black26,
                                ),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    color: Colors.black12, // Default border color
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                      Checkbox(
                                        value: rememberPassword,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            rememberPassword = value!;
                                          });
                                        },
                                        activeColor: lightColorScheme.primary,
                                      ),
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(
                                          color: Colors.black45,
                                        ),
                                      ),
                                  ],
                                ),
                                GestureDetector(
                                  child: Text(
                                    'Mot de passe oublié?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formSignInKey.currentState!.validate() &&
                                      rememberPassword) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Traitement des données'),
                                      ),
                                    );
                                    // Navigation vers la page "trip_form"
                                    signIn();
                                  } else if (!rememberPassword) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                          'Veuillez accepter le traitement des données personnelles')),
                                    );
                                  }
                                },
                                child: const Text('Suivant'),
                              ),
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.7,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'Inscrivez-vous avec',
                                    style: TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.7,
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Logo(Logos.facebook_f),
                                Logo(Logos.twitter),
                                Logo(Logos.google),
                                Logo(Logos.apple),
                              ],
                            ),
                            const SizedBox(
                              height: 25.0,
                            ),
                            // don't have an account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Pas de compte ?',
                                  style: TextStyle(
                                    color: Colors.black45,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (e) => const SignUp(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Inscrivez-vous',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: lightColorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                    ),
                  ),
              ),
          ),
        ],
      ),
    );
  }
}
