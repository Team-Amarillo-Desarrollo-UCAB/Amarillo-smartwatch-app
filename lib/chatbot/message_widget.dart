// import 'package:desarrollo_frontend/common/presentation/color_extension.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';

// class MessageWidget extends StatelessWidget {
//   const MessageWidget({
//     super.key,
//     required this.text,
//     required this.isFromUser,
//     });

//   final String text;
//   final bool isFromUser;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Flexible(
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 15,
//               horizontal: 20,
//             ),
//             margin: const EdgeInsets.only(bottom: 8),
//             constraints: const BoxConstraints(maxWidth: 520),
//             decoration: BoxDecoration(
//               color: isFromUser ? TColor.primary : TColor.secondary,
//               borderRadius: BorderRadius.circular(18),
//             ),
//             child: Column(
//               children: [
//                 MarkdownBody(data:text),
//               ],
//             )
//           ))
//       ],
//     );
//   }
// }