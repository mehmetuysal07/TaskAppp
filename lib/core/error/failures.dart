import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Örneğin veritabanı hatası olursa bunu döndüreceğiz
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Örneğin internet yoksa bunu döndüreceğiz
class ConnectionFailure extends Failure {
  const ConnectionFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
