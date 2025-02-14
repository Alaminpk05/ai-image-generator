import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_bloc.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_event.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_state.dart';

class ImageGenerateScreen extends StatefulWidget {
  const ImageGenerateScreen({super.key});

  @override
  State<ImageGenerateScreen> createState() => _ImageGenerateScreenState();
}

class _ImageGenerateScreenState extends State<ImageGenerateScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  /// Request necessary permissions based on Android/iOS versions
  Future<void> requestPermission() async {
    if (await Permission.storage.request().isGranted ||
        await Permission.photos.request().isGranted) {
      debugPrint("Storage permission granted");
    } else {
      debugPrint("Storage permission denied");
    }
  }

  /// Capture and save the image to the gallery
  Future<void> saveImageToGallery() async {
    final Uint8List? image = await _screenshotController.capture();
    if (image == null) {
      debugPrint("Error: Screenshot capture failed.");
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to capture image.")),
      );
      }
      
      return;
    }

    var status = await Permission.storage.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      debugPrint("Error: Permission denied.");
      if(mounted){
ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Permission denied. Cannot save image.")),
      );
      }
      
      return;
    }

    // Save image
    final result = await ImageGallerySaverPlus.saveImage(
      image,
      name: "generated_image_${DateTime.now().millisecondsSinceEpoch}",
    );

    if (result['isSuccess'] == true) {
      debugPrint("Image saved successfully.");
      if(mounted){
 ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Image saved successfully!")),
      );
      }
     
    } else {
      debugPrint("Error: Failed to save image.");
      if(mounted){
         ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save image.")),
      );
      }
     
    }
  }

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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: double.infinity,
                  child: BlocConsumer<ImageGeneratingBloc, PromptState>(
                    listener: (context, state) {
                      if (state is ImageGeneratingErrorState) {
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
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.viewInsetsOf(context).bottom,
                      horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Enter your imagination',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 9),
                      TextFormField(
                        controller: _textEditingController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          hintText: 'Create the most beautiful robot...',
                        ),
                      ),
                      SizedBox(height: 20),
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          fixedSize: Size(350, 55),
                        ),
                        onPressed: saveImageToGallery,
                        child: Text(
                          'Save',
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
      ),
    );
  }
}
