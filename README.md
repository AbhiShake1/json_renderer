# json renderer

this is an early stage of a proof-of-concept library that renders widgets based on the schema that you define

## how does it work?

to begin with, you initialize the library and pass in the colors, components (AKA plugins) and other configurations.

```dart
JsonRenderer.init(
    colors: [
        {'primary': '0xff00ee'},
        ...
    ],
    plugins: [...],
);
```

*note that you can decide the schema yourself while creating the plugin widget*


### plugins

plugins can be passed during `JsonRenderer.init`, that are available through packages (future plan). also, new plugins can be created and added based on project requirements. plugins are special widgets that are compatible with `JsonWidget`. lets look at an example implementation of a custom plugin:

```dart
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
    final textStyle = params['text_style'];
    final fontStyle = textStyle?['font_style']?.toString();
    return Text(
      params['text']?.toString() ?? '',
      style: TextStyle(
        fontStyle: fontStyle == null ? null : enumByName(FontStyle.values, fontStyle),
        fontSize: textStyle?['font_size'] as double?,
      ),
    );
  }

  @override
  String get type => 'text';
}
```

the example demonstrates a basic plugin that renders text. lets break it down.

- a class is created that extends `JsonRendererPlugin`:

```dart
class JsonRendererTextPlugin extends JsonRendererPlugin
```

after extending from this class, which is provided by the library itself, there are some methods that need to be overridden to decide the schema and rendering process of the widget. parameters passed can be nested or put in a flat level and validated using `JsonRendererValidator`. if the key is not returned from `schema` getter, its not validated, allowing developers to go out of their way when needed.

- after that, there is the type getter that needs to be overridden:

```dart
String get type => 'text';
```

this indicates the key that will trigger this component render when it detects type: 'text' in json.

```json
{
  "type": "text",
  "text": "...",
  ...otherProps
}
```

in this json, when `type: text` is detected by `JsonRenderer`, the component with that type is added to the widget tree with parameters from json.

- finally, extending from the widget gives access to handy parameters, such as params. params is the parameter (map) which is being used to render the component. the desired parameters are expected and used to now render the component.

*note: always assume that all parameters are nullable and perform checks to handle their absence*