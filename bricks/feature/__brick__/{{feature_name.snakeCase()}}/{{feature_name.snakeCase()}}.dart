{{#isBloc}}export 'bloc/bloc.dart';{{/isBloc}}{{#isCubit}}export 'cubit/cubit.dart';{{/isCubit}}{{#isProvider}}export 'application/state.dart';{{/isProvider}}{{#isRiverpod}}export 'provider/state.dart';{{/isRiverpod}}
export 'view/{{feature_name.snakeCase()}}_page.dart';
export 'widgets/widgets.dart';
