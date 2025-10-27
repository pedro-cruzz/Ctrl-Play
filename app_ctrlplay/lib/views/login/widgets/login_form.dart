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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'Login bem-sucedido!',
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppColors.primary, // Cor de sucesso
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }

      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ), // Ícone de erro
                const SizedBox(width: 10),
                Text(
                  'Usuário não encontrado. Cadastre-se primeiro.',
                  style: AppTextStyles.button.copyWith(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppColors.accent, // Cor de aviso/erro
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  // Modal de cadastro
  void _showRegistrationDialog() {
    showDialog(
      context: context,
      // Usar um builder que retorna nosso novo widget de dialog
      builder: (_) => const _RegistrationDialog(
        userEmailKey: _userEmailKey,
        userPasswordKey: _userPasswordKey,
        userNameKey: _userNameKey,
        userUsernameKey: _userUsernameKey,
        userPhoneKey: _userPhoneKey,
      ),
    );
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Digite seu email';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                return 'Email inválido';
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
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Entrar', style: AppTextStyles.button),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Não tem uma conta? Crie uma',
            style: AppTextStyles.buttonLogin.copyWith(
              color: AppColors.textDark.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 12),

          // Botão Cadastrar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showRegistrationDialog,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Cadastrar', style: AppTextStyles.button),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegistrationDialog extends StatefulWidget {
  final String userEmailKey;
  final String userPasswordKey;
  final String userNameKey;
  final String userUsernameKey;
  final String userPhoneKey;

  const _RegistrationDialog({
    required this.userEmailKey,
    required this.userPasswordKey,
    required this.userNameKey,
    required this.userUsernameKey,
    required this.userPhoneKey,
  });

  @override
  State<_RegistrationDialog> createState() => _RegistrationDialogState();
}

class _RegistrationDialogState extends State<_RegistrationDialog> {
  // O Dialog agora gerencia os próprios controllers e a form key
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _usernameController;
  late final TextEditingController _passwordController;
  late final TextEditingController _phoneController;

  late final OutlineInputBorder _inputBorder;

  // A lógica de 'register' agora vive dentro do State do Dialog
  Future<void> _register() async {
    // A validação do form usa a _formKey deste State
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(widget.userEmailKey, _emailController.text.trim());
    await prefs.setString(
      widget.userPasswordKey,
      _passwordController.text.trim(),
    );
    await prefs.setString(widget.userNameKey, _nameController.text.trim());
    await prefs.setString(
      widget.userUsernameKey,
      _usernameController.text.trim(),
    );
    await prefs.setString(widget.userPhoneKey, _phoneController.text.trim());

    // Precisamos checar 'mounted' aqui também!
    if (mounted) {
      // Fechar o dialog
      Navigator.of(context).pop();

      // Mostrar o SnackBar na tela anterior (Login)
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
          backgroundColor: AppColors.primary,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Controllers são criados no initState
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();

    _inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    );
  }

  @override
  void dispose() {
    // Controllers são descartados no dispose
    _nameController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // A UI do Dialog é construída aqui
    return Dialog(
      backgroundColor: AppColors.form_fill,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.7,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.80,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey, // Usar a form key deste State
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Cadastrar',
                  style: AppTextStyles.title.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 20),
                // Campos do cadastro
                for (final field in [
                  {
                    'label': 'Nome',
                    'controller': _nameController,
                    'type': TextInputType.text,
                  },
                  {
                    'label': 'E-mail',
                    'controller': _emailController,
                    'type': TextInputType.emailAddress,
                  },
                  {
                    'label': 'Nome de Usuário',
                    'controller': _usernameController,
                    'type': TextInputType.text,
                  },
                  {
                    'label': 'Senha',
                    'controller': _passwordController,
                    'type': TextInputType.text,
                    'obscure': true,
                  },
                  {
                    'label': 'Telefone',
                    'controller': _phoneController,
                    'type': TextInputType.phone,
                  },
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
                        border: _inputBorder,
                        enabledBorder: _inputBorder,
                        focusedBorder: _inputBorder.copyWith(
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Campo obrigatório';
                        if (field['label'] == 'Senha' && value.length < 8)
                          return 'Mínimo 8 caracteres';
                        if (field['label'] == 'E-mail' &&
                            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value))
                          return 'E-mail inválido';
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
                        onPressed: _register, // Chama a função _register
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
