import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_money/features/user/user_controller.dart';
// user_model imported only if needed in future

class NavBarMain extends StatefulWidget {
  final Function() onNovaTransacaoPressed;

  const NavBarMain({super.key, required this.onNovaTransacaoPressed});

  @override
  State<NavBarMain> createState() => _NavBarMainState();
}

class _NavBarMainState extends State<NavBarMain> {
  final UserController _userController = UserController();
  String _imageUrl = '';
  String _nomeUsuario = '';
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() => _isLoadingUser = true);
    try {
      final user = await _userController.obterDadosMinPerfil();
      if (mounted) {
        setState(() {
          _nomeUsuario = user.name;
          _imageUrl = user.imageUrl;
        });
      }
    } catch (e) {
      print('Erro ao carregar perfil no NavBarMain: $e');
    } finally {
      if (mounted) setState(() => _isLoadingUser = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo e Perfil
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'lib/assets/images/logo.svg',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'My Money',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFE1E1E6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final result = await Navigator.pushNamed(context, '/profile');
                  if (result == true) {
                    // perfil possivelmente alterado; refetch
                    _fetchUser();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: const Color(0xFF323238),
                        backgroundImage: _imageUrl.isNotEmpty
                            ? NetworkImage(_imageUrl)
                            : null,
                        child: _imageUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 18,
                                color: Colors.white54,
                              )
                            : null,
                      ),
                      const SizedBox(width: 8),
                      _isLoadingUser
                          ? SizedBox(
                              width: 80,
                              height: 14,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2A2A2E),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            )
                          : Text(
                              "Olá, ${_nomeUsuario.isNotEmpty ? _nomeUsuario : ''}",
                              style: const TextStyle(
                                color: Color(0xFFC4C4CC),
                                fontSize: 14,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Botão Nova Transação
          ElevatedButton(
            onPressed: widget.onNovaTransacaoPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00875F),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: const Text(
              'Nova transação',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
