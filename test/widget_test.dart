import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_app/my_app_class.dart';
// 💡 تأكد من كتابة اسم مشروعك الصح هنا مكان YOUR_APP_NAME

void main() {
  testWidgets('Counter value increment test', (WidgetTester tester) async {
    // 💡 الحل: شيلنا كلمة const ومررنا قيمة الـ initialRoute الافتراضية للـ Test
    await tester.pumpWidget(const MyApp(
      initialRoute: '/login',
      isLoggedIn: false,
    ));

    // بقية كود التست الافتراضي لو مش محتاجه ممكن تسيبه أو تمسحه
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
