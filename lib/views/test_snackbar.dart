import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SnackBarWidget extends StatelessWidget {
  const SnackBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Show Message'),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                content: CustomSnackBarContentWidget(
                    errorText: 'Show SnackBar in this screen'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                behavior: SnackBarBehavior.floating,
                // appears but does not touch the bottom of the screen
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomSnackBarContentWidget extends StatelessWidget {
  const CustomSnackBarContentWidget({super.key, required this.errorText});
  final String errorText;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Color(0xFFC72C41),
          ),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Oh snap!',
                      style: TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    Text(
                      errorText,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(20)),
            child: SvgPicture.asset(
              'assets/icons/bubbles.svg',
              width: 40,
              height: 48,
              // ignore: deprecated_member_use
              color: const Color(0xFF801336),
            ),
          ),
        ),
        Positioned(
          top: -20,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/fail.svg',
                height: 40,
              ),
              Positioned(
                top: 10,
                child: SvgPicture.asset(
                  'assets/icons/close.svg',
                  height: 16,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
