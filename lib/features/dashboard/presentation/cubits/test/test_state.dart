part of 'test_cubit.dart';

@immutable
sealed class TestState {}

final class TestInitial extends TestState {}

final class TestError extends TestState {}

final class TestLoaded extends TestState {
  final Test test;

  TestLoaded(this.test);
}

final class TestStart extends TestLoaded {
  TestStart(super.test);
}

final class TestRunning extends TestLoaded {
  TestRunning(super.test);
}

final class TestSubmitted extends TestLoaded {
  final TestAttempt attempt;
  TestSubmitted(super.test, this.attempt);
}
