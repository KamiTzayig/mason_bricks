import 'dart:io';

import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart';

Future run(HookContext context) async {
  final logger = context.logger;

  logger.alert(
    red.wrap(
      'kami',
    ),
  );

  final stateManagement =
      context.vars['state_management'].toString().toLowerCase();
  final isBloc = stateManagement == 'bloc';
  final isCubit = stateManagement == 'cubit';
  final isProvider = stateManagement == 'provider';
  final isRiverpod = stateManagement == 'riverpod';
  final isNone = !isBloc && !isCubit && !isProvider && !isRiverpod;

  logger.alert(
    red.wrap(
      'kami2',
    ),
  );
  bool useEquatable = false;
  if (isBloc || isCubit) {
    useEquatable = context.logger.confirm(
      '? Do you want to use equatable with your $stateManagement? (Y/n)',
      defaultValue: true,
    );
  }

  logger.alert(
    red.wrap(
      'kami3',
    ),
  );

  final directory = Directory.current.path;
  List<String> folders;
  try {
    if (Platform.isWindows) {
      folders = directory.split(r'\').toList();
    } else {
      folders = directory.split('/').toList();
    }
    final libIndex = folders.indexWhere((folder) => folder == 'lib');
    final featurePath = folders.sublist(libIndex + 1, folders.length).join('/');
    final pubSpecFile =
        File('${folders.sublist(0, libIndex).join('/')}/pubspec.yaml');
    final content = await pubSpecFile.readAsString();
    final yamlMap = loadYaml(content);
    final packageName = yamlMap['name'];

    if (packageName == null) {
      throw PubspecNameException();
    }

    logger.alert(
      red.wrap(
        'kami4',
      ),
    );
    context.vars = {
      ...context.vars,
      'fullPath': ('$packageName/$featurePath/${context.vars['feature_name']}')
          .replaceAll('//', '/'),
      'isBloc': isBloc,
      'isCubit': isCubit,
      'isProvider': isProvider,
      'isRiverpod': isRiverpod,
      'isNone': isNone,
      'use_equatable': useEquatable
    };

    logger.alert(
      red.wrap(
        'kami6',
      ),
    );
  } on RangeError catch (_) {
    logger.alert(
      red.wrap(
        'Could not find lib folder in $directory',
      ),
    );
    logger.alert(
      red.wrap(
        'Re-run this brick inside your lib folder',
      ),
    );
    throw Exception();
  } on FileSystemException catch (_) {
    logger.alert(
      red.wrap(
        'Could not find pubspec.yaml folder in ${directory.replaceAll('\\lib', '')}',
      ),
    );

    throw Exception();
  } on PubspecNameException catch (_) {
    logger.alert(
      red.wrap(
        'Could not read package name in pubspec.yaml}',
      ),
    );
    logger.alert(
      red.wrap(
        'Does your pubspec have a name: ?',
      ),
    );
    throw Exception();
  } on Exception catch (e) {
    logger.alert(
      red.wrap(
        'kami ' +e.toString(),
      ),
    );
    throw e;
  }
}

class PubspecNameException implements Exception {}
