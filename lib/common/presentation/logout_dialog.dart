import 'package:flutter/material.dart';
import '../../login/presentation/welcome_view.dart';
import '../infrastructure/session_manager.dart';
import 'color_extension.dart';

final SessionManager _sessionManager = SessionManager();
void showLogoutConfirmationDialog(BuildContext context) { 
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Bordes redondeados
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Centrar los elementos
          children: [
            Icon(
              Icons.help_outline,
              size: 15,
              color: TColor.primary,
            ), // Ícono de pregunta
            const SizedBox(height: 3), // Espacio entre el ícono y el texto
            const Text(
              "Cerrar Sesión",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14, // Tamaño más visible
              ),
            ), // Título
          ],
        ),
        actionsPadding: const EdgeInsets.symmetric(vertical: 0.0001, horizontal: 20), // Ajustar la posición vertical de los botones
        actionsAlignment: MainAxisAlignment.spaceEvenly, // Centrar los botones horizontalmente
        actions: [
          // Botón "Cancelar"
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Cerrar el popup
            },
            style: TextButton.styleFrom(
              foregroundColor: TColor.primaryText, // Color del texto
              padding: const EdgeInsets.symmetric(horizontal: 10), // Tamaño del botón
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(
                fontSize: 10, // Ajustar tamaño del texto
                fontWeight: FontWeight.w500, // Ajustar el grosor del texto
              ),
            ),
          ), 
          // Botón "Sí, cerrar sesión"
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Cerrar el popup
              await _sessionManager.clearSession();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeView()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary, // Color de fondo
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Ajustar tamaño del botón
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25), // Ajustar las esquinas
              ),
            ),
            child: const Text(
              "Sí, cerrar sesión",
              style: TextStyle(
                fontSize: 10, // Ajustar tamaño del texto
                color: Colors.white,
                fontWeight: FontWeight.w600, // Ajustar el grosor del texto
              ),
            ),
          ),
        ], // Botones del AlertDialog
      );
    },
  );
}
