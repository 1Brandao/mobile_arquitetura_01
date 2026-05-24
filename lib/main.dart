import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/core/app_routes.dart';
import 'package:mobile_arquitetura_02/core/session/user_session.dart';
import 'package:mobile_arquitetura_02/data/datasources/auth_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_02/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_02/data/repositories/auth_repository_impl.dart';
import 'package:mobile_arquitetura_02/data/repositories/product_repository_impl.dart';
import 'package:mobile_arquitetura_02/presentation/pages/home_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/login_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_detail_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_form_page.dart';
import 'package:mobile_arquitetura_02/presentation/pages/product_page.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mobile_arquitetura_02/presentation/viewmodels/product_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  final httpClient = http.Client();

  final productDatasource = ProductRemoteDatasource(httpClient);
  final productCache = ProductCacheDatasource();
  final productRepository = ProductRepositoryImpl(productDatasource, productCache);

  final authDatasource = AuthRemoteDatasource(httpClient);
  final authRepository = AuthRepositoryImpl(authDatasource);
  final userSession = UserSession();

  runApp(MyApp(
    productRepository: productRepository,
    authRepository: authRepository,
    userSession: userSession,
  ));
}

class MyApp extends StatelessWidget {
  final ProductRepositoryImpl productRepository;
  final AuthRepositoryImpl authRepository;
  final UserSession userSession;

  const MyApp({
    super.key,
    required this.productRepository,
    required this.authRepository,
    required this.userSession,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: userSession),
        ChangeNotifierProvider(
          create: (_) => AuthViewmodel(authRepository, userSession),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductViewmodel(productRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Products',
        initialRoute: AppRoutes.loginPage,
        routes: {
          AppRoutes.loginPage: (context) => const LoginPage(),
          AppRoutes.homePage: (context) => const HomePage(),
          AppRoutes.productsPage: (context) => const ProductPage(),
          AppRoutes.detailsPage: (context) => const ProductDetailPage(),
          AppRoutes.formPage: (context) => const ProductFormPage(),
        },
      ),
    );
  }
}
