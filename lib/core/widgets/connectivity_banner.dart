import 'package:ecom/core/di/service_locator.dart';
import 'package:ecom/core/network/network_info.dart';
import 'package:flutter/material.dart';

/// Banner that shows when device loses internet connection
class ConnectivityBanner extends StatelessWidget {
  const ConnectivityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: getIt<NetworkInfo>().onConnectivityChanged,
      initialData: true, // Assume connected initially
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? true;

        if (!isConnected) {
          return MaterialBanner(
            backgroundColor: Colors.red[700],
            padding: const EdgeInsets.all(12),
            content: const Row(
              children: [
                Icon(Icons.wifi_off, color: Colors.white, size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No internet connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            actions: const [SizedBox.shrink()],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
