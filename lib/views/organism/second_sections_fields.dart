import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/input_calculator_provider.dart';
import '../../resources/constants/app_constants.dart';
import '../molecules/default_text_field.dart';
import 'adaptive_input_dialog.dart';
import 'colorful_text_result.dart';

final Provider<Map<String, TextEditingController>> secondSectionTxtEditProvider =
    Provider<Map<String, TextEditingController>>((ProviderRef<Map<String, TextEditingController>> ref) {
  return <String, TextEditingController>{
    "hco3TxtEditing": TextEditingController(),
    "phTxtEditing": TextEditingController(),
  };
});

class SecondSection extends ConsumerWidget {
  const SecondSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? hco3;
    double? ph;

    return Column(
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return AdaptiveInputDialog(
              firstInput: DefaultTextField(
                textInputAction: TextInputAction.next,
                label: "HCO3 mEq/L (24)",
                hint: "HCO3 mEq/L",
                controller:
                    ref.read(secondSectionTxtEditProvider)["hco3TxtEditing"],
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(numberWithDecimalRegex),
                  LengthLimitingTextInputFormatter(3)
                ],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (String hco3Val) {
                  if (hco3Val.isEmpty) {
                    hco3 = null;
                  } else {
                    hco3 = double.parse(hco3Val);
                  }
                  ref
                      .read(hco3NotifierProvider.notifier)
                      .getHCo3Diagnosis(hco3);
                },
              ),
              secondInput: ColorfulCalcTextResult(
                text: ref.watch(hco3NotifierProvider).findingLevel.level.$1,
                status: ref.watch(hco3NotifierProvider).findingLevel.level.$2,
              ));
        }),
        Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                AdaptiveInputDialog(
                    firstInput: DefaultTextField(
                      textInputAction: TextInputAction.next,
                      hint: "PH",
                      label: "PH (7.4)",
                      controller: ref
                          .read(secondSectionTxtEditProvider)["phTxtEditing"],
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            numberWithDecimalRegex),
                        LengthLimitingTextInputFormatter(6)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (String phVal) {
                        if (phVal.isEmpty) {
                          ph = null;
                        } else {
                          ph = double.parse(phVal);
                        }

                        ref
                            .read(phNotifierProvider.notifier)
                            .getPhDiagnosis(ph);
                      },
                    ),
                    secondInput: ColorfulCalcTextResult(
                      text: ref.watch(phNotifierProvider).findingLevel.level.$1,
                      status:
                          ref.watch(phNotifierProvider).findingLevel.level.$2,
                    ))),
      ],
    );
  }
}
