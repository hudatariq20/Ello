import 'package:flutter/material.dart';

@immutable
class MessageModel {
  final String id;
  final String message;
  final bool isUser; //idenfiy ther user

  const MessageModel(
      {required this.id, required this.message, required this.isUser});

  MessageModel copyWith({
    String? id,
    String? message,
    bool? isUser,
  }) {
    return MessageModel(
      id: id ?? this.id,
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
    );
  }
}
