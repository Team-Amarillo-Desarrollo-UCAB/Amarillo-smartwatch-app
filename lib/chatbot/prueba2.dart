// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:google_generative_ai/google_generative_ai.dart';
// import 'package:http/http.dart' as http;
// import 'message_widget.dart';
// import 'dart:convert';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late final GenerativeModel _model;
//   final String apiKey = 'AIzaSyB8fMhva1VukHbLzM6cWHl8Ie_XCEnP0sU';
//   late final ChatSession _chatSession;
//   final FocusNode _textFieldFocus = FocusNode();
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   bool _loading = false;
//   final String backendUrl = 'https://amarillo-backend-production.up.railway.app/product/many';
//   List<Map<String, String>> messages = [];

//   @override
//   void initState() {
//     super.initState();
//     _model = GenerativeModel(
//       model: 'gemini-pro', // El modelo de Google Generative AI
//       apiKey: apiKey,
//     );
//     _chatSession = _model.startChat();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chatbot con Gemini AI')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 controller:  _scrollController,
//                 itemCount: _chatSession.history.length,
//                 itemBuilder: (context, index) {
//                   final Content content = _chatSession.history.toList()[index];
//                   final text = content.parts.whereType<TextPart>().map<String>((e) => e.text).join('');
//                   return MessageWidget(
//                     text: text,
//                     isFromUser: content.role == 'user',
//                   );
//                 }
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: 25,
//                 horizontal: 15,
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       autofocus: true,
//                       focusNode: _textFieldFocus,
//                       decoration: textFieldDecoration(),
//                       controller: _textController,
//                       onSubmitted: _sendChatMessage,
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   InputDecoration textFieldDecoration() {
//     return InputDecoration(
//       contentPadding: const EdgeInsets.all(15),
//       hintText: 'Escribe un mensaje...',
//       border: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(
//           Radius.circular(14),
//         ),
//         borderSide: BorderSide(
//           color: Theme.of(context).colorScheme.secondary,)
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: const BorderRadius.all(
//           Radius.circular(14),
//         ),
//         borderSide: BorderSide(
//           color: Theme.of(context).colorScheme.secondary,
//         ),
//       ),
//     );
//   }

//   Future<void> _sendChatMessage(String message) async {
//     // setState(() {
//     //   messages.add({"sender": "user", "text": message});
//     // });
//     final productsResponse = await http.get(Uri.parse(backendUrl), headers: {
//       'Authorization':
//           'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjMyOTMwODJlLWQ4M2EtNDFlOC1hMDVlLTgzZDAwODRkNzMzYiIsImlhdCI6MTczNjk2MTcyOCwiZXhwIjoxNzM3MDQ4MTI4fQ.BOwr9QtDcykmgJ_sBuvb_F7TQHYXR8KUuFlSaJtiRt4',
//     });

//     if (productsResponse.statusCode != 200) {
//       _showError('No se pudo obtener una respuesta');
//     }
//     print("response:" + productsResponse.body);
//     // Decodifica la lista de productos
//     final List products = jsonDecode(productsResponse.body);
//     final prompt =
//       'El usuario dijo: "$message". Aquí hay una lista de productos:${products.map((p) => "${p['name']}").join(', ')}.Selecciona los productos que sean relevantes para la solicitud del usuario. Genera una respuesta cálida y amigable para el usuario.';
//     try{
//       final response = await _chatSession.sendMessage(
//         Content.text(prompt),
//       );
//       final text = response.text;
//       if(text == null) {
//         _showError('No se pudo obtener una respuesta');
//         return;
//       } else {
//         setState(() {
//           _loading = false;
//           _scrollDown();
//         });
//       }
//     } catch (e) {
//       _showError(e.toString());
//       setState(() {
//         _loading = false;
//       });
//     } finally {
//       _textController.clear();
//       setState(() {
//         _loading = false;
//       });
//       _textFieldFocus.requestFocus();
//     }
//   }

//   void _scrollDown() {
//     WidgetsBinding.instance.addPostFrameCallback(
//       (_) => _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 750),
//         curve: Curves.easeOutCirc,
//       ),
//     );
//   }

//   void _showError(String message) {
//     showDialog<void>(
//       context: context, 
//       builder: (context){
//         return AlertDialog(
//           title: Text('Algo salió mal'),
//           content: SingleChildScrollView(
//             child: SelectableText(message),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('Aceptar'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }