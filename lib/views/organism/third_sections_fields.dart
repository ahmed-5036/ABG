import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/input_calculator_provider.dart';
import '../../resources/constants/app_constants.dart';
import '../../services/extension.dart';
import '../molecules/default_text_field.dart';
import 'adaptive_input_dialog.dart';
import 'colorful_text_result.dart';

final Provider<Map<String, TextEditingController>> thirdSectionTxtEditProvider =
    Provider<Map<String, TextEditingController>>((ProviderRef<Map<String, TextEditingController>> ref) {
  return <String, TextEditingController>{
    "pco2TxtEditing": TextEditingController(),
    "fio2TxtEditing": TextEditingController(),
    "ageTxtEditing": TextEditingController(),
    "pao2TxtEditing": TextEditingController(),
  };
});

class ThirdSection extends ConsumerWidget {
  const ThirdSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                AdaptiveInputDialog(
                    firstInput: DefaultTextField(
                      textInputAction: TextInputAction.next,
                      hint: "PCO2 mmHg",
                      label: "PCO2 mmHg (40)",
                      controller: ref
                          .read(thirdSectionTxtEditProvider)["pco2TxtEditing"],
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            numberWithDecimalRegex),
                        LengthLimitingTextInputFormatter(3)
                      ],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (String pco2Val) {
                        ref
                            .read(pCO2NotifierProvider.notifier)
                            .getPco2Diagnosis(
                                double.parse(pco2Val.toParsableString()));
                      },
                    ),
                    secondInput: ColorfulCalcTextResult(
                      text:
                          ref.watch(pCO2NotifierProvider).findingLevel.level.$1,
                      status:
                          ref.watch(pCO2NotifierProvider).findingLevel.level.$2,
                    ))),
        Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                AdaptiveInputDialog(
                    firstInput: DefaultTextField(
                      textInputAction: TextInputAction.next,
                      label: "FiO2%",
                      controller: ref
                          .watch(thirdSectionTxtEditProvider)["fio2TxtEditing"],
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            numberWithDecimalRegex),
                        LengthLimitingTextInputFormatter(3)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (String fiO2Val) {
                        ref.read(fiO2Provider.notifier).state =
                            double.parse(fiO2Val.toParsableString());
                      },
                    ),
                    secondInput: const ColorfulCalcTextResult(
                      text: "",
                      status: null,
                    ))),
        Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                AdaptiveInputDialog(
                    firstInput: DefaultTextField(
                      textInputAction: TextInputAction.next,
                      label: "Age years",
                      controller: ref
                          .watch(thirdSectionTxtEditProvider)["ageTxtEditing"],
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(2)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (String ageVal) {
                        ref.read(agesProvider.notifier).state =
                            double.parse(ageVal.toParsableString());
                      },
                    ),
                    secondInput: const ColorfulCalcTextResult(
                      text: "",
                      status: null,
                    ))),
        Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                AdaptiveInputDialog(
                  firstInput: DefaultTextField(
                    textInputAction: TextInputAction.next,
                    label: "PaO2 mmHg",
                    controller: ref
                        .watch(thirdSectionTxtEditProvider)["pao2TxtEditing"],
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(numberWithDecimalRegex),
                      LengthLimitingTextInputFormatter(3)
                    ],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String paO2Val) {
                      ref.read(paInputO2Provider.notifier).state =
                          double.parse(paO2Val.toParsableString());
                    },
                  ),
                  secondInput:
                      const ColorfulCalcTextResult(text: "", status: null),
                )),
      ],
    );
  }
}
