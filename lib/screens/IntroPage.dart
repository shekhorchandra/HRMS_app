// import 'package:flutter/material.dart';
//
//
// import 'login.dart';
//
// class IntroPage extends StatelessWidget {
//   const IntroPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final textScale = MediaQuery.textScaleFactorOf(context);
//     final size = MediaQuery.of(context).size;
//     final height = size.height;
//     final width = size.width;
//
//     return Scaffold(
//       body: Container(
//         width: width,
//         height: height,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/introback.jpg'), // background intropage image
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               Expanded(
//                 child: Center(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: width * 0.08),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         SizedBox(height: height * 0.12), // <--- Move section slightly down
//
//                         // Logo and Welcome text
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withOpacity(0.5),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: Column(
//                             children: [
//                               Image.asset(
//                                 'assets/images/onebiterp_logo_main.png',
//                                 height: height * 0.09,
//                                 fit: BoxFit.contain,
//                               ),
//                               //const SizedBox(height: 10),
//                               Text(
//                                 "Human Resource Management System"
//                                 "\nWelcome to ONE BIT ERP",
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18 * textScale,
//                                 ),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ],
//                           ),
//                         ),
//
//                         const SizedBox(height: 24),
//
//                         // Slogan Section
//                         Container(
//                           width: double.infinity,
//                           padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
//                           decoration: BoxDecoration(
//                             //color: Colors.white.withOpacity(0.85),
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           child: FittedBox(
//                             // child: Text(
//                             //   "MAKE INVESTING\nA HABIT",
//                             //   style: TextStyle(
//                             //     fontWeight: FontWeight.bold,
//                             //     color: Colors.white,
//                             //     fontSize: 32 * textScale,
//                             //   ),
//                             //   textAlign: TextAlign.center,
//                             // ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // Bottom Buttons
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 25),
//                 child: Column(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const MyLogin()),
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.blue,
//                         ),
//                         child: const Icon(
//                           Icons.arrow_forward,
//                           color: Colors.white,
//                           size: 28,
//                         ),
//                       ),
//                     ),
//
//                     const SizedBox(height: 10),
//                     // TextButton(
//                     //   onPressed: () {
//                     //     Navigator.push(
//                     //       context,
//                     //       MaterialPageRoute(builder: (context) => const MyRegister()),
//                     //     );
//                     //   },
//                     //   child: Text(
//                     //     'Create an account',
//                     //     style: TextStyle(
//                     //       fontSize: 15 * textScale,
//                     //       color: Colors.white,
//                     //     ),
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
