import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/core/app_routes.dart';
import 'package:mobile_arquitetura_02/core/session/user_session.dart';
import 'package:mobile_arquitetura_02/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/repositories/auth_repository_impl.dart';
import 'package:mobile_arquitetura_02/data/repositories/product_repository_impl.dart';
import 'package:mobile_arquitetura_02/domain/repositories/auth_repository.dart';
import 'package:mobile_arquitetura_02/domain/repositories/product_repository.dart';
import 'package:mobile_arquitetura_02/presentation/pages/home_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/login_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_detail_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_form_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_page.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final http.Client _httpClient;
  late final UserSession _userSession;
  late final ProductRepository _productRepository;
  late final AuthRepository _authRepository;

  // Rotas que exigem autenticação prévia
  static const _protectedRoutes = {
    AppRoutes.homePage,
    AppRoutes.productsPage,
    AppRoutes.detailsPage,
    AppRoutes.formPage,
  };

  @override
  void initState() {
    super.initState();
    _httpClient = http.Client();
    _userSession = UserSession();

    final productDatasource = ProductRemoteDatasource(_httpClient);
    final productCache = ProductCacheDatasource();
    _productRepository = ProductRepositoryImpl(productDatasource, productCache);

    final authDatasource = AuthRemoteDatasource(_httpClient);
    _authRepository = AuthRepositoryImpl(authDatasource);
  }

  @override
  void dispose() {
    _httpClient.close();
    super.dispose();
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    final name = settings.name;

    // Guard: rotas protegidas redirecionam para login se não autenticado
    if (_protectedRoutes.contains(name) && !_userSession.isLoggedIn) {
      return MaterialPageRoute(
        builder: (_) => const LoginPage(),
        settings: const RouteSettings(name: AppRoutes.loginPage),
      );
    }

    switch (name) {
      case AppRoutes.loginPage:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case AppRoutes.homePage:
        return MaterialPageRoute(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case AppRoutes.productsPage:
        return MaterialPageRoute(
          builder: (_) => const ProductPage(),
          settings: settings,
        );
      case AppRoutes.detailsPage:
        return MaterialPageRoute(
          builder: (_) => const ProductDetailPage(),
          settings: settings,
        );
      case AppRoutes.formPage:
        return MaterialPageRoute(
          builder: (_) => const ProductFormPage(),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _userSession),
        ChangeNotifierProvider(
          create: (_) => AuthViewmodel(_authRepository, _userSession),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductViewmodel(_productRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Products',
        initialRoute: AppRoutes.loginPage,
        onGenerateRoute: _generateRoute,
      ),
    );
  }
}
