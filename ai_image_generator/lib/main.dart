import 'package:ai_image_generator/core/config/theme/theme.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_bloc.dart';
import 'package:ai_image_generator/features/generate/screens/image_generate.dart';
import 'package:ai_image_generator/features/generate/screens/prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ImageGeneratingBloc(),
        ),
      ],
      child: MaterialApp(
          title: 'Image Generator',
          theme: AppTheme.darkTheme,
          darkTheme: AppTheme.darkTheme,
          home: PromptScreen()),
    );
  }
}
