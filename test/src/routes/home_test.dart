import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

void main() {
  test('set test', () {
    final print = Logger(
        printer: PrettyPrinter(
      methodCount: 0,
    )).d;
    // final print = (e) => log(e.toString());

    Set a = {};
    a.add('a');
    print('$a');

    Set b = a;
    print('$b');
    b.add('b');

    print(a == b);

    Set c = b;
    print(c);

    Set bb = {}..addAll(a);
    print('bb : $bb');

    print(bb == b);
  });
}
