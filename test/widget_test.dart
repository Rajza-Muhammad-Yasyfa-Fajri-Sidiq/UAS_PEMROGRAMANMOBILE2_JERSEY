import 'package:flutter_test/flutter_test.dart';
import 'package:jersey/main.dart';
import 'package:jersey/state/auth_controller.dart';

void main() {
  testWidgets('App builds', (tester) async {
    final auth = AuthController(); // ga usah init firebase di test ini
    await tester.pumpWidget(JerseyHubApp(auth: auth));
    await tester.pump(); // biar settle 1 frame
  });
}
