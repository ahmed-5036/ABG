import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/input_calculator_provider.dart';
import '../../resources/constants/app_constants.dart';
import '../../services/extension.dart';
import '../molecules/default_text_field.dart';
import 'adaptive_input_dialog.dart';
import 'colorful_text_result.dart';

final Provider<Map<String, TextEditingController>> firstSectionTxtEditProvider =
    Provider<Map<String, TextEditingController>>((ProviderRef<Map<String, TextEditingController>> ref) {
  return <String, TextEditingController>{
    "potassiumTxtEditing": TextEditingController(),
    "sodiumTxtEditing": TextEditingController(),
    "albuminTxtEditing": TextEditingController(),
    "chlorineTxtEditing": TextEditingController(),
  };
});

class FirstSection extends ConsumerWidget {
  const FirstSection({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double? potassium;
    double? sodium;
    double? albumin;
    double? chlorine;

    return Column(
      children: <Widget>[
        const SizedBox(
          height: 8,
        ),
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return AdaptiveInputDialog(
              firstInput: DefaultTextField(
                textInputAction: TextInputAction.next,
                hint: "K mEq/L",
                label: "K mEq/L (3.5-5.5)",
                controller: ref
                    .read(firstSectionTxtEditProvider)["potassiumTxtEditing"],
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(numberWithDecimalRegex),
                  LengthLimitingTextInputFormatter(4)
                ],
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (String kVal) {
                  potassium = double.parse(kVal.toParsableString());

                  ref
                      .read(potassiumNotifierProvider.notifier)
                      .getPotassiumDiagnosis(potassium);
                },
              ),
              secondInput: ColorfulCalcTextResult(
                text:
                    ref.watch(potassiumNotifierProvider).findingLevel.level.$1,
                status:
                    ref.watch(potassiumNotifierProvider).findingLevel.level.$2,
              ));
        }),
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
          // print("na ");
          return AdaptiveInputDialog(
              firstInput: DefaultTextField(
                textInputAction: TextInputAction.next,
                hint: "Na mEq/L",
                label: "Na mEq/L (135-145)",
                controller:
                    ref.read(firstSectionTxtEditProvider)["sodiumTxtEditing"],
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(numberWithDecimalRegex),
                  LengthLimitingTextInputFormatter(5)
                ],
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (String naVal) {
                  sodium = double.parse(naVal.toParsableString());

                  ref
                      .read(sodiumNotifierProvider.notifier)
                      .getSodiumDiagnosis(sodium);
                },
              ),
              secondInput: ColorfulCalcTextResult(
                text: ref.watch(sodiumNotifierProvider).findingLevel.level.$1,
                status: ref.watch(sodiumNotifierProvider).findingLevel.level.$2,
              ));
        }),
        Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                AdaptiveInputDialog(
                    firstInput: DefaultTextField(
                      textInputAction: TextInputAction.next,
                      hint: "Albumin g%",
                      label: "Albumin g% (3.5-4.5)",
                      controller: ref.read(
                          firstSectionTxtEditProvider)["albuminTxtEditing"],
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            numberWithDecimalRegex),
                        LengthLimitingTextInputFormatter(4)
                      ],
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (String albuminVal) {
                        albumin = double.parse(albuminVal.toParsableString());

                        ref
                            .read(albuminNotifierProvider.notifier)
                            .getAlbuminDiagnosis(albumin);
                      },
                    ),
                    secondInput: ColorfulCalcTextResult(
                      text: ref
                          .watch(albuminNotifierProvider)
                          .findingLevel
                          .level
                          .$1,
                      status: ref
                          .watch(albuminNotifierProvider)
                          .findingLevel
                          .level
                          .$2,
                    ))),
        Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                AdaptiveInputDialog(
                  firstInput: DefaultTextField(
                    textInputAction: TextInputAction.next,
                    label: "CL mEq/L (98-108)",
                    hint: "CL mEq/L",
                    controller: ref.read(
                        firstSectionTxtEditProvider)["chlorineTxtEditing"],
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(numberWithDecimalRegex),
                      LengthLimitingTextInputFormatter(4)
                    ],
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (String clVal) {
                      chlorine = double.parse(clVal.toParsableString());

                      ref
                          .read(chlorineNotifierProvider.notifier)
                          .getChlorineDiagnosis(chlorine);
                    },
                  ),
                  secondInput: ColorfulCalcTextResult(
                      text: ref
                          .watch(chlorineNotifierProvider)
                          .findingLevel
                          .level
                          .$1,
                      status: ref
                          .watch(chlorineNotifierProvider)
                          .findingLevel
                          .level
                          .$2),
                )),
        // const Spacer(),
      ],
    );
  }
}
