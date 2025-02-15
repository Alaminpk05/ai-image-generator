import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_bloc.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_event.dart';
import 'package:ai_image_generator/features/generate/screens/image_generate.dart';
import 'package:ai_image_generator/features/generate/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  void dispose() {
    _textEditingController.dispose();
    
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Prompt',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Enter your imagination',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 15),
              Container(
                alignment: Alignment.topLeft,
                width: double.infinity,
                height: 100,
                child: TextFormField(
                  expands: true,
                  focusNode: focusNode,
                  controller: _textEditingController,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Create the most beautiful robot...',
                  ),
                ),
              ),
              SizedBox(height: 100),
              SaveAndShareButtonWidget(
                title: 'Generate',
                onTap: () {
                  context.read<ImageGeneratingBloc>().add(
                        ImageGeneratingEvent(
                          prompt: _textEditingController.text,
                        ),
                      );

                  if (_textEditingController.text.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageGenerateScreen()));
                            _textEditingController.clear();
                    FocusScope.of(context).unfocus();
                  }
                },
                height: 55,
                width: MediaQuery.of(context).size.width,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
