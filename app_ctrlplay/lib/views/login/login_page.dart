import 'package:flutter/material.dart';
import 'package:project/views/login/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  // Definição das cores para serem usadas globalmente
  static const Color primaryColor = Color(0xFF38006b); // Roxo escuro para fundo e botão secundário
  static const Color cardColor = Color(0xFFe0e0e0);   // Cinza claro para o card de formulário
  static const Color buttonPrimaryColor = Color(0xFFFF3D67); // Vermelho/Rosa vibrante para o botão principal

  @override
  Widget build(BuildContext context) {
    // Usamos um Scaffold com cor de fundo
    return Scaffold(
      backgroundColor: primaryColor,
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
                // Logotipo no canto superior esquerdo (assumindo que 'assets/logo.png' tem o logo roxo)
                Image.asset('assets/logo.png', height: 40), 
                // Ícone do usuário no canto superior direito
                const Icon(Icons.person, color: Colors.white, size: 30), 
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
                  color: cardColor,
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

