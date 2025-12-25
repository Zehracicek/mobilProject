import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../screens/home_page.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String home = '/home';
  static const String noteDetail = '/note-detail';
  static const String addNote = '/add-note';
  static const String editNote = '/edit-note';
  static const String categories = '/categories';
  static const String settings = '/settings';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
        routes: [
          GoRoute(
            path: 'register',
            name: 'register',
            builder: (context, state) => const RegisterPage(),
          ),
        ],
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'note-detail/:id',
            name: 'noteDetail',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return Scaffold(
                appBar: AppBar(title: Text('Not Detayı - $id')),
                body: const Center(
                  child: Text('Not detay sayfası CRUD ekibi tarafından implement edilecek'),
                ),
              );
            },
          ),
          GoRoute(
            path: 'add-note',
            name: 'addNote',
            builder: (context, state) => Scaffold(
              appBar: AppBar(title: const Text('Yeni Not')),
              body: const Center(
                child: Text('Not ekleme sayfası CRUD ekibi tarafından implement edilecek'),
              ),
            ),
          ),
          GoRoute(
            path: 'edit-note/:id',
            name: 'editNote',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return Scaffold(
                appBar: AppBar(title: Text('Not Düzenle - $id')),
                body: const Center(
                  child: Text('Not düzenleme sayfası CRUD ekibi tarafından implement edilecek'),
                ),
              );
            },
          ),
          GoRoute(
            path: 'categories',
            name: 'categories',
            builder: (context, state) => Scaffold(
              appBar: AppBar(title: const Text('Kategoriler')),
              body: const Center(
                child: Text('Kategori sayfası geliştirilecek'),
              ),
            ),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => Scaffold(
              appBar: AppBar(title: const Text('Ayarlar')),
              body: const Center(
                child: Text('Ayarlar sayfası geliştirilecek'),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
