// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class InitHomeEvent extends HomeEvent {}

class HomeYoloResultEvent extends HomeEvent {
  CameraImage image;
  HomeYoloResultEvent({
    required this.image,
  });

  @override
  List<Object?> get props => [image];
}
