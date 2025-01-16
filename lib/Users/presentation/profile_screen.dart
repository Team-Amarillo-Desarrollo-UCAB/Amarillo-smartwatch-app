// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../common/presentation/color_extension.dart';
// import '../../common/presentation/logout_dialog.dart';
// import '../domain/user_profile.dart';

// class UserProfileScreen extends StatelessWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final userProfile = Provider.of<UserProfile>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Perfil'), 
//         centerTitle: true,
//         automaticallyImplyLeading: false, 
//       ), 
//       body: Column(
//         children: [
//           const SizedBox(height: 20),
//           Center(
//             child: Stack(
//               children: [
//                 CircleAvatar(
//                   radius: 80,
//                   backgroundImage: NetworkImage(userProfile.image),
//                 ), 
//                 Positioned(
//                   bottom: 0,
//                   right: 0,
//                   child: GestureDetector(
//                     onTap: () {
//                     },
//                     child: CircleAvatar(
//                       radius: 20,
//                       backgroundColor: TColor.secondary,
//                       child: const Icon(Icons.edit, color: Colors.white),
//                     ), 
//                   ), 
//                 ), 
//               ], // Children del Stack
//             ), 
//           ), 
//           const SizedBox(height: 10), // Espaciado
//           Text(
//             userProfile.name,
//             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ), 
//            Text(
//             userProfile.email,
//             style: TextStyle(color: Colors.grey),
//           ), 
//           const SizedBox(height: 30), // Espaciado
//           Column(
//             children: [
//               Divider(
//               thickness: 1,
//               color: TColor.secondary.withOpacity(0.5),
//             ),
//             ], // Children de la columna
//           ), 
//           Column(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.notifications, color: TColor.primary),
//                 title: const Text('Notificaciones'),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 onTap: () { 
//                   /*Navigator.push(context, MaterialPageRoute(
//                                        builder: (context) => NotificationsView()));*/
//                 }, // onTap
//               ), 
//               Divider(
//               thickness: 1,
//               color: TColor.secondary.withOpacity(0.5),
//             ),
//             ], // Children de la columna
//           ), 
//           Column(
//             children: [
//               ListTile(
//                 leading: Icon(Icons.settings, color: TColor.primary),
//                 title: const Text('Configuración'),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                 onTap: () { 
//                 }, // onTap
//               ), 
//               Divider(
//               thickness: 1,
//               color: TColor.secondary.withOpacity(0.5),
//             ),
//             ], 
//           ), 
//                     ListTile(
//             leading: Icon(Icons.bar_chart, color: TColor.primary),
//             title: const Text('Estadísticas'),
//             trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const StatisticsScreen()),
//               );
//               },
//             ),
//              Divider(
//               thickness: 1,
//               color: TColor.secondary.withOpacity(0.5),
//             ),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
//             onTap: () {
//               showLogoutConfirmationDialog(context);
//             }, // onTap
//           ), 

//         ], // Children del Column principal
//       ),
//     ); 
//   } // build
// } // UserProfileScreen
