import 'package:direct_caller_sim_choice/direct_caller_sim_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:gate_caller/h_space.dart';
import 'package:gate_caller/local_storage.dart';
import 'package:gate_caller/sizes.dart';
import 'package:gate_caller/v_space.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const GateCaller());
}

class GateCaller extends StatelessWidget {
  const GateCaller({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'GameCaller',
      home: SettingsPage(),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _phoneNumberTextFieldController = TextEditingController();

  bool _callAfterAppOpened = false;

  @override
  void initState() {
    super.initState();

    _makeOnAppOpenedCall();
    _onCancel();
  }

  Future<void> _makeOnAppOpenedCall() async {
    final settings = await LocalStorage.getSettings();

    if (settings.callAfterAppOpened) {
      await _makePhoneCall();
    }
  }

  Future<void> _makePhoneCall() async {
    final permissionStatus = await Permission.phone.request();

    if (!permissionStatus.isGranted) {
      await showCupertinoDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Błąd"),
            content: const Text(
              "Nie można wykonać połączenia z uwagi na brak uprawnień. Zmień uprawnienia w ustawieniach aplikacji.",
            ),
            actions: [
              CupertinoButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }

    final settings = await LocalStorage.getSettings();

    if (settings.phoneNumber == null) {
      return;
    }

    final DirectCaller directCaller = DirectCaller();
    final success = directCaller.makePhoneCall("+48 ${settings.phoneNumber}");

    if (success) {
      await showCupertinoDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Sukces"),
            content: Text(
              "Pomyślnie wykonano połączenie na numer \"+48 ${settings.phoneNumber}\".",
            ),
            actions: [
              CupertinoButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } else {
      await showCupertinoDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Błąd"),
            content: Text(
              "Nie udało się wykonać połączenia na numer \"+48 ${settings.phoneNumber}\".",
            ),
            actions: [
              CupertinoButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _onSave() async {
    await LocalStorage.saveSettings(
      callAfterAppOpened: _callAfterAppOpened,
      phoneNumber: _phoneNumberTextFieldController.text,
    );

    await showCupertinoDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Zapisano dane"),
          content: const Text("Pomyślnie zapisano dane!"),
          actions: [
            CupertinoButton(
              onPressed: Navigator.of(context).pop,
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onCancel() async {
    final settings = await LocalStorage.getSettings();

    setState(() {
      _callAfterAppOpened = settings.callAfterAppOpened;
      _phoneNumberTextFieldController.text = settings.phoneNumber ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const VSpace.p48(),
              const Text(
                "Brama 1",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Otwieranie bramy nigdy nie było prostsze!!!",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const VSpace.p24(),
              const Text(
                'Numer, na który zadzwonić',
                textAlign: TextAlign.center,
              ),
              const VSpace.p4(),
              CupertinoTextField(
                controller: _phoneNumberTextFieldController,
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text("+48"),
                ),
                placeholder: "000 000 000",
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  MaskTextInputFormatter(mask: "### ### ###"),
                ],
              ),
              const VSpace.p16(),
              Row(
                children: [
                  CupertinoSwitch(
                    value: _callAfterAppOpened,
                    onChanged: (_) {
                      setState(() {
                        _callAfterAppOpened = !_callAfterAppOpened;
                      });
                    },
                  ),
                  const HSpace.p8(),
                  const Text("Czy dzwonić po włączeniu aplikacji?")
                ],
              ),
              const VSpace.p16(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    onPressed: _onCancel,
                    child: const Text("Anuluj"),
                  ),
                  CupertinoButton.filled(
                    onPressed: _onSave,
                    child: const Text("Zapisz"),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: CupertinoButton(
                  color: CupertinoColors.activeGreen,
                  onPressed: _makePhoneCall,
                  child: const Text("Zadzwoń"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
