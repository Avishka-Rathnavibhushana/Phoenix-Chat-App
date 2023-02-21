import 'package:flutter/material.dart';
import 'package:pheonix_chat_app/theme.dart';
import 'package:torch_light/torch_light.dart';

class VLCTransmitterPage extends StatefulWidget {
  const VLCTransmitterPage({Key? key}) : super(key: key);

  @override
  State<VLCTransmitterPage> createState() => _VLCTransmitterPageState();
}

class _VLCTransmitterPageState extends State<VLCTransmitterPage> {
  bool _loading = false;

  TextEditingController messageController = new TextEditingController(text: "");

  bool hasflashlight = false; //to set is there any flashlight ?
  bool isturnon = false; //to set if flash light is on or off
  IconData flashicon = Icons.flash_off; //icon for lashlight button
  Color flashbtncolor = Colors.deepOrangeAccent; //color for flash button

  @override
  void initState() {
    super.initState();
  }

  Future<void> sendMessage() async {
    List<String> letters = [
      " ",
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z"
    ];

    String message = messageController.text;

    for (String C in message.split('')) {
      print(C);
      int count = letters.indexOf(C) + 1;
      for (var i = 0; i < count; i++) {
        print("flash on");
        await onFlash();
        await Future.delayed(Duration(milliseconds: 400));
        print("flash off");
        await offFlash();
        await Future.delayed(Duration(milliseconds: 250));
      }
      await Future.delayed(Duration(milliseconds: 2000));
    }
  }

  Future<void> onFlash() async {
    if (!isturnon) {
      //if light is off, then turn on.
      await _turnOnFlash(context);
      setState(() {
        isturnon = true;
        flashicon = Icons.flash_on;
        flashbtncolor = Colors.greenAccent;
      });
    }
  }

  Future<void> offFlash() async {
    if (isturnon) {
      //if light is on, then turn off
      await _turnOffFlash(context);
      setState(() {
        isturnon = false;
        flashicon = Icons.flash_off;
        flashbtncolor = Colors.deepOrangeAccent;
      });
    }
  }

  Future<void> _turnOnFlash(BuildContext context) async {
    try {
      await TorchLight.enableTorch();
    } on Exception catch (_) {
      _showErrorMes('Could not enable Flashlight', context);
    }
  }

  Future<void> _turnOffFlash(BuildContext context) async {
    try {
      await TorchLight.disableTorch();
    } on Exception catch (_) {
      _showErrorMes('Could not enable Flashlight', context);
    }
  }

  void _showErrorMes(String mes, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mes)));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              "VLC Messaging",
              style: TextStyle(
                fontSize: 30,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: messageController,
                  textCapitalization: TextCapitalization.characters,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 25, letterSpacing: 0),
                  decoration: InputDecoration(
                    labelText: "Enter Message to Send",
                    labelStyle: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.secondary),
                    ),
                    onPressed: sendMessage,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 7),
                      child: const Text(
                        'Send Message',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
