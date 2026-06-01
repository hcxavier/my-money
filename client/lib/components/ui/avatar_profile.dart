import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_money/assets/styles/cores_global.dart';
import 'package:my_money/components/ui/custom_snackbar.dart';
import 'dart:io';
import 'package:my_money/features/user/user_controller.dart';

class AvatarProfile extends StatefulWidget {
  final VoidCallback? onImageUpdated;

  const AvatarProfile({super.key, this.onImageUpdated});

  @override
  State<AvatarProfile> createState() => _AvatarProfileState();
}

class _AvatarProfileState extends State<AvatarProfile> {
  final UserController _userController = UserController();
  String _avatarUrl = '';

  Future<void> _fetchAvatarUrl() async {
    try {
      final userData = await _userController.obterPerfilUsuario();
      if (mounted) {
        setState(() {
          _avatarUrl = userData.imageUrl;
        });
      }
    } catch (e) {
      print('Erro ao carregar avatar: $e');
    }
  }

  Future<void> onCameraTap(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final fileLength = await image.length();

      if (fileLength > 16 * 1024 * 1024) {
        CustomSnackBar.show(
          context: context,
          message: "A imagem deve ser menor que 16MB.",
          isError: true,
        );
        return;
      }

      try {
        final success = await _userController.atualizarImagemPerfil(
          File(image.path),
        );

        _fetchAvatarUrl();

        if (widget.onImageUpdated != null) {
          widget.onImageUpdated!();
        }

        if (!context.mounted) return;

        if (success) {
          CustomSnackBar.show(
            context: context,
            message: "Imagem de perfil atualizada com sucesso!",
          );
        } else {
          CustomSnackBar.show(
            context: context,
            message: "Falha ao atualizar imagem!",
            isError: true,
          );
        }
      } catch (e) {
        print("Erro ao atualizar imagem: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAvatarUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CoresGlobal().backgroundColor,
              border: Border.all(
                color: CoresGlobal().primaryColor,
                width: _userController.isLoading.value ? 0 : 2,
              ),
            ),
            child: Center(
              child: _userController.isLoading.value
                  ? CircularProgressIndicator(color: CoresGlobal().primaryColor)
                  : CircleAvatar(
                      radius: 58,
                      backgroundColor: const Color(0xFF323238),
                      backgroundImage: _avatarUrl.isNotEmpty
                          ? NetworkImage(_avatarUrl)
                          : null,
                      child: _avatarUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 58,
                              color: Colors.white54,
                            )
                          : null,
                    ),
            ),
          ),
          if (!_userController.isLoading.value)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => onCameraTap(context),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: CoresGlobal().primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CoresGlobal().backgroundColor,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
