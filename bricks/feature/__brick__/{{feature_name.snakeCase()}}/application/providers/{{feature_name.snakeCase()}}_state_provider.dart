import '../notifiers/{{feature_name.snakeCase()}}_state_notifier.dart';


final {{feature_name.camelCase()}}StateProvider = StateNotifierProvider.autoDispose((ref) {
return {{feature_name.pascalCase()}}StateNotifier();
});

