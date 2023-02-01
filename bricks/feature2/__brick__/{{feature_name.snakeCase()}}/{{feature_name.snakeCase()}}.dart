{{#isBloc}}export 'application/bloc/bloc.dart';{{/isBloc}}{{#isCubit}}export 'application/cubit/cubit.dart';{{/isCubit}}{{#isProvider}}export 'application/state.dart';{{/isProvider}}{{#isRiverpod}}export 'application/state.dart';{{/isRiverpod}}
export 'view/{{feature_name.snakeCase()}}_page.dart';
export 'widgets/widgets.dart';
