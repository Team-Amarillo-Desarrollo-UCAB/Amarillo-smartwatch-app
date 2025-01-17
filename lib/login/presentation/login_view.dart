import 'package:flutter/material.dart';
import '../../common/infrastructure/base_url.dart';
import '../../common/presentation/color_extension.dart';
import '../../common/presentation/common_widget/round_button.dart';
import '../../common/presentation/common_widget/round_textfield.dart';
import '../../order/presentation/order_history_wear_os.dart';
import '../infrastructure/login_service.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _checkSession() async {
    
    final token = await _authService.getToken(); 
    print("Token recuperado: $token");
    if (token != null) {
      if (BaseUrl().BASE_URL == BaseUrl().AMARILLO) {
      final isValid = await _authService.isValidToken(token);
      if (isValid) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrdersListScreen()),
        );
      }
    }
    // Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => const MainTabView()),
    //     );
  }
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, completa todos los campos.")),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa un correo válido.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await _authService.login(email, password);

    setState(() {
      _isLoading = false;
    });

    if (result.containsKey("error")) {
      print(result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Inicio de sesión exitoso!")),
      );
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OrdersListScreen()),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Image.asset(
                "assets/img/login.png",
                width: media.width,
                height: media.height,
                fit: BoxFit.cover,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: media.height * 0.03,
                    horizontal: media.width * 0.07,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: media.height * 0.09),
                      Image.asset(
                        "assets/img/app-logo.png",
                        width: media.width * 0.5,
                      ),
                      SizedBox(height: media.height * 0.0001),
                      Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                          color: TColor.primary,
                          fontSize: media.width * 0.07,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        "Ingresa tus datos",
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: media.width * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: media.height * 0.03),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "       Correo Electrónico",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: media.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      RoundTextfield(
                        hintText: "Tu correo",
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: media.height * 0.009),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "        Contraseña",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: media.width * 0.04,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      RoundTextfield(
                        hintText: "Contraseña",
                        controller: _passwordController,
                        obscureText: true,
                      ),
                      SizedBox(height: media.height * 0.04),
                      RoundButton(
                        title: "Iniciar Sesión",
                        onPressed: _login, 
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_isLoading)
          Container(
            color: TColor.black.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(TColor.primary),
              ),
            ),
          ),
      ],
    );
  }
}
