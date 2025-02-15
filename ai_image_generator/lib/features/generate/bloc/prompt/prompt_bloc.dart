import 'dart:typed_data';

import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_event.dart';
import 'package:ai_image_generator/features/generate/bloc/prompt/prompt_state.dart';
import 'package:ai_image_generator/features/generate/data/repo/contract_repo.dart';
import 'package:ai_image_generator/features/generate/data/repo/services_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ImageGeneratingBloc extends Bloc<PromptEvent, PromptState> {
  GenerateContractRepo generateContractRepo = GenerateServicesRepo();
  ImageGeneratingBloc() : super(Initial()) {
    on<ImageGeneratingEvent>(_onImageGeneratingEvent);
    on<ImageSaveEvent>(_onImageSaveEvent);
  }

  Future<void> _onImageGeneratingEvent(
      ImageGeneratingEvent event, Emitter<PromptState> emit) async {
    final hasConnection = await InternetConnection().hasInternetAccess;
    if (!hasConnection) {
      emit(ErrorState(
          errorMessege:
              "No internet connection. Please check your network and try again."));
      debugPrint('EMITTED NO INTERNET ERROR STATE');
      return;
    }
    emit(LoadingState());
    try {
      final Uint8List? image =
          await generateContractRepo.generateImage(event.prompt);
      debugPrint('STATE IMAGE IS PRINTED $image');
      if (image != null) {
        emit(ImageGeneratingSuccessState(image: image));
        debugPrint('EMITTED IMAGE GENERATING SUCCESS STATE');
        return;
      } else {
        emit(ErrorState(errorMessege: 'Generating file is empty'));
        debugPrint('EMITTED IF ELSE ERROR STATE');
      }
    } catch (e) {
      emit(ErrorState(errorMessege: e.toString()));
      debugPrint('Something went wrong');
      debugPrint('EMITTED CATCH ERROR STATE');
    }
  }

  Future<void> _onImageSaveEvent(
      ImageSaveEvent event, Emitter<PromptState> emit) async {
    emit(LoadingState());
    try {
      // await generateContractRepo.requestPermission();
      // await generateContractRepo.saveImageToGallery(); 
      
    } catch (e) {
      emit(ErrorState(errorMessege: e.toString()));
    }
  }
}
