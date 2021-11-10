import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
// Dart client
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.3:3000'), protocols: ['psql']);
  IO.Socket socket = IO.io('http://192.168.1.3:3000', <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,
  });
  var streamData = [];

  @override
  void initState() {
    super.initState();
    socket.connect();
    socket.onConnect((data) => {print('Connected')});
  }

  @override
  Widget build(BuildContext context) {
    socket.on('psql', (data) {
      // setState(() {
      //   streamData = data;
      // });
      streamData.clear();
      for (var some in data) {
        streamData.add(some);
        setState(() {});
      }
    });
    return Scaffold(
        appBar: AppBar(),
        // body: Center(
        //     child: ElevatedButton(
        //         onPressed: () {
        //           socket.emit('test', "this is from flutter");
        //           print(socket.id);
        //         },
        //         child: Text('Press Button'))),
        body: ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(streamData[index].toString()),
          ),
          itemCount: streamData.length,
        ));
  }
}
