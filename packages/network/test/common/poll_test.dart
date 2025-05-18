@Timeout(Duration(seconds: 5))
import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rutils_network/src/poll.dart';

abstract class Task {
  Future<bool> call();
}

class MockTask extends Mock implements Task {}

class MockClock extends Mock implements Clock {}

void main() {
  late Task task;

  setUp(() {
    task = MockTask();
  });

  test('polls function', () async {
    final responses = [false, false, true];
    when(() => task.call()).thenAnswer((_) async => responses.removeAt(0));

    await poll(task, stopWhen: (result) => result.data == true);

    verify(() => task.call()).called(3);
  });

  test(
    'calls callback function to decide if throws exception or keeps polling',
    () async {
      final errors = [Exception(), Exception(), ArgumentError(), Exception()];
      when(() => task.call())
          .thenAnswer((_) => Future.error(errors.removeAt(0)));

      final future = poll(
        task,
        stopWhen: (result) => result.error is ArgumentError,
      ).then(
        (_) => verify(() => task.call()).called(3),
      );

      expect(future, throwsA(isInstanceOf<ArgumentError>()));
    },
  );

  test('can stop after 3 calls', () async {
    when(() => task.call()).thenAnswer((_) async => false);

    final result = await poll<bool>(
      task,
      stopWhen: (result) => result.data == true || result.callCount == 3,
    );

    verify(() => task.call()).called(3);
    expect(result, false);
  });

  test('can add timeout in between calls', () async {
    when(() => task.call())
        .thenAnswer((_) => Future.delayed(const Duration(milliseconds: 10)));

    final future = poll<bool>(
      task,
      stopWhen: (result) => result.data == true,
      timeout: const Duration(milliseconds: 50),
    );

    expect(future, throwsA(isInstanceOf<TimeoutException>()));
  }, retry: 3);

  test('can add timeout in between calls', () async {
    when(() => task.call())
        .thenAnswer((_) => Future.delayed(const Duration(milliseconds: 10)));

    final future = poll<bool>(
      task,
      stopWhen: (result) => result.data == true,
      timeout: const Duration(milliseconds: 50),
    );

    expect(future, throwsA(isInstanceOf<TimeoutException>()));
  }, retry: 3);
}
