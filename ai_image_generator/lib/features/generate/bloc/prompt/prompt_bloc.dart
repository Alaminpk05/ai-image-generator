import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_event.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ImageGeneratingBloc extends Bloc<PromptEvent, PromptState> {
  ImageGeneratingBloc() : super(Initial()) {
    on<ImageGeneratingEvent>(_onImageGeneratingEvent);
  }

  Future<void> _onImageGeneratingEvent(ImageGeneratingEvent event,Emitter<PromptState> emit) async {
 final hasConnection = await InternetConnection().hasInternetAccess;
    if (!hasConnection) {
      
      emit(ImageGeneratingErrorState(
          errorMessege:
              "No internet connection. Please check your network and try again."));
      debugPrint('EMITTED NO INTERNET AUTH ERROR STATE');
      return;
    }
  }



}
