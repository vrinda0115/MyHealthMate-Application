
import 'package:flutter/material.dart';
import 'package:uipages/components/drawer.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
const appId = "29c653efca674292a77a0ff5db170b29";
const token = "007eJxTYNBcn5Cvqacu/N8/c5pQpGZvJ0eGwKVLa+fOPeMX1yeX+kqBwcgy2czUODUtOdHM3MTI0ijR3DzRIC3NNCXJ0NwgycjywYafqQ2BjAzrTjMyMjJAIIjPzZCWWVRckpyRmJeaw8AAAJxfIWI=";
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

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

  Future<void> initForAgora() async{
    //retrieve Permissions
    await [Permission.microphone, Permission.camera].request();

    // Create the engine
    try {
      _engine = await RtcEngine.createWithContext(RtcEngineContext(appId));

      await _engine.enableVideo();

      _engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
          print("Local user $uid joined");
        },
        userJoined: (int uid, int elapsed) {
          print("Remote user $uid joined");
          setState(() {
            _remoteUid = uid;
          });
        },
        userOffline: (int uid, UserOfflineReason reason) {
          print("Remote user $uid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ));

      // Join a channel (replace "your_channel_name" with your channel name)
      await _engine.joinChannel(null, "firstchanel", null, 0);
    } catch (e) {
      print("Failed to initialize Agora engine: $e");
      // Handle initialization error
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.deepPurple[100],
        title: const Text("Agora Video Call"),),
      drawer: MyDrawer(),
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

  //current user video
  Widget _renderLocalPreview(){
    return RtcLocalView.SurfaceView();
   
   
  }

  // remote user video
Widget _renderRemoteVideo(){
   if (_remoteUid != null) {
    return RtcRemoteView.SurfaceView(uid: _remoteUid!, channelId: 'firstchanel');
   } else {
    return Text('Please wait remote user to join',
    textAlign: TextAlign.center,);
   }
  }
}