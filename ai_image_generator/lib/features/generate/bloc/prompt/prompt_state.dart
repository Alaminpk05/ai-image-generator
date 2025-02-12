import 'package:flutter/material.dart';

@immutable
abstract class PromptState {}

class Initial extends PromptState {}

class LoadingState extends PromptState {}

class ImageGeneratingSuccessState extends PromptState {}

class ImageGeneratingErrorState extends PromptState {
  final String errorMessege;

  ImageGeneratingErrorState({required this.errorMessege});
}
