import 'package:flutter/material.dart';
import 'package:json_renderer_test/counter/counter.dart';

class JsonRendererTextPlugin extends JsonRendererPlugin {
  JsonRendererTextPlugin({super.key});

  @override
  JsonRendererSchema get schema => {
        'text': JsonRendererValidator.ofType(String),
        'text_style': JsonRendererValidator.fromMap({
          'font_style': JsonRendererValidator.ofType(String),
          'font_size': JsonRendererValidator.ofType(double),
        }),
      };

  @override
  Widget build(BuildContext context) {
    final fontStyle = getParam<String>('text_style.font_style');
    final fontSize = getParam<double>('text_style.font_size');
    final text = getParam<String>('text');

    if (text?.isEmpty ?? true) return const SizedBox();

    return Text(
      text!,
      style: TextStyle(
        fontStyle: enumByNameOrNull(FontStyle.values, fontStyle),
        fontSize: fontSize,
      ),
    );
  }

  @override
  String get type => 'text';
}
