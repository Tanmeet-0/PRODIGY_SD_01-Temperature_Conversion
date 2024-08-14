import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "temperature_conversion.dart";

// Todos
// 1. add enum for temp types
// 2. add animation when numbers change

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    var colour_scheme = ColorScheme.dark();
    var app_theme = ThemeData(useMaterial3: true, colorScheme: colour_scheme);
    app_theme = app_theme.copyWith(
        textTheme: app_theme.textTheme.apply(
            bodyColor: colour_scheme.primary,
            displayColor: colour_scheme.primary));

    return MaterialApp(
      title: "Temperature Conversion",
      home: MyHomePage(),
      theme: app_theme,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  double temperature_measurement_in_kelvin = 0;
  double temperature_measurement_in_celsius = 0;
  double temperature_measurement_in_fahrenheit = 0;
 

  void on_kelvin_input(String kelvin_input) {
    double kelvin_measurement = double.parse(kelvin_input);
    double celsius_measurement = convert_kelvin_to_celsius(kelvin_measurement);
    double fahrenheit_measurement =
        convert_celsius_to_fahrenheit(celsius_measurement);
    setState(() {
      temperature_measurement_in_kelvin = kelvin_measurement;
      temperature_measurement_in_celsius = celsius_measurement;
      temperature_measurement_in_fahrenheit = fahrenheit_measurement;
    });
  }
  void on_celsius_input(String celsius_input) {
    double celsius_measurement = double.parse(celsius_input);
    double kelvin_measurement = convert_celsius_to_kelvin(celsius_measurement);
    double fahrenheit_measurement =
        convert_celsius_to_fahrenheit(celsius_measurement);
    setState(() {
      temperature_measurement_in_kelvin = kelvin_measurement;
      temperature_measurement_in_celsius = celsius_measurement;
      temperature_measurement_in_fahrenheit = fahrenheit_measurement;
    });
  }

  void on_fahrenheit_input(String fahrenheit_input) {
    double fahrenheit_measurement = double.parse(fahrenheit_input);
    double celsius_measurement =
        convert_fahrenheit_to_celsius(fahrenheit_measurement);
    double kelvin_measurement = convert_celsius_to_kelvin(celsius_measurement);
    setState(() {
      temperature_measurement_in_kelvin = kelvin_measurement;
      temperature_measurement_in_celsius = celsius_measurement;
      temperature_measurement_in_fahrenheit = fahrenheit_measurement;
    });
  }

  @override
  Widget build(BuildContext context) {
    final context_theme = Theme.of(context);
    final title_text_style = context_theme.textTheme.displayMedium;
    final table_heading_text_style = context_theme.textTheme.displaySmall;
    final app_bar_bg_color = context_theme.colorScheme.onPrimary;
    const double space_between_rows = 50;
    const blank_separating_row = TableRow(
      children: [
        SizedBox(
          height: space_between_rows,
        ),
        SizedBox(
          height: space_between_rows,
        ),
        SizedBox(
          height: space_between_rows,
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: app_bar_bg_color,
        toolbarHeight: 80,
        title: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              "Temperature Conversion",
              style: title_text_style,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 150),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  Text(
                    "Temperature Scale",
                    textAlign: TextAlign.center,
                    style: table_heading_text_style,
                  ),
                  Text(
                    "Input",
                    textAlign: TextAlign.center,
                    style: table_heading_text_style,
                  ),
                  Text(
                    "Output",
                    textAlign: TextAlign.center,
                    style: table_heading_text_style,
                  ),
                ],
              ),
              blank_separating_row,
              TemperatureTableRow(
                  temperature_scale: "Kelvin",
                  temperature_measurement:
                      temperature_measurement_in_kelvin.toStringAsFixed(2),
                  on_submit_callback: on_kelvin_input,
                  theme: context_theme),
              blank_separating_row,
              TemperatureTableRow(
                  temperature_scale: "Celsius",
                  temperature_measurement:
                      temperature_measurement_in_celsius.toStringAsFixed(2),
                  on_submit_callback: on_celsius_input,
                  theme: context_theme),
              blank_separating_row,
              TemperatureTableRow(
                  temperature_scale: "Fahrenheit",
                  temperature_measurement:
                      temperature_measurement_in_fahrenheit.toStringAsFixed(2),
                  on_submit_callback: on_fahrenheit_input,
                  theme: context_theme),
            ],
          ),
        ),
      ),
    );
  }
}

TableRow TemperatureTableRow(
    {required String temperature_scale,
    required String temperature_measurement,
    required void Function(String) on_submit_callback,
    required ThemeData theme}) {
  final text_style = theme.textTheme.displaySmall;
  final TextEditingController text_controller = TextEditingController();
  var degree_symbol = "°";
  if (temperature_scale == "Kelvin") {
    degree_symbol = "";
  }
  return TableRow(
    children: [
      Text(
        textAlign: TextAlign.center,
        temperature_scale,
        style: text_style,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: theme.colorScheme.primary)),
            focusedBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 3, color: theme.colorScheme.primary)),
            contentPadding: EdgeInsets.all(10),
            fillColor: theme.colorScheme.onPrimary,
            filled: true,
          ),
          textAlign: TextAlign.center,
          controller: text_controller,
          keyboardType:
              TextInputType.numberWithOptions(decimal: true, signed: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r"(^-?)([0-9]*)(\.?)([0-9]*)"))
          ],
          // regex explanation - 4 groups represented by ()
          // first group : at the beginning of the string, '-' symbol 0 or 1 times
          // second group : 0-9 digits 0 or more times
          // third group : '.' symbol 0 or 1 times, '\' used to escape '.'
          // fourth group : 0-9 digits 0 or more times
          style: text_style,
          onFieldSubmitted: (value) {
            if (value != "") {
              on_submit_callback(value);
            }
            text_controller.clear();
          },
        ),
      ),
      DecoratedBox(
        decoration: BoxDecoration(),
        child: Text(
          textAlign: TextAlign.center,
          "$temperature_measurement $degree_symbol${temperature_scale[0]}",
          style: text_style,
        ),
      ),
    ],
  );
}
