import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wsm_mobile_app/providers/global/auth_provider.dart';
import 'package:wsm_mobile_app/utils/type.dart';
import 'package:wsm_mobile_app/widgets/helper.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for the text fields
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Consumer<AuthProvider>(builder: (context, provider, child) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text('ផ្លាស់ប្តូរពាក្យសម្ងាត់'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'ពាក្យសម្ងាត់បច្ចុប្បន្ន'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'ពាក្យសម្ងាត់បច្ចុប្បន្ន',
                        prefixIcon: const Icon(Icons.lock,
                            color: Colors.black, size: 24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // New Password Field
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'ពាក្យសម្ងាត់ថ្មី'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'ពាក្យសម្ងាត់ថ្មី',
                        prefixIcon: const Icon(Icons.lock,
                            color: Colors.black, size: 24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // Confirm Password Field
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'បញ្ជាក់ពាក្យសម្ងាត់ថ្មី'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'បញ្ជាក់ពាក្យសម្ងាត់ថ្មី',
                        prefixIcon: const Icon(Icons.lock,
                            color: Colors.black, size: 24),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 1),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                // Save Button
                const Spacer(), // Pushes the button to the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Validation
                        if (currentPasswordController.text.length < 6 ||
                            newPasswordController.text.length < 6 ||
                            confirmPasswordController.text.length < 6) {
                          showErrorDialog(context, 'សូមបញ្ចូលយ៉ាងតិច៦អក្សរ!');
                          return;
                        }
                        if (newPasswordController.text.trim() !=
                            confirmPasswordController.text.trim()) {
                          showErrorDialog(
                              context, 'ការបញ្ជាក់ ពាក្យសម្ងាត់មិនត្រឹមត្រូវ!');
                          return;
                        }
                        showConfirmDialog(
                            context,
                            'បញ្ជាក់ការប្តូរពាក្យសម្ងាត់',
                            'តើអ្នកពិតជាចង់ប្តូរប្តូរពាក្យសម្ងាត់មែនទេ?',
                            DialogType.primary, () async {
                          try {
                            await provider.handleChangePassword(
                              password: currentPasswordController.text.trim(),
                              newPassword: newPasswordController.text.trim(),
                              confirmPassword:
                                  confirmPasswordController.text.trim(),
                            );
                            // Optionally show success message or navigate back
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'ពាក្យសម្ងាត់ផ្លាស់ប្តូរដោយជោគជ័យ!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              Navigator.pop(
                                  context); // Example: go back on success
                            }
                          } catch (e) {
                            if (context.mounted) {
                              showErrorDialog(context,
                                  "ពាក្យសម្ងាត់បច្ចុប្បន្នមិនត្រឹមត្រូវ");
                            }
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'រក្សាទុក',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
