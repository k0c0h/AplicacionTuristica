import 'package:flutter_test/flutter_test.dart';
import 'package:aplicacion_turistica/main.dart';

void main() {
  testWidgets('Carga de AplicacionTuristicaApp y DetallePantalla',
      (WidgetTester tester) async {
    await tester.pumpWidget(const AplicacionTuristicaApp());
    await tester.pumpAndSettle();

    // Verifica que se muestre el contenido del detalle del lugar turístico
    expect(find.text('Acerca del lugar'), findsOneWidget);
  });
}
