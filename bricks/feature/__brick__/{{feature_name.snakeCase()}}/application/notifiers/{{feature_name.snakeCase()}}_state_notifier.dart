import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../data/{{feature_name.snakeCase()}}_repository_implementation.dart';
import '../../domain/{{feature_name.snakeCase()}}_repository.dart';


class {{feature_name.pascalCase()}}StateNotifier extends StateNotifier<bool> {
  {{feature_name.pascalCase()}}StateNotifier() : super(false);
  final {{feature_name.pascalCase()}}Repository _repository = {{feature_name.pascalCase()}}RepositoryImplementation();

  Future<void> getPing(String url) async{
    bool result = await _repository.ping(url:url);
    state = result;

}

}
