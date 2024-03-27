import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../services/extension.dart';

// final alwaysShowDetailsProvider = StateProvider<bool>((ref) {
//   return false;
// });

class DiagnosisCard extends StatefulWidget {
  @Deprecated(
      "this card was replaced with simple buttons, please consider removing it from your UI")
  const DiagnosisCard({
    required this.title,
    required this.details,
    super.key,
  });
  final String title;
  final String details;

  @override
  State<DiagnosisCard> createState() => _DiagnosisCardState();
}

class _DiagnosisCardState extends State<DiagnosisCard> {
  bool _isHover = false;

  void onHoverEnter() {
    if (!kIsWeb) return;
    if (_isHover == true) return;
    setState(() {
      _isHover = true;
    });
  }

  void onHoverExit() {
    if (!kIsWeb) return;
    if (_isHover == false) return;
    setState(() {
      _isHover = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        // print("hovering");
        onHoverEnter();
      },
      onExit: (_) {
        // print("exit");
        onHoverExit();
      },
      child: GestureDetector(
        onTap: () async {
          Alert(
            context: context,
            type: AlertType.none,
            title: widget.title,
            desc: widget.details,
            buttons: <DialogButton>[
              DialogButton(
                onPressed: () => context.navigator.pop(),
                // width: 120,
                color: Colors.black,

                child: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          ).show();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 150),
          scale: _isHover ? 1.1 : 1,
          child: Card(
            borderOnForeground: true,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Flexible(
                  child: Text(
                    widget.title,
                    maxLines: 6,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: _isHover ? Theme.of(context).primaryColor : null,
                        fontWeight: _isHover ? FontWeight.w900 : null),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Consumer(
                        builder: (BuildContext context, WidgetRef ref,
                                Widget? child) =>
                            AnimatedOpacity(
                          opacity: _isHover ? 1 : 0,
                          duration: const Duration(milliseconds: 350),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                widget.details,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(fontWeight: FontWeight.w200),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
