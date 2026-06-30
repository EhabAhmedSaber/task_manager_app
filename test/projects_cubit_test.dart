import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager_app/features/projects/presentation/bloc/projects_cubit.dart';
import 'package:task_manager_app/features/projects/presentation/bloc/projects_state.dart'; // 💡 تأكد من وجود الـ import ده لـ Hive.init

void main() {
  // تفعيل بيئة اختبار فلاتر
  TestWidgetsFlutterBinding.ensureInitialized();

  // 🌟 التعديل السحري: تجهيز الـ Hive وفتح الـ Box قبل بدء التستات
  setUpAll(() async {
    // تشغيل الـ Hive في الميموري المؤقتة بتاعة التست
    Hive.init('.');
    await Hive.openBox('projects_box');
  });

  // تنظيف الـ Hive وقفل الـ Box بعد ما التستات كلها تخلص
  tearDownAll(() async {
    await Hive.close();
  });

  group('ProjectsCubit Tests', () {
    // 🧪 التست الأول: التأكد من أن الحالة الابتدائية هي ProjectsInitial
    test('الحالة الابتدائية يجب أن تكون ProjectsInitial', () {
      final projectsCubit = ProjectsCubit();
      expect(projectsCubit.state, isA<ProjectsInitial>());
      projectsCubit.close();
    });

    // 🧪 التست الثاني: اختبار دالة الـ clearProjects وتصفير الشاشة
    blocTest<ProjectsCubit, ProjectsState>(
      'عند استدعاء clearProjects يجب أن يبعث الكيوبيت حالة ProjectsInitial',
      build: () => ProjectsCubit(),
      act: (cubit) => cubit.clearProjects(),
      expect: () => [isA<ProjectsInitial>()],
    );

    // 🧪 التست الثالث: اختبار حماية الإيميل الفاضي في fetchProjects
    blocTest<ProjectsCubit, ProjectsState>(
      'عند استدعاء fetchProjects بإيميل فاضي يجب أن يعرض لستة فاضية فوراً لحماية البيانات',
      build: () => ProjectsCubit(),
      act: (cubit) => cubit.fetchProjects(''),
      expect: () => [
        isA<ProjectsSuccess>(),
      ],
    );
  });
}
