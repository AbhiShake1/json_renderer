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
    final height = params['height'];
    final width = params['width'];
    final isNetwork = params['isNetwork'];
    final isNull = params['path'].toString() == 'null';

    return Transform.scale(
      scale: 5,
      child: SizedBox(
        height: height as double?,
        width: width as double?,
        child: !(isNetwork as bool? ?? true)
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
