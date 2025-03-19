// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';
import 'package:chatapp/data/message.dart';
import 'package:flutter/material.dart';

@immutable
abstract class FetchingMessageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchingMessageInitial extends FetchingMessageState {}

class FetchingMessageLoading extends FetchingMessageState {}

class FetchingMessageLoaded extends FetchingMessageState {
  final List<MessageModel> messages;
  final int unreadCount ;
  final String lastMessage ;
  FetchingMessageLoaded( {required this.lastMessage,required this.messages , required this.unreadCount});

  @override
  List<Object?> get props => [messages];
}

class FetchingMessageError extends FetchingMessageState {
  final String errorMessage;

  FetchingMessageError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
