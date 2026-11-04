import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion_turistica/main.dart';

void main() {
  testWidgets('Carga el splash y navega al listado turístico',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AplicacionTuristicaApp());

    expect(find.text('Explora Ecuador'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();

    expect(find.text('Destinos turísticos'), findsOneWidget);
  });
}
