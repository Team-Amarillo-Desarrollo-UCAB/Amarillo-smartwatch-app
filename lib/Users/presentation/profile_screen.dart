

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common/presentation/color_extension.dart';
import '../../common/presentation/logout_dialog.dart';
import '../domain/user_profile.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProfile = Provider.of<UserProfile>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'), 
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ), 
      body: Column(
        children: [
          const SizedBox(height: 2),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(userProfile.image),
                ), 
              ], // Children del Stack
            ), 
          ), 
          const SizedBox(height: 5), // Espaciado
          Text(
            userProfile.name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ), 
           Text(
            userProfile.email,
            style: TextStyle(color: Colors.grey,
            fontSize: 12),
          ), 


             Divider(
              thickness: 1,
              color: TColor.secondary.withOpacity(0.5),
            ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red,
            fontSize: 12)),
            onTap: () {
              showLogoutConfirmationDialog(context);
            }, // onTap
          ), 

        ], // Children del Column principal
      ),
    ); 
  } // build
} // UserProfileScreen
