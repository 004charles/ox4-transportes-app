import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class TelaConvidarAmigos extends StatefulWidget {
  const TelaConvidarAmigos({Key? key}) : super(key: key);

  @override
  State<TelaConvidarAmigos> createState() => _TelaConvidarAmigosState();
}

class _TelaConvidarAmigosState extends State<TelaConvidarAmigos> {
  bool _permissionDenied = false;

  Future<void> _requestPermission() async {
    final status = await Permission.contacts.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      if (mounted) setState(() => _permissionDenied = true);
    } else if (status.isGranted) {
      if (mounted) setState(() => _permissionDenied = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Convidar Amigos')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primaryBlue.withOpacity(0.05),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard, color: AppColors.primaryBlue, size: 40),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Ganhe Descontos!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text('Convide amigos e ganhe bónus na próxima viagem.', style: TextStyle(color: AppColors.textGray, fontSize: 14)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_permissionDenied)
            Expanded(child: _buildPermissionDenied())
          else
            Expanded(child: _buildMockContactsList()),
        ],
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.contacts_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text('Acesso Negado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Para convidar amigos, precisamos acessar seus contactos. Por favor, ative nas configurações.', textAlign: TextAlign.center),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => openAppSettings(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Abrir Configurações', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockContactsList() {
    final List<Map<String, String>> mockContacts = [
      {'name': 'Carlos Manuel', 'phone': '923 111 222'},
      {'name': 'Ana Silva', 'phone': '921 555 777'},
      {'name': 'Pedro Kwanza', 'phone': '933 888 000'},
      {'name': 'Maria Antónia', 'phone': '921 000 123'},
      {'name': 'João do Zango', 'phone': '941 222 333'},
    ];

    return ListView.separated(
      itemCount: mockContacts.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final contact = mockContacts[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
            child: Text(contact['name']![0], style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          ),
          title: Text(contact['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(contact['phone']!),
          trailing: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Convite enviado para ${contact['name']}!')));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('Convidar', style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        );
      },
    );
  }
}
