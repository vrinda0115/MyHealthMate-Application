import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'dart:async';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import '../utils/settings.dart';

class CallPgae extends StatefulWidget {
  final String? channelName;
  final ClientRole? role;
  const CallPgae({
    Key? key,
    this.channelName,
    this.role,
  }) : super(key: key);

  @override
  State<CallPgae> createState() => _CallPgaeState();
}

class _CallPgaeState extends State<CallPgae> {
  final _users = <int>[];
  final _infoString = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async{

    if(appId.isEmpty) {
      setState(() {
        _infoString.add(
          'APP_ID is missing, please provide your APP_ID in settings.dart',
        );
        _infoString.add('Agora Engine is not starting');
      });
      return;
  }
  //! _initAgoraRtcEngine

  

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agora"),
        centerTitle: true,
      ),
    );
  }
}