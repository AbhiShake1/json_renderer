import 'package:flutter/material.dart';
import 'package:json_renderer_test/counter/counter.dart';

class JsonRendererColumnPlugin extends JsonRendererPlugin {
  const JsonRendererColumnPlugin({super.key});
  @override
  JsonRendererSchema get schema => {
        'children': JsonRendererValidator.ofType(List<Widget>),
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final json in params['children'] as List? ?? [])
          if (json is Map<String, dynamic>) JsonRenderer(json),
      ],
    );
  }

  @override
  String get type => 'column';
}
