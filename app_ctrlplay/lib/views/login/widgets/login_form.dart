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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  // Credenciais Hardcoded para o projeto de faculdade (sempre funcionam como fallback)
  static const String _hardcodedEmail = 'aluno@faculdade.com';
  static const String _hardcodedPassword = 'senha123';

  // Chaves para SharedPreferences
  static const String _userEmailKey = 'simulated_user_email';
  static const String _userPasswordKey = 'simulated_user_password';
  static const String _userNameKey = 'simulated_user_name'; // Novo
  static const String _userUsernameKey = 'simulated_user_username'; // Novo
  static const String _userPhoneKey = 'simulated_user_phone'; // Novo

  // Função para simular o login/cadastro
  void _loginOrRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // 1. Tenta logar com credenciais hardcoded
    if (email == _hardcodedEmail && password == _hardcodedPassword) {
      _completeLogin(prefs, email);
      return;
    }

    // 2. Tenta logar com credenciais salvas localmente
    final savedEmail = prefs.getString(_userEmailKey);
    final savedPassword = prefs.getString(_userPasswordKey);

    if (email == savedEmail && password == savedPassword) {
      _completeLogin(prefs, email);
      return;
    }
    
    // 3. Login falhou: exibe mensagem de erro
    final savedEmailExists = savedEmail != null && savedEmail.isNotEmpty;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          savedEmailExists
              ? 'Não foi possível encontrar um usuário com esse email. Cadastre-se primeiro.'
              : 'Não foi possível encontrar um usuário com esse email. Cadastre-se primeiro.',
        ),
        backgroundColor: AppColors.accent,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Lógica de conclusão do login e navegação
  void _completeLogin(SharedPreferences prefs, String email) async {
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userEmail', email);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login bem-sucedido! Redirecionando...')),
    );
    
    await Future.delayed(const Duration(seconds: 1));
    // **IMPORTANTE**: Certifique-se que o seu `MaterialApp` tem uma rota '/home' definida
    Navigator.pushReplacementNamed(context, '/home');
  }

  // NOVO: Diálogo de Cadastro Simulado Completo
  void _showRegistrationDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final formKey = GlobalKey<FormState>();
    
    // Controladores temporários para o novo diálogo de cadastro
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    // Estilo de borda para os campos de texto dentro do diálogo
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );

    // Função interna para salvar o usuário e logar
    void registerAndLogin() async {
      if (formKey.currentState!.validate()) {
        // Salvar os dados mockados
        await prefs.setString(_userEmailKey, emailController.text.trim());
        await prefs.setString(_userPasswordKey, passwordController.text.trim());
        await prefs.setString(_userNameKey, nameController.text.trim());
        await prefs.setString(_userUsernameKey, usernameController.text.trim());
        await prefs.setString(_userPhoneKey, phoneController.text.trim());
        
        // Fecha o diálogo
        Navigator.of(context).pop(); 

        // INÍCIO DA ESTILIZAÇÃO DA MENSAGEM DE SUCESSO DE CADASTRO
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'Usuário cadastrado com sucesso!', 
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppColors.primary, // Cor de fundo principal
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        // FIM DA ESTILIZAÇÃO DA MENSAGEM DE SUCESSO DE CADASTRO

        // A navegação automática para /home foi removida. O usuário deve usar o form de login.
      }
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Simular Cadastro Completo', style: TextStyle(color: AppColors.primary)),
          contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Campo Nome
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        filled: true,
                        fillColor: AppColors.background2,
                        border: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Digite seu nome' : null,
                    ),
                    const SizedBox(height: 15),

                    // Campo E-mail
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        filled: true,
                        fillColor: AppColors.form_fill,
                        border: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Digite o e-mail';
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Campo Nome de Usuário
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nome de Usuário',
                        filled: true,
                        fillColor: AppColors.form_fill,
                        border: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Digite um nome de usuário' : null,
                    ),
                    const SizedBox(height: 15),

                    // Campo Senha
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha (mínimo 8 caracteres)',
                        filled: true,
                        fillColor: Color(0xFFB6B6B6),
                        border: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Digite a senha';
                        if (value.length < 8) return 'Mínimo 8 caracteres';
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Campo Número de Telefone
                    TextFormField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Número de Telefone',
                        filled: true,
                        fillColor: AppColors.background2,
                        border: inputBorder,
                        enabledBorder: inputBorder,
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Digite o telefone' : null,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: AppColors.textDark)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Cadastrar', style: AppTextStyles.button.copyWith(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
              ),
              onPressed: registerAndLogin,
            ),
          ],
        );
      },
    );
    
    // Limpar controladores após fechar o diálogo
    nameController.dispose();
    emailController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Estilo de borda para os campos de texto (pílula)
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none, // Remove a borda padrão
    );

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de email
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: AppColors.textDark),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: AppColors.textDark),
              filled: true,
              fillColor: AppColors.background2, // Cor de preenchimento dos campos
              border: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: const BorderSide(color: AppColors.primary, width: 2), 
              ),
              enabledBorder: inputBorder,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite seu email';
              }
              final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
              if (!emailRegex.hasMatch(value)) {
                return 'Digite um email válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Campo de senha
          TextFormField(
            controller: _passwordController,
            style: const TextStyle(color: AppColors.textDark),
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Senha',
              labelStyle: const TextStyle(color: AppColors.textDark),
              filled: true,
              fillColor: AppColors.background2,
              border: inputBorder,
              focusedBorder: inputBorder.copyWith(
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              enabledBorder: inputBorder,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Digite sua senha';
              }
              if (value.length < 8) {
                return 'A senha deve ter pelo menos 8 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Botão de login "Entrar" - Rosa vibrante e arredondado
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _loginOrRegister, // Tenta logar
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent, // Cor de fundo vermelha/rosa
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Borda arredondada
                ),
                elevation: 5,
              ),
              child: const Text(
                'Entrar',
                style: AppTextStyles.button,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Separador "Não tem um conta? Crie uma"
          Text(
            'Não tem uma conta? Crie uma',
            style: AppTextStyles.buttonLogin.copyWith(color: AppColors.textDark.withOpacity(0.7)),
          ),
          const SizedBox(height: 15),

          // Botão "Cadastrar" (usa a cor principal do seu tema)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showRegistrationDialog, // Chama o novo e completo diálogo de cadastro
              child: const Text('Cadastrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary, // Cor de fundo roxa
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30), // Borda arredondada
                ),
                elevation: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

