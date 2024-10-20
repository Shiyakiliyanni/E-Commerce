import 'package:cart_project/models/product_model.dart';
import 'package:cart_project/screens/cart_screen.dart';
import 'package:cart_project/screens/home_page.dart';
import 'package:cart_project/screens/initial_screen.dart';
import 'package:cart_project/screens/login_screen.dart';
import 'package:cart_project/util/theme.dart';
import 'package:cart_project/viewmodel/cart_viewmodel.dart';
import 'package:cart_project/viewmodel/order_viewmodel.dart';
import 'package:cart_project/viewmodel/product_viewmodel.dart';
import 'package:cart_project/viewmodel/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter(); 
  Hive.registerAdapter(ProductAdapter());
  await Hive.openBox<Product>('cart');
  await Hive.openBox<String>('location');


  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CartViewModel(), lazy: false,),
    ChangeNotifierProvider(create: (_) => ProductViewModel()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => OrderViewModel())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      home: const InitialScreen(),
    );
  }
}
