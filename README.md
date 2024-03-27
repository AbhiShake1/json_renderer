# json renderer

this is an early stage of a proof-of-concept library that renders widgets based on the schema that you create

## how does it work?

to begin with, you initialize the library and pass in the colors, components and other configurations.

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