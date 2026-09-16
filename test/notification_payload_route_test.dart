import 'package:diaster_ngo_app/features/alerts/view/alert_details_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('alert details screen can be constructed from notification payload data', () {
    const screen = AlertDetailsScreen(
      alertId: 'alert_123',
      title: 'Earthquake warning',
      description: 'Strong tremors reported near the city.',
      severity: 'high',
      source: 'USGS',
      createdAt: null,
    );

    expect(screen.alertId, 'alert_123');
    expect(screen.title, 'Earthquake warning');
    expect(screen.severity, 'high');
  });
}
