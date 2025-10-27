import 'package:flutter/material.dart';
import 'package:project/views/login/widgets/login_form.dart';
import 'package:project/core/theme/app_colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

 

  @override
  Widget build(BuildContext context) {
    // Usamos um Scaffold com cor de fundo
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack( // Usamos Stack para posicionar a navegação/ícones no topo
        children: [
          // 1. Header (Logotipo e Ícone do Usuário no topo, fora do card)
          Positioned(
            top: MediaQuery.of(context).padding.top + 15, // Ajuste para SafeArea
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/logo.png', height: 40), 
                // Ícone do usuário no canto superior direito
                const Icon(Icons.person, color: AppColors.icons, size: 30), 
              ],
            ),
          ),
          
          // 2. Card de Login Centralizado
          Center(
            child: SingleChildScrollView( // Para lidar com o teclado em dispositivos móveis
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400), // Limita largura em telas maiores
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppColors.form_fill,
                  borderRadius: BorderRadius.circular(30), // Bordas super arredondadas
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // O Logotipo menor que fica dentro do card, centralizado.
                    Image.asset('assets/logo.png', height: 60), 
                    const SizedBox(height: 40),
                    // O formulário de login
                    const LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

