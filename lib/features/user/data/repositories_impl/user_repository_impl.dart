import 'package:task_app/features/user/data/datasources/user_remote_data_source.dart';
import 'package:task_app/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl({required this.userRemoteDataSource});

  @override
  
  Future addUser(String email, String uid,) async {
    return await userRemoteDataSource.addUser(email, uid);
  }
}
