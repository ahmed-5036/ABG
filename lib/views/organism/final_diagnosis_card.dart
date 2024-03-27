import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../services/extension.dart';

class FinalDiagnosisCard extends StatefulWidget {
  const FinalDiagnosisCard({
    required this.text,
    super.key,
  });

  final String text;

  @override
  State<FinalDiagnosisCard> createState() => _FinalDiagnosisCardState();
}

class _FinalDiagnosisCardState extends State<FinalDiagnosisCard> {
  bool _isHover = false;

  void onHoverEnter() {
    if (_isHover == true) return;
    setState(() {
      _isHover = true;
    });
  }

  void onHoverExit() {
    if (_isHover == false) return;
    setState(() {
      _isHover = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Alert(
          context: context,
          type: AlertType.none,
          title: "Final Diagnosis",
          desc: widget.text,
          buttons: <DialogButton>[
            DialogButton(
              onPressed: () => context.navigator.pop(),
              // width: 120,
              color: Colors.black,

              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      },
      child: MouseRegion(
        onHover: (_) {
          // print("hovering");
          // onHoverEnter();
        },
        onExit: (_) {
          // print("exit");
          // onHoverExit();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _isHover ? 1.1 : 1,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(247, 242, 249, 1),
                border: Border.all(color: Colors.indigo.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: <Widget>[
                Text(
                  "Final Diagnosis",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: _isHover
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                      fontWeight:
                          _isHover ? FontWeight.bold : FontWeight.normal),
                ),
                const SizedBox(
                  height: 12,
                ),
                // Text(
                //   widget.text,
                //   textAlign: TextAlign.center,
                //   style: Theme.of(context)
                //       .textTheme
                //       .headlineSmall
                //       ?.copyWith(fontWeight: FontWeight.w500),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
