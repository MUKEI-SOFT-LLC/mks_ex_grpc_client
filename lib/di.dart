import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:grpc/grpc.dart' as grpc;
import 'package:mks_ex_dart_interfaces/echo.pbgrpc.dart';

final getIt = GetIt.instance;
void injectDependencies() {
  final hostName = Platform.isIOS ? 'localhost' : '10.0.2.2';
  final channel = grpc.ClientChannel(
      hostName,
      port: 6848,
      options: grpc.ChannelOptions(
          credentials: grpc.ChannelCredentials.insecure(),
          idleTimeout: Duration(seconds: 5)
      )
  );
  getIt
    ..registerSingleton(EchoServiceClient(channel))
  ;
}