import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/{{feature_name.snakeCase()}}_repository_implementation.dart'
import '../../domain/{{feature_name.snakeCase()}}_repository.dart';

final {{feature_name.camelCase()}}Provider = StateNotifierProvider.autoDispose((ref) {
  return {{feature_name.pascalCase()}}();
});



class {{feature_name.pascalCase()}}StateNotifier extends StateNotifier<bool> {
  {{feature_name.pascalCase()}}() : super(False);
  final {{feature_name.pascalCase()}}Repository _repository = const {{feature_name.pascalCase()}}RepositoryImplementation();

  Future<void> getPing() async{
    reasult = await _repository.ping();
    state = result;

}

}
