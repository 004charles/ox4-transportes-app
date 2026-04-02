import 'package:flutter/material.dart';
import 'dart:async';

class FreteStatusScreen extends StatefulWidget {
  const FreteStatusScreen({Key? key}) : super(key: key);

  @override
  State<FreteStatusScreen> createState() => _FreteStatusScreenState();
}

class _FreteStatusScreenState extends State<FreteStatusScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  
  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), // Status dura 5 segundos
    )..addListener(() {
        setState(() {});
      })..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pop(context); // Volta automaticamente quando a barra arrebentar
        }
      });
      
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (_) => _progressController.stop(),
        onTapUp: (_) => _progressController.forward(),
        child: Stack(
          children: [
            // Imagem Principal (Background)
            Positioned.fill(
              child: Image.asset(
                'assets/images/ox4_entregador.jpg',
                fit: BoxFit.cover,
              ),
            ),
            
            // Degradê negro no topo para os botões aparecerem
            Positioned(
              top: 0, left: 0, right: 0,
              height: 150,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                ),
              ),
            ),
            
            // Degradê na Base para os textos aparecerem
            Positioned(
              bottom: 0, left: 0, right: 0,
              height: 250,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black.withOpacity(0.9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                ),
              ),
            ),

            // Barra de Status estilo WhatsApp no topo
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: _progressController.value,
                              backgroundColor: Colors.grey[700],
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              minHeight: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Cabeçalho (Botão voltar e Foto mini)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blueAccent, // Ou OX4 Blue se exportares
                          child: Icon(Icons.local_shipping, size: 20, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'OX4 Entregas Premium',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Texto Educativo Inferior
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'OX4 Entrega para tudo!',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Os nossos motoristas carregam os seus items mais sensíveis até 30Kg, com as rotas mais eficientes de Luanda garantindo máxima segurança via Rastreio GPS.\n\nAcede à tab "Frete" no momento de confirmar a viagem para consultar o preço dinâmico e invocar uma viatura de carga.',
                      style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            // "Arraste para saber mais" na pontinha
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.keyboard_arrow_up, color: Colors.white70),
                    Text('Mais detalhes', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
