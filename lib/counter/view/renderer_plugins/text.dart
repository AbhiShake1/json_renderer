import 'package:flutter/material.dart';
import 'package:json_renderer_test/counter/counter.dart';

class JsonRendererTextPlugin extends JsonRendererPlugin {
  const JsonRendererTextPlugin({super.key});
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
    final textStyle = params['text_style'];
    final fontStyle = textStyle?['font_style']?.toString();
    return Text(
      params['text']?.toString() ?? '',
      style: TextStyle(
        fontStyle:
            fontStyle == null ? null : enumByName(FontStyle.values, fontStyle),
        fontSize: textStyle?['font_size'] as double?,
      ),
    );
  }

  @override
  String get type => 'text';
}
