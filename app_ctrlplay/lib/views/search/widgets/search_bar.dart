import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final void Function(String) onSearch; // callback quando pesquisar
  final TextEditingController controller;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: controller, // 🔹 aqui usamos o controller
                decoration: const InputDecoration(
                  hintText: 'Pesquise por filmes ou séries...',
                  border: InputBorder.none,
                ),
                onSubmitted: onSearch, // 🔹 dispara ao apertar Enter
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF4C1E8E),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.all(4),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () => onSearch(controller.text), // 🔹 dispara ao clicar no botão
            ),
          ),
        ],
      ),
    );
  }
}
