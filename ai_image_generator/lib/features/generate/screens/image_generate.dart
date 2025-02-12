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
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Allows layout to adjust when the keyboard is shown
      appBar: AppBar(
        title: Text('Generate Image'),
      ),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
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
                    return SizedBox(
                      height: 400,
                      width: double.infinity,
                      child: Image.memory(
                        state.image,
                        fit: BoxFit.cover,
                      ),
                    );
                  }
                  return Container(
                    height: 400,
                    width: double.infinity,
                    color: Colors.deepPurple,
                  );
                },
              ),
              SizedBox(
                height: 50,
              ),
              // No need for Expanded widget here
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextFormField(
                      controller: _textEditingController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter your image description...',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        fixedSize: Size(350, 55),
                      ),
                      onPressed: () {
                        context.read<ImageGeneratingBloc>().add(
                          ImageGeneratingEvent(
                            prompt: _textEditingController.text,
                          ),
                        );
                      },
                      child: Text(
                        'Generate',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.white, fontSize: 19),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
