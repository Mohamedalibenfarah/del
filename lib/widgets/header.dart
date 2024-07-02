import 'package:deloitte/widgets/home.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  const Header({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/del.png',
              width: 300,
              height: 120,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const Home(),
                        ),
                      );
                    },
                    child: const Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  InkWell(
                    onTap: () {
                      // Navigate to sign in page
                    },
                    child: const Text(
                      "About Us",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
