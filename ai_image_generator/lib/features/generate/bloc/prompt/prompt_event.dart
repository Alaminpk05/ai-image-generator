import 'package:flutter/material.dart';

@immutable
class PromptEvent {}

class ImageGeneratingEvent extends PromptEvent {
  final String prompt;

  ImageGeneratingEvent({required this.prompt});
}

