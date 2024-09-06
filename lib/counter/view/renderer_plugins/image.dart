import 'package:flutter/material.dart';
import 'package:json_renderer_test/counter/counter.dart';

class JsonRendererImagePlugin extends JsonRendererPlugin {
  JsonRendererImagePlugin({super.key});
  @override
  JsonRendererSchema get schema => {
        'height': JsonRendererValidator.ofType(double),
        'width': JsonRendererValidator.ofType(double),
        'path': JsonRendererValidator.ofType(String),
        'isNetwork': JsonRendererValidator.ofType(bool),
      };

  @override
  Widget build(BuildContext context) {
    final height = getParam<double>('height');
    final width = getParam<double>('width');
    final isNetwork = getParam<bool>('isNetwork');
    final isNull = getParam('path').toString() == 'null';

    return Transform.scale(
      scale: 5,
      child: SizedBox(
        height: height,
        width: width,
        child: !(isNetwork as bool? ?? true)
            //TODO: replace with a placeholder image
            ? Image.asset(
                isNull ? 'assets/16.png' : params['path'].toString(),
              )
            : Image.network(params['path'].toString()),
      ),
    );
  }

  @override
  String get type => 'image';
}
