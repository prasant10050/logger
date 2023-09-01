import 'dart:convert';

import 'log_event.dart';

/// An abstract handler of log events.
///
/// A log printer creates and formats the output, which is then sent to
/// [LogOutput]. Every implementation has to use the [LogPrinter.log]
/// method to send the output.
///
/// You can implement a `LogPrinter` from scratch or extend [PrettyPrinter].
abstract class LogPrinter {
  Future<void> init() async {}

  /// Is called every time a new [LogEvent] is sent and handles printing or
  /// storing the message.
  String log(LogEvent event);

  Future<void> destroy() async {}

  String stringifyMessage(dynamic message) {
    if (message is String) return message;

    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      var encoder = JsonEncoder.withIndent('  ', toEncodable);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }

  /// Handles any object that is causing JsonEncoder() problems.
  Object? toEncodable(dynamic object) {
    return object.toString();
  }
}
