import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mks_ex_dart_interfaces/echo.pbgrpc.dart';
import 'package:mks_ex_grpc_client/di.dart';

void main() {
  injectDependencies();
  runApp(ProviderScope(child: GrpcClientExampleApp()));
}

class GrpcClientExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'gRPC client example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _MainPage(title: 'Flutter gRPC Client example'),
    );
  }
}

class _MainPage extends StatelessWidget {
  _MainPage({Key? key, required this.title}) : super(key: key);

  final String title;
  final _messageTextController = TextEditingController();
  final _responseProvider = StateProvider<String>((_) => 'Response message is displayed here.');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 300, child: TextField(
              controller: _messageTextController,
              maxLength: 40,
            )),
            ElevatedButton(
                child: const Text('send'),
                onPressed: () => _send(context)
            ),
            _ResponseWidget(_responseProvider),
          ],
        ),
      ),
    );
  }

  void _send(BuildContext context) async {
    final request = EchoRequest.create();
    request.message = _messageTextController.text;
    final response = await getIt.get<EchoServiceClient>().echo(request);
    context.read(_responseProvider).state = response.message;
  }
}

class _ResponseWidget extends ConsumerWidget {

  final StateProvider<String> _responseProvider;
  _ResponseWidget(this._responseProvider);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Text(watch(_responseProvider).state)
    );
  }
}

