import 'package:flutter_test/flutter_test.dart';
import 'package:creador_personaje_rpg/main.dart';

void main() {
  testWidgets('Carga inicial de la app y Pantalla 1', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('CREACIÓN'), findsOneWidget);
    expect(find.text('Identidad'), findsOneWidget);
  });
}
