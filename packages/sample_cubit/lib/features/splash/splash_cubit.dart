import 'package:flutter_bloc/flutter_bloc.dart';

class SplashState {
  final bool isLoading;
  const SplashState({this.isLoading = false});

  SplashState copyWith({
    bool? isLoading,
  }) =>
      SplashState(
        isLoading: isLoading ?? this.isLoading,
      );
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());
}
