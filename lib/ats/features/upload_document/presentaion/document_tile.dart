
import 'package:flutter/material.dart';
import 'package:flutter_app/ats/features/upload_document/model/model_class.dart';

class DocumentTile extends StatelessWidget {

  final DocumentModel model;
  final VoidCallback onTap;

  const DocumentTile({
    super.key,
    required this.model,
    required this.onTap,
  });

  IconData getDocumentIcon(
    String title,
  ) {

    switch (title) {

      case "Aadhaar Card":
        return Icons.credit_card;

      case "PAN Card":
        return Icons.badge;

      case "Passport Size Photo":
        return Icons.photo_camera;

      case "Education Certificate":
        return Icons.school;

      case "Experience Letter":
        return Icons.work;

      default:
        return Icons.description;
    }
  }

  Color getDocumentColor(
    String title,
  ) {

    switch (title) {

      case "Aadhaar Card":
        return Colors.orange.shade400;

      case "PAN Card":
        return Colors.blue.shade400;

      case "Passport Size Photo":
        return Colors.deepPurple.shade400;

      case "Education Certificate":
        return Colors.green.shade400;

      case "Experience Letter":
        return Colors.brown.shade400;

      default:
        return Colors.deepPurple.shade400;
    }
  }

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,

      borderRadius:
          BorderRadius.circular(10),

      child: Container(
        margin: const EdgeInsets.only(
          bottom: 16,
        ),

padding: const EdgeInsets.symmetric(
  horizontal: 14,
  vertical: 10,
),
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color: Colors.grey.shade400,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(0.03),

              blurRadius: 10,

              offset: const Offset(
                0,
                4,
              ),
            ),
          ],
        ),

        child: Row(
          children: [

            Container(
              width: 54,
              height: 54,

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                borderRadius:
                    BorderRadius.circular(14),
              ),

              child: Icon(
                getDocumentIcon(
                  model.title,
                ),

                color: getDocumentColor(
                  model.title,
                ),

                size: 28,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    model.title,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    model.isUploaded
                        ? "Uploaded"
                        : "Tap to Upload",

                    style: TextStyle(
                      color: model.isUploaded
                          ? Colors.green
                          : Colors.orange,

                      fontWeight:
                          FontWeight.w500,
                    ),
                  ),

                  if (model.fileName != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(
                        top: 4,
                      ),

                      child: Text(
                        model.fileName!,

                        overflow:
                            TextOverflow.ellipsis,

                        style: TextStyle(
                          color:
                              Colors.grey.shade600,

                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: 400,
              ),

              transitionBuilder:
                  (child, animation) {

                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },

              child: Icon(
                model.isUploaded
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,

                key: ValueKey(
                  model.isUploaded,
                ),

                color: model.isUploaded
                    ? Colors.green
                    : Colors.grey,

                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
