
import 'package:flutter/material.dart';
import 'package:uipages/components/drawer.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
const appId = "29c653efca674292a77a0ff5db170b29";
const token = "007eJxTYEia+a1xTqfSV7EHrPq3FBf23r3SzyWtaaz4c0ftx4N/g3MUGIwsk81MjVPTkhPNzE2MLI0Szc0TDdLSTFOSDM0Nkowsf6r+T20IZGSIbzrPwAiFID4PQ1pmUXFJckZiXl5qDgMDAMXaJGw=";
class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int? _remoteUid;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initForAgora();
  }

  Future<void> initForAgora() async {
    await [Permission.microphone, Permission.camera].request();

    try {
      _engine = await RtcEngine.createWithConfig(RtcEngineConfig(appId));
      await _engine.enableVideo();

      _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (channel, uid, elapsed) {
          print("Local user $uid joined");
        },
        userJoined: (uid, elapsed) {
          print("Remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (uid, reason) {
          print("Remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ));

      await _engine.joinChannel(token, "firstchannel", null, 0);
    } catch (e) {
      print("Failed to initialize Agora engine: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agora Video Call"),
      ),
      body: Stack(
        children: [
          Center(
            child: _renderRemoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: 100,
              height: 100,
              child: Center(
                child: _renderLocalPreview(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderLocalPreview() {
    return RtcLocalView.SurfaceView();
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return RtcRemoteView.SurfaceView(
        uid: _remoteUid!,
        channelId: 'firstchannel',
      );
    } else {
      return Center(
        child: Text('Waiting for remote user to join...'),
      );
    }
  }
}