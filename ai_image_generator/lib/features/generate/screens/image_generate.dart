import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_bloc.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_event.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageGenerateScreen extends StatefulWidget {
  const ImageGenerateScreen({super.key});

  @override
  State<ImageGenerateScreen> createState() => _ImageGenerateScreenState();
}

class _ImageGenerateScreenState extends State<ImageGenerateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Image'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        child: Column(
          children: [
            BlocConsumer<ImageGeneratingBloc, PromptState>(
              listener: (context, state) {
                if (state is ImageGeneratingErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessege)));
                }
              },
              builder: (context, state) {
                if (state is LoadingState) {
                  debugPrint('IMAGE GENERATING SUCCESS STATE');
                  return Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                if (state is ImageGeneratingSuccessState) {
                  debugPrint('IMAGE GENERATING SUCCESS STATE');
                  return Container(
                      height: 400,
                      width: double.infinity,
                      child: Image.memory(state.image));
                }
                return Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.deepPurple,

                  // child: Image.file(state.image)
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              alignment: Alignment.center,
              fixedSize: Size(300, 55),
            ),
            onPressed: () {
              context.read<ImageGeneratingBloc>().add(ImageGeneratingEvent(
                  prompt: 'A futuristic cityscape at night with neon lights'));
            },
            child: Text(
              'Generate',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontSize: 19),
            )),
      ),
    );
  }
}
