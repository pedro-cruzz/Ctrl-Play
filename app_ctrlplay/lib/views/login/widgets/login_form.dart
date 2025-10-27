import 'package:flutter/material.dart';
import 'package:project/core/theme/app_colors.dart';
import 'package:project/core/theme/app_text_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // Credenciais hardcoded
  static const _hardcodedEmail = 'aluno@fepi';
  static const _hardcodedPassword = 'senha123';

  // Keys SharedPreferences
  static const _userEmailKey = 'simulated_user_email';
  static const _userPasswordKey = 'simulated_user_password';
  static const _userNameKey = 'simulated_user_name';
  static const _userUsernameKey = 'simulated_user_username';
  static const _userPhoneKey = 'simulated_user_phone';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString(_userEmailKey);
    final savedPassword = prefs.getString(_userPasswordKey);

    if ((email == _hardcodedEmail && password == _hardcodedPassword) ||
        (email == savedEmail && password == savedPassword)) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', email);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login bem-sucedido!')),
      );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não encontrado. Cadastre-se primeiro.'),
          backgroundColor: AppColors.accent,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  // Modal de cadastro estilizado igual ao LoginForm
  void _showRegistrationDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final phoneController = TextEditingController();

    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );

    Future<void> register() async {
      if (!formKey.currentState!.validate()) return;

      await prefs.setString(_userEmailKey, emailController.text.trim());
      await prefs.setString(_userPasswordKey, passwordController.text.trim());
      await prefs.setString(_userNameKey, nameController.text.trim());
      await prefs.setString(_userUsernameKey, usernameController.text.trim());
      await prefs.setString(_userPhoneKey, phoneController.text.trim());

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Text('Usuário cadastrado com sucesso!',
                  style: AppTextStyles.button.copyWith(color: Colors.white)),
            ],
          ),
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }

    await showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.form_fill,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Cadastrar', style: AppTextStyles.title.copyWith(color: AppColors.primary)),
                  const SizedBox(height: 20),
                  // Campos do cadastro
                  for (final field in [
                    {'label': 'Nome', 'controller': nameController, 'type': TextInputType.text},
                    {'label': 'E-mail', 'controller': emailController, 'type': TextInputType.emailAddress},
                    {'label': 'Nome de Usuário', 'controller': usernameController, 'type': TextInputType.text},
                    {'label': 'Senha', 'controller': passwordController, 'type': TextInputType.text, 'obscure': true},
                    {'label': 'Telefone', 'controller': phoneController, 'type': TextInputType.phone},
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextFormField(
                        controller: field['controller'] as TextEditingController,
                        keyboardType: field['type'] as TextInputType,
                        obscureText: field['obscure'] == true,
                        decoration: InputDecoration(
                          labelText: field['label'] as String,
                          filled: true,
                          fillColor: AppColors.background2,
                          border: inputBorder,
                          enabledBorder: inputBorder,
                          focusedBorder: inputBorder.copyWith(
                              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Campo obrigatório';
                          if (field['label'] == 'Senha' && value.length < 8) return 'Mínimo 8 caracteres';
                          if (field['label'] == 'E-mail' &&
                              !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'E-mail inválido';
                          return null;
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Botões grandes centralizados
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text('Cadastrar', style: AppTextStyles.button),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Limpeza
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: AppColors.background2,
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                  borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Digite seu email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Email inválido';
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Senha
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Senha',
              filled: true,
              fillColor: AppColors.background2,
              border: inputBorder,
              enabledBorder: inputBorder,
              focusedBorder: inputBorder.copyWith(
                  borderSide: const BorderSide(color: AppColors.primary, width: 2)),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Digite sua senha';
              if (value.length < 8) return 'A senha deve conter 8 caracteres';
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Botão Entrar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Entrar', style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Não tem uma conta? Crie uma',
            style: AppTextStyles.buttonLogin.copyWith(color: AppColors.textDark.withOpacity(0.7)),
          ),
          const SizedBox(height: 12),

          // Botão Cadastrar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showRegistrationDialog,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Cadastrar', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }
}
