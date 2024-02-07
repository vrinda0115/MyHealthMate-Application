import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';


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