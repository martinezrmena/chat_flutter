// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:chat_app/widgets/boton_azul.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/labels.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';
import '../services/auth_service.dart';
import '../services/socket_service.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Logo(titulo: 'Registro'),
                  _Form(),
                  const Labels(
                    ruta: 'login',
                    titulo: '¿Ya tienes una cuenta?',
                    subTitulo: 'Ingresa ahora!',
                  ),
                  const Text(
                    'Términos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
          ),
          BotonAzul(
            text: 'Crear cuenta',
            onPressed: authService.autenticando
                ? () => {}
                : () async {
                    print(nameCtrl.text);
                    print(emailCtrl.text);
                    print(passCtrl.text);
                    final registroOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim());

                    if (registroOk == true) {
                      socketService.connect();
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(
                        context,
                        'Registro incorrecto',
                        registroOk,
                      );
                    }
                  },
          )
        ],
      ),
    );
  }
}
