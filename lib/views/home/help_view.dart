import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_colors.dart';
import '../../config/app_strings.dart';

class HelpView extends StatelessWidget {
  const HelpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          AppStrings.contactUs,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              AppStrings.getInTouch,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              AppStrings.contactTagline,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 30),

            // Phone box
            _contactBox(
              icon: Icons.phone_outlined,
              text: AppStrings.contactNumber,
              onTap: () => _launchURL('tel:${AppStrings.contactNumber}'),
            ),
            const SizedBox(height: 15),

            // Email box
            _contactBox(
              icon: Icons.email_outlined,
              text: AppStrings.companyMail,
              onTap: () => _launchURL(
                'mailto:${AppStrings.companyMail}?subject=Inquiry&body=Hello,',
              ),
            ),
            const SizedBox(height: 40),

            const Text(
              AppStrings.socialMedia,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _socialIcon(
                  FontAwesomeIcons.linkedinIn,
                  'https://www.linkedin.com/in/anmol-maske/', // LinkedIn URL
                ),
                const SizedBox(width: 20),
                _socialIcon(
                  FontAwesomeIcons.instagram,
                  'https://www.instagram.com/', // Instagram URL
                ),
                const SizedBox(width: 20),
                _socialIcon(
                  FontAwesomeIcons.twitter,
                  'https://twitter.com/', // Twitter URL
                ),
                const SizedBox(width: 20),
                _socialIcon(
                  Icons.language,
                  'https://www.anmol.com', // Website URL
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactBox({required IconData icon, required String text, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: CircleAvatar(
        radius: 22,
        backgroundColor: Colors.black12,
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    );
  }

  static Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
