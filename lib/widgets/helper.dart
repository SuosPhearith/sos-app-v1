import 'package:flutter/material.dart';
import 'package:wsm_mobile_app/utils/type.dart';

void showConfirmDialog(
  BuildContext context,
  String title,
  String message,
  DialogType type,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevent closing dialog by tapping outside during loading
    builder: (BuildContext context) {
      bool isLoading = false; // Local loading state

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: type == DialogType.primary ? Colors.blue : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null // Disable Cancel button during loading
                    : () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text(
                  "បោះបង់",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              ElevatedButton.icon(
                onPressed: isLoading
                    ? null // Disable Confirm button during loading
                    : () async {
                        setState(() => isLoading = true); // Start loading
                        try {
                          await Future(
                              () => onConfirm()); // Execute async action
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          setState(() => isLoading = false);
                        }
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        type == DialogType.primary ? Icons.check : Icons.delete,
                        color: Colors.white,
                      ),
                label: isLoading
                    ? const SizedBox.shrink() // Hide text during loading
                    : const Text(
                        "បាទ/ចាស",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      type == DialogType.primary ? Colors.blue : Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void showErrorDialog(
  BuildContext context,
  String title,
) {
  showDialog(
    context: context,
    barrierDismissible: true, // Allow closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20), // Uniform padding
        content: Column(
          mainAxisSize: MainAxisSize.min, // Minimize dialog height
          children: [
            const Icon(
              Icons.warning_rounded, // Static warning icon
              color: Colors.red, // Consistent error color
              size: 48, // Larger size for prominence
            ),
            const SizedBox(height: 16), // Spacing between icon and title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center, // Center title
            ), // Spacing before button
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity, // Full-width button
              child: TextButton(
                onPressed: () => Navigator.pop(context), // Close dialog
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // Professional blue color
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                child: const Text(
                  "បិទ", // "OK" in Khmer
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showConfirmDialogWithNavigation(
  BuildContext context,
  String title,
  String message,
  DialogType type,
  VoidCallback onConfirm,
) {
  showDialog(
    context: context,
    barrierDismissible:
        false, // Prevent closing dialog by tapping outside during loading
    builder: (BuildContext context) {
      bool isLoading = false; // Local loading state

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: type == DialogType.primary ? Colors.blue : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Text(
              message,
              style: const TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: isLoading
                    ? null // Disable Cancel button during loading
                    : () => Navigator.pop(context),
                style: TextButton.styleFrom(foregroundColor: Colors.grey),
                child: const Text(
                  "បោះបង់",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              ElevatedButton.icon(
                onPressed: isLoading
                    ? null // Disable Confirm button during loading
                    : () async {
                        setState(() => isLoading = true); // Start loading
                        try {
                          await Future(
                              () => onConfirm()); // Execute async action
                          if (context.mounted) {
                            Navigator.pop(context); // Close dialog on success
                          }
                        } catch (e) {
                          // Optionally handle errors (e.g., show a message)
                          setState(
                              () => isLoading = false); // Stop loading on error
                        }
                      },
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Icon(
                        type == DialogType.primary ? Icons.check : Icons.delete,
                        color: Colors.white,
                      ),
                label: isLoading
                    ? const SizedBox.shrink() // Hide text during loading
                    : const Text(
                        "បាទ/ចាស",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      type == DialogType.primary ? Colors.blue : Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

void showConfirmDialogWithNavigationOfSaleInvoice(BuildContext context,
    String title, Widget message, DialogType type, VoidCallback onConfirm) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning,
                color: type == DialogType.primary ? Colors.blue : Colors.red,
                size: 28),
            const SizedBox(width: 8),
            Text(title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        content: message,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text("បោះបង់",
                style: TextStyle(fontSize: 16, color: Colors.black)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              onConfirm(); // Execute the passed function
            },
            icon: type == DialogType.primary
                ? Icon(Icons.check, color: Colors.white)
                : Icon(Icons.delete, color: Colors.white),
            label: const Text("បាទ/ចាស",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  type == DialogType.primary ? Colors.blue : Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      );
    },
  );
}

void showSuccess(BuildContext context, {String message = "ជោគជ័យ!"}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.green,
    ),
  );
}

void showError(BuildContext context, {String message = "មិនជោគជ័យ!"}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.red,
    ),
  );
}
