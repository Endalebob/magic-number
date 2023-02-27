import 'package:clean_arch/injection_container.dart'
    as di;
import 'package:flutter/material.dart';

import 'features/presentation/pages/number_trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green.shade800,
          secondary: Colors.green.shade600,
        ),
      ),
      home: const NumberTriviaPage(),
    );
  }
}
