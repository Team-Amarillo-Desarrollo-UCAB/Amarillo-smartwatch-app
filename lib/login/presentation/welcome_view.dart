import 'package:flutter/material.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/round_button.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  void _showApiSelectionDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Seleccione la API a utilizar",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              RoundButton(
                title: "AMARILLO",
                onPressed: () {
                  _updateBaseUrl('AMARILLO');
                  Navigator.pop(context);
                },
                type: RoundButtonType.bgPrimary,
                customGradient: const LinearGradient(colors: [
                  Color(0xffFC6011),
                  Color.fromARGB(255, 252, 201, 17),
                ]),
              ),
              const SizedBox(height: 10),
              RoundButton(
                title: "ORANGE",
                onPressed: () {
                  _updateBaseUrl('ORANGE');
                  Navigator.pop(context);
                },
                type: RoundButtonType.bgPrimary,
                customGradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 255, 142, 55),
                  Color.fromARGB(255, 255, 10, 10),
                ]),
              ),
              const SizedBox(height: 10),
              RoundButton(
                title: "VERDE",
                onPressed: () {
                  _updateBaseUrl('VERDE');
                  Navigator.pop(context);
                },
                type: RoundButtonType.bgPrimary,
                customGradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 5, 150, 53),
                  Color.fromARGB(255, 59, 250, 123),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateBaseUrl(String selected) {
    setState(() {
      switch (selected) {
        case 'AMARILLO':
          BaseUrl().BASE_URL = BaseUrl().AMARILLO;
          break;
        case 'ORANGE':
          BaseUrl().BASE_URL = BaseUrl().ORANGE;
          break;
        case 'VERDE':
          BaseUrl().BASE_URL = BaseUrl().VERDE;
          break;
      }
    });
    print("Base URL seleccionada: ${BaseUrl().BASE_URL}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage("assets/img/login.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/img/GoDely-vertical.png",
                  width: 80,
                  height: 80,
                  fit: BoxFit.contain,
                ),
                const Text(
                  "¡Bienvenido a GoDely!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Encuentra los mejores productos y vive la experiencia del delivery más rápido.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    color: TColor.secondaryText,
                  ),
                ),
                const SizedBox(height: 10),
                RoundButton(
                  title: "Iniciar Sesión",
                  onPressed: () {
                    // Lógica para iniciar sesión
                  },
                ),
                const SizedBox(height: 8),

                // const SizedBox(height: 8),
                // IconButton(
                //   icon: const Icon(Icons.settings),
                //   color: TColor.primary,
                //   onPressed: _showApiSelectionDialog,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
