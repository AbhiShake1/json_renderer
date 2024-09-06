import 'package:flutter/material.dart';
import 'package:json_renderer_test/counter/counter.dart';

class JsonRendererColumnPlugin extends JsonRendererPlugin {
  JsonRendererColumnPlugin({super.key});
  @override
  JsonRendererSchema get schema => {
        'children': JsonRendererValidator.ofType(List<Widget>),
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final json in getParam<List<dynamic>>('children') ?? [])
          if (json is Map<String, dynamic>) JsonRenderer(json),
      ],
    );
  }

  @override
  String get type => 'column';
}
