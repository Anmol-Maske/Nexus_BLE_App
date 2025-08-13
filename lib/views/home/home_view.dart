import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../config/app_colors.dart';
import '../../config/app_strings.dart';
import 'widgets/home_button.dart';
import 'help_view.dart';
import '../device_pairing/device_pairing_view.dart';
import '../beacon_logger/beacon_logger_view.dart';
import '../user_mode/user_mode_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Logo + App Name + Tagline
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.companyName, // "NEXUS"
                        style: GoogleFonts.tiltWarp(
                          fontSize: 65,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlue,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2), // reduced spacing
                      Text(
                        AppStrings.companyTagline, // "Unite Your Devices"
                        style: GoogleFonts.tiltWarp(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 85),

              // Buttons
              HomeButton(
                label: AppStrings.devicesAvailable, // "Devices Available"
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DevicePairingView()),
                  );
                },
              ),
              const SizedBox(height: 18),
              HomeButton(
                label: AppStrings.beaconLoggerTitle, // "Beacon Logger"
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BeaconLoggerView()),
                  );
                },
              ),
              const SizedBox(height: 18),
              HomeButton(
                label: AppStrings.userModeTitle, // "User Mode"
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserModeView()),
                  );
                },
              ),

              const Spacer(),

              // Help icon bottom-right
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.help_outline,
                      size: 28,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const HelpView()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
