import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resume_builder/presantation/providers/resume_provider.dart';
import 'package:resume_builder/presantation/screens/home_screen.dart';
import 'core/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => ResumeProvider() ,child:MaterialApp(
      title: 'Resume Builder',
      theme: AppTheme.theme,
      home:  const HomeScreen(),
    )
    );
  }
}

