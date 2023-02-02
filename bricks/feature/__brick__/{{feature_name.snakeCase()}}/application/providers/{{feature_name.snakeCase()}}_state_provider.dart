import '../notifiers/{{feature_name.snakeCase()}}_state_notifier.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';


final {{feature_name.camelCase()}}StateProvider = StateNotifierProvider((ref) {
return {{feature_name.pascalCase()}}StateNotifier();
});

