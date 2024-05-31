import 'package:flutter/material.dart';
import 'package:movie_app/pages/auth/login.dart';
// import 'package:movie_app/pages/feature_film_page.dart';
// import 'package:movie_app/pages/new_film_page.dart';
import 'package:movie_app/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyApp());
  }
}

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   bool _isDarkMode = false;

//   void _toggleTheme() {
//     setState(() {
//       _isDarkMode = !_isDarkMode;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Phim Mới Cập Nhật',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       darkTheme: ThemeData.dark().copyWith(
//         primaryColor: Colors.blue,
//         hintColor: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
//       home: HomePage(
//         toggleTheme: _toggleTheme,
//         isDarkMode: _isDarkMode,
//       ),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   final VoidCallback toggleTheme;
//   final bool isDarkMode;

//   HomePage({required this.toggleTheme, required this.isDarkMode});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Trang Chủ'),
//         actions: [
//           IconButton(
//             icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
//             onPressed: toggleTheme,
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => NewFilmPage(
//                       toggleTheme: toggleTheme,
//                       isDarkMode: isDarkMode,
//                     ),
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: EdgeInsets.all(16.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16.0),
//                   color: Colors.blue,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.5),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.movie,
//                         color: Colors.white,
//                         size: 30.0,
//                       ),
//                       SizedBox(width: 10.0),
//                       Text(
//                         'Xem Danh Sách Phim Mới',
//                         style: TextStyle(
//                           fontSize: 18.0,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => FeatureFilmPage(
//                 toggleTheme: toggleTheme,
//                 isDarkMode: isDarkMode,
//               ),
//             ),
//           );
//         },
//         tooltip: 'Phim Lẻ',
//         child: Icon(Icons.movie),
//       ),
//     );
//   }
// }
