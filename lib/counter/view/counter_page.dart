import 'package:flutter/material.dart';
import 'package:json_renderer_test/counter/view/renderer_plugins/column.dart';
import 'package:json_renderer_test/counter/view/renderer_plugins/text.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CounterView();
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    JsonRenderer.init(
      plugins: [
        JsonRendererTextPlugin(),
        JsonRendererColumnPlugin(),
      ],
    );
    return Scaffold(
      appBar: AppBar(title: const Text('abc')),
      body: Center(
        child: JsonRenderer(
          const {
            'type': 'column',
            'children': [
              {
                'type': 'text',
                'text': 'abcde',
                'text_style': {
                  'font_style': 'italic',
                  'font_size': 36.0,
                },
              },
              {
                'type': 'text',
                'text': 'abcd',
                'text_style': {
                  'font_style': 'italic',
                  'font_size': 24.0,
                },
              },
            ],
          },
        ),
      ),
    );
  }
}

class JsonRenderer extends StatelessWidget {
  JsonRenderer(this.json, {super.key})
      : assert(
          _initialized,
          'must call JsonRenderer.init before using it',
        ),
        assert(json['type'] != null, 'type is required for json');

  static bool _initialized = false;
  static late List<JsonRendererPlugin> _plugins;

  static void init({required List<JsonRendererPlugin> plugins}) {
    _plugins = plugins;
    _initialized = true;
  }

  final Map<String, dynamic> json;

  @override
  Widget build(BuildContext context) {
    return _plugins.firstWhere(
      (p) => p.type == json['type'],
      orElse: () => throw Exception('type ${json['type']} not found'),
    ).._state.params = json;
  }
}

typedef JsonRendererSchema = Map<String, JsonRendererValidator>;

class JsonRendererValidator {
  JsonRendererValidator._();
  factory JsonRendererValidator.ofType(Type type) {
    return JsonRendererValidator._()..type = type;
  }
  factory JsonRendererValidator.fromMap(Map<String, JsonRendererValidator> map) {
    return JsonRendererValidator._()
      ..type = Map
      .._map = map;
  }
  void validate(dynamic data, String fieldName) {
    final dataType = data.runtimeType.toString().replaceAll(RegExp('<.*>'), '');
    final typeType = type.toString().replaceAll(RegExp('<.*>'), '');
    if (dataType != typeType && !dataType.contains(typeType)) {
      throw FormatException(
        '$fieldName was expected to be of type $typeType. Instead got $dataType',
      );
    }
  }

  Type? type;
  Map<String, JsonRendererValidator>? _map;
}

abstract class JsonRendererPlugin extends StatefulWidget {
  JsonRendererPlugin({super.key});
  final _JsonRendererPluginState _state = _JsonRendererPluginState();
  JsonRendererSchema get schema;
  String get type;
  Widget build(BuildContext context);
  @override
  State<JsonRendererPlugin> createState() => _state;

  @protected
  Map<String, dynamic> get params {
    assert(_state._params != null, '');
    return _state._params!;
  }

  @protected
  E enumByName<E extends Enum>(Iterable<E> values, String name) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    throw ArgumentError.value(
      name,
      'name',
      'No enum value with name $name. Possible values are ${values.map((e) => e.name)}',
    );
  }
}

class _JsonRendererPluginState extends State<JsonRendererPlugin> {
  @override
  Widget build(BuildContext context) => widget.build(context);
  Map<String, dynamic>? _params;

  set params(Map<String, dynamic> p) {
    // assert(_params == null, '');
    _validateParams(p);
    _params = p;
  }

  void _validateParams(
    Map<String, dynamic> p, [
    JsonRendererSchema? s,
  ]) {
    for (final MapEntry(:key, value: type) in (s ?? widget.schema).entries) {
      if (p[key] != null) {
        if (type._map != null) {
          _validateParams(p[key] as Map<String, dynamic>, type._map);
        } else {
          type.validate(p[key], key);
        }
      }
    }
  }
}
