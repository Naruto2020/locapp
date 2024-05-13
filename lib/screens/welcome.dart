import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:locapp/screens/signin.dart';
import 'package:locapp/screens/signup.dart';
import 'package:locapp/widgets/custom_scaffold.dart';
import 'package:locapp/widgets/welcome_button.dart';

import '../themes/theme.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        child: Column(
          children: [
            Flexible(
              flex: 8,
              child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 40.0,
              ),
              child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Bienvenue!\n',
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white
                          )
                        ),
                        TextSpan(
                          text: 'Application LocApp vous permet de partager votre localisation',
                          style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                            )
                        ),
                      ]
                    ),
                  )
              ),
            )),
             Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    const Expanded(
                        child: WelcomeButton(
                          buttonText: 'Signin',
                          onTap: SignIn(),
                          color: Colors.transparent,
                          textColor: Colors.white,
                        )
                    ),
                    Expanded(
                        child: WelcomeButton(
                          buttonText: 'Signup',
                          onTap: const SignUp(),
                          color: Colors.white,
                          textColor: lightColorScheme.primary,
                        )
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}