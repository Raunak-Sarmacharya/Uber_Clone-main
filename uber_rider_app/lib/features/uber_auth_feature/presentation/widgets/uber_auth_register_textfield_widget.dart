import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:uber_rider_app/features/uber_map_feature/presentation/getx/uber_map_controller.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final String textType;

  final TextInputType inputType;
  final TextEditingController? controller;


  const TextFieldWidget(
      {Key? key,
      required this.labelText,
      required this.textType,
      required this.inputType,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
class TextCompleteFieldWidget extends StatelessWidget {
  final String labelText;
  final String textType;
  final String placeName;
  final TextInputType inputType;
  final TextEditingController? controller;
  final UberMapController uberMapController ;

  const TextCompleteFieldWidget(
      {Key? key,
        required this.labelText,
        required this.textType,
        required this.inputType,
        required this.controller, required this.uberMapController, required this.placeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      child: TextFormField(onChanged: (val) {
        // autocomplete
        uberMapController.getPredictions(placeName, 'source');
      },
        controller: controller?..text = uberMapController.sourcePlaceName.value,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}