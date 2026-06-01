import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavBarAuth extends StatelessWidget {
  const NavBarAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'lib/assets/images/logo.svg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 14),
            Text(
              "My Money",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
