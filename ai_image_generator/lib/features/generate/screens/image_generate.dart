import 'dart:typed_data';
import 'package:ai_image_generator/features/generate/data/repo/services_repo.dart';
import 'package:ai_image_generator/features/generate/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_bloc.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_state.dart';

class ImageGenerateScreen extends StatefulWidget {
  const ImageGenerateScreen({
    super.key,
  });

  @override
  State<ImageGenerateScreen> createState() => _ImageGenerateScreenState();
}

class _ImageGenerateScreenState extends State<ImageGenerateScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Generate Image',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(bottom: 30,top: 10),
        child: BlocListener<ImageGeneratingBloc, PromptState>(
          listener: (context, state) {
            if (state is SaveSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Image successfully saved to the gallery')));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                width: double.infinity,
                child: BlocConsumer<ImageGeneratingBloc, PromptState>(
                  listener: (context, state) {
                    if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessege)),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    if (state is ImageGeneratingSuccessState) {
                      return Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        height: 300,
                        width: double.infinity,
                        child: Screenshot(
                          controller: _screenshotController,
                          child: Image.memory(
                            state.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.viewInsetsOf(context).bottom,
                    horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SaveAndShareButtonWidget(
                            width: 150,
                            height: 55,
                            title: 'Save',
                            onTap: () {
                              GenerateServicesRepo().requestPermission();
                              GenerateServicesRepo().saveImageToGallery(
                                context
                                    .mounted, // Ensure context is still available
                                context,
                                _screenshotController, // Pass ScreenshotController instance
                              );
                            }),
                        BlocListener<ImageGeneratingBloc, PromptState>(
                          listener: (context, state) {
                            if (state is ImageGeneratingSuccessState) {}
                          },
                          child: SaveAndShareButtonWidget(
                              width: 150,
                              height: 55,
                              title: 'Share',
                              onTap: () async {
                                if (context.read<ImageGeneratingBloc>().state
                                    is ImageGeneratingSuccessState) {
                                  final state = context
                                      .read<ImageGeneratingBloc>()
                                      .state as ImageGeneratingSuccessState;

                                  final Uint8List imageBytes = state.image;
                                  GenerateServicesRepo().shareImage(imageBytes);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "No image to share. Please generate an image first.")),
                                  );
                                }
                              }),
                        ),
                      ],
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
