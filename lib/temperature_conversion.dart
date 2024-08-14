double convert_kelvin_to_celsius(double temperature_measurement_in_kelvin) {
  return temperature_measurement_in_kelvin - 273.15;
}

double convert_celsius_to_kelvin(double temperature_measurement_in_celsius) {
  return temperature_measurement_in_celsius + 273.15;
}

double convert_fahrenheit_to_celsius(
    double temperature_measurement_in_fahrenheit) {
  return (temperature_measurement_in_fahrenheit - 32) * 5 / 9;
}

double convert_celsius_to_fahrenheit(
    double temperature_measurement_in_celsius) {
  return temperature_measurement_in_celsius * 9 / 5 + 32;
}
