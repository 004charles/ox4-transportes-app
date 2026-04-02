import 'dart:io';
import 'package:flutter/material.dart';
import 'package:ox4_app/theme/colors.dart';
import 'package:ox4_app/services/auth_service.dart';
import 'package:image_picker/image_picker.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({Key? key}) : super(key: key);

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  bool _isLoading = true;
  bool _isEditing = false;
  Map<String, dynamic>? _userData;
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPerfil();
  }

  Future<void> _loadPerfil() async {
    try {
      final data = await AuthService.getPerfil();
      if (data != null && mounted) {
        setState(() {
          _userData = data;
          _nameController.text = data['first_name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['telefone'] ?? '';
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Não foi possível carregar os dados.')));
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final XFile? selected = await _picker.pickImage(source: ImageSource.gallery);
    if (selected != null) {
      setState(() => _imageFile = selected);
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);
    final success = await AuthService.updatePerfil({
      'first_name': _nameController.text,
      'email': _emailController.text,
      'telefone': _phoneController.text,
      if (_passwordController.text.isNotEmpty) 'password': _passwordController.text,
    }, imagePath: _imageFile?.path);

    if (success) {
      await _loadPerfil();
      setState(() {
        _isEditing = false;
        _imageFile = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil atualizado com sucesso!')));
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao atualizar perfil.')));
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Conta'),
        content: const Text('Tem certeza que deseja eliminar sua conta permanentemente? Esta ação não pode ser desfeita.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      final success = await AuthService.deletarConta();
      if (success) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao eliminar conta.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          if (!_isEditing)
            IconButton(icon: const Icon(Icons.logout), onPressed: () async {
              await AuthService.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).dividerColor.withOpacity(0.1),
                  backgroundImage: _imageFile != null 
                      ? FileImage(File(_imageFile!.path)) 
                      : (_userData?['foto_perfil'] != null 
                          ? NetworkImage(_userData!['foto_perfil']) 
                          : null) as ImageProvider?,
                  child: (_imageFile == null && _userData?['foto_perfil'] == null)
                      ? const Icon(Icons.person, size: 60, color: AppColors.primaryBlue)
                      : null,
                ),
                if (_isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryBlue,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(_userData?['first_name'] ?? 'Usuário', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text('⭐ 5.0 (Passageiro)', style: TextStyle(color: AppColors.textGray)),
            const SizedBox(height: 40),
            
            _buildField('Nome', _nameController, enabled: _isEditing),
            _buildField('E-mail', _emailController, enabled: _isEditing),
            _buildField('Telefone', _phoneController, enabled: _isEditing),
            if (_isEditing)
              _buildField('Nova Senha (opcional)', _passwordController, isPassword: true, enabled: true),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  if (_isEditing) {
                    _handleSave();
                  } else {
                    setState(() => _isEditing = true);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isEditing ? Colors.green : AppColors.primaryBlue, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
                ),
                child: Text(_isEditing ? 'Salvar Alterações' : 'Editar Perfil', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            
            if (_isEditing)
              TextButton(onPressed: () => setState(() => _isEditing = false), child: const Text('Cancelar')),

            const SizedBox(height: 30),
            TextButton(
              onPressed: _handleDelete,
              child: const Text('Apagar Conta Permanentemente', style: TextStyle(color: AppColors.dangerRed, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool enabled = false, bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGray, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: enabled,
            obscureText: isPassword,
            decoration: InputDecoration(
              filled: true,
              fillColor: enabled ? Theme.of(context).cardColor : Theme.of(context).dividerColor.withOpacity(0.05),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.all(16),
            ),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
