import 'package:go_router/go_router.dart';
import '../screens/home/home_screen.dart';
import '../screens/create/create_screen.dart';
import '../screens/preview/preview_screen.dart';
import '../screens/group/create_group_screen.dart';

/// 應用路由配置
/// 定義所有頁面的路徑和轉場動畫
final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateScreen(),
    ),
    GoRoute(
      path: '/preview',
      builder: (context, state) => const PreviewScreen(),
    ),
    GoRoute(
      path: '/create-group',
      builder: (context, state) => const CreateGroupScreen(),
    ),
  ],
);