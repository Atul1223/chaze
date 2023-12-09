// import 'dart:ui';

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyScreen(),
//     );
//   }
// }

// class MyScreen extends StatefulWidget {
//   @override
//   _MyScreenState createState() => _MyScreenState();
// }

// class _MyScreenState extends State<MyScreen> {
//   bool isPopupVisible = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Blurred Popup Example'),
//       ),
//       body: Stack(
//         children: [
//           // Main content
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   isPopupVisible = true;
//                 });
//               },
//               child: Text('Show Popup'),
//             ),
//           ),

//           // Blurred background
//           if (isPopupVisible)
//             BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//               ),
//             ),

//           // Popup widget
//           if (isPopupVisible)
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 height: MediaQuery.of(context).size.height / 4,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Popup Heading',
//                         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       TextFieldWithIcon(label: 'Field 1', icon: Icons.person),
//                       TextFieldWithIcon(label: 'Field 2', icon: Icons.lock),
//                       SizedBox(height: 16),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             isPopupVisible = false;
//                           });
//                         },
//                         child: Text('Close Popup'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }

// // class TextFieldWithIcon extends StatelessWidget {
// //   final String label;
// //   final IconData icon;

// //   const TextFieldWithIcon({
// //     required this.label,
// //     required this.icon,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         Row(
// //           children: [
// //             Icon(icon),
// //             SizedBox(width: 8),
// //             Text(
// //               label,
// //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //             ),
// //           ],
// //         ),
// //         TextField(
// //           decoration: InputDecoration(
// //             hintText: 'Enter value',
// //           ),
// //         ),
// //         SizedBox(height: 12),
// //       ],
// //     );
// //   }
// // }
