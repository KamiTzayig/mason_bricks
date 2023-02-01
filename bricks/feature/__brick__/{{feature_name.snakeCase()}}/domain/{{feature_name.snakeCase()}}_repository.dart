//example of an abstract repository which the data layer will implement
abstract class {{feature_name.pascalCase()}}Repository {
  Future<bool> ping({required String url});
}
