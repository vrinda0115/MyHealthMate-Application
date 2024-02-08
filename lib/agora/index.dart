
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import './call.dart';
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final _channelController = TextEditingController();
  bool _validateError = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    _channelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: <Widget>[
            const SizedBox(height: 40,),
            Image.network('http://tinyurl.com/2p889y4k'),
            const SizedBox(height: 20,),
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                errorText: 
                  _validateError ? 'Channel name is mandatory' : null,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1),
                ),
                hintText: 'Channel name',
              ),
            ),
            RadioListTile(
              title: const Text('Broadcaster'),
              onChanged: (ClientRole? value){
              setState(() {
                _role = value;
              });
            },
            value: ClientRole.Broadcaster,
            groupValue: _role,
            ),
            RadioListTile( title: const Text('Audience'),
              onChanged: (ClientRole? value){
              setState(() {
                _role = value;
              });
              },
              value: ClientRole.Audience,
            ),
          ],),
        )
      ),
    );
  }
}