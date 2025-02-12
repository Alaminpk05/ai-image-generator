import 'dart:typed_data';
import 'package:flutter/material.dart';

@immutable
abstract class PromptState {}

class Initial extends PromptState {}

class LoadingState extends PromptState {}

class ImageGeneratingSuccessState extends PromptState {
  final Uint8List image;

  ImageGeneratingSuccessState({required this.image});
}

class ImageGeneratingErrorState extends PromptState {
  final String errorMessege;

  ImageGeneratingErrorState({required this.errorMessege});
}
