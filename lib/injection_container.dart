import 'package:get_it/get_it.dart';
import 'domain/repositories/board_repository.dart';
import 'domain/usecases/board_use_cases.dart';
import 'domain/usecases/task_use_cases.dart';

final GetIt getIt = GetIt.instance;

void setupInjection() {
  // Register repository as a lazy singleton.
  getIt.registerLazySingleton<BoardRepository>(() => InMemoryBoardRepository());

  // Register board use cases.
  getIt.registerFactory(() => GetBoardUseCase(getIt<BoardRepository>()));
  getIt.registerFactory(() => SaveBoardUseCase(getIt<BoardRepository>()));
  getIt.registerFactory(() => UpdateBoardUseCase(getIt<BoardRepository>()));

  // Register task use cases.
  getIt.registerLazySingleton<AddTaskUseCase>(() => AddTaskUseCase());
  getIt.registerLazySingleton<DeleteTaskUseCase>(() => DeleteTaskUseCase());
  getIt.registerLazySingleton<ReorderTaskUseCase>(() => ReorderTaskUseCase());
  getIt.registerLazySingleton<MoveTaskUseCase>(() => MoveTaskUseCase());
}
