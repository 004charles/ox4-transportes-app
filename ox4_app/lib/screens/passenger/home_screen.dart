import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ox4_app/theme/colors.dart';

class TelaPrincipalPassageiro extends StatefulWidget {
  const TelaPrincipalPassageiro({Key? key}) : super(key: key);

  @override
  State<TelaPrincipalPassageiro> createState() => _TelaPrincipalPassageiroState();
}

class _TelaPrincipalPassageiroState extends State<TelaPrincipalPassageiro> {
  bool _isGpsEnabled = true;

  @override
  void initState() {
    super.initState();
    _checkGps();
  }

  void _checkGps() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    setState(() {
      _isGpsEnabled = enabled;
    });
    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if(mounted){
        setState(() {
          _isGpsEnabled = status == ServiceStatus.enabled;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar: Logo + Burger Menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OX4',
                      style: TextStyle(
                        color: AppColors.primaryBlue, // A usar o azul ou a cor primária!
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: -1.0,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, size: 30, color: Colors.black87),
                      onPressed: () {
                        Navigator.pushNamed(context, '/full_menu');
                      },
                    )
                  ],
                ),
                
                // Alerta estilo Yango - Ativar Localização
                if (!_isGpsEnabled)
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.near_me, color: Colors.black87, size: 28),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Activa os serviços de\nlocalização', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, height: 1.1)),
                                  const SizedBox(height: 5),
                                  Text('Não conseguimos ver onde estás', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/busca_destino');
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Introduzir a\nmorada', textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, height: 1.1)),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  Geolocator.openLocationSettings();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryBlue, // Primary
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Activar', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                const SizedBox(height: 10),
                
                // Location Button
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Text(
                        'A tua localização',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Icon(Icons.chevron_right, size: 24),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),

                // Large Feature Cards
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Goes to Destination Picker
                          Navigator.pushNamed(context, '/busca_destino');
                        },
                        child: Container(
                          height: 140,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: const Icon(Icons.shopping_bag_rounded, color: Colors.orange, size: 35),
                              ),
                              const Spacer(),
                              const Text('Frete', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/busca_destino');
                        },
                        child: Container(
                          height: 140,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15)
                                ),
                                child: Icon(Icons.directions_car, color: AppColors.primaryBlue, size: 35),
                              ),
                              const Spacer(),
                              const Text('Viagens', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                              const Text('a partir de 3 min.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),

                // Where to? Search Bar
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/busca_destino');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))
                      ]
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.directions_car_outlined, color: Colors.grey),
                            const SizedBox(width: 15),
                            const Text('Para onde?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                          child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                        )
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),

                // Recent Places List
                _buildRecentPlace(Icons.school, 'Instituto Politécnico', 'Talatona, Luanda', '1 h 20 min'),
                _buildRecentPlace(Icons.location_on, 'Zango I', 'Município Viana, Luanda', '1 h 10 min'),
                _buildRecentPlace(Icons.shopping_bag, 'Belas Shopping', 'Talatona, Luanda', '6 min'),

                const SizedBox(height: 30),

                // Promo Banner Status Like Whatsapp
                GestureDetector(
                  onTap: () {
                    // Substituindo o Modal anterior pela nova navegação de Ecrã FullScreen
                    Navigator.pushNamed(context, '/frete_status');
                  },
                  child: Container(
                    width: double.infinity,
                    height: 140, // Altura maior para vislumbrar o motorista
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/ox4_entregador.jpg'), 
                        fit: BoxFit.cover,
                      ),
                      color: const Color(0xFF63413E), // Fallback
                    ),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                            )
                          ),
                        ),
                        Positioned(
                          left: 20,
                          bottom: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('OX4 ENTREGA P/ TUDO', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, height: 1.1)),
                              SizedBox(height: 5),
                              Text('Ver o modo Expresso', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentPlace(IconData icon, String title, String subtitle, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.grey[400]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 12)),
        ],
      ),
    );
  }
}
