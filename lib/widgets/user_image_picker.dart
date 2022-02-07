import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserImagePicker extends StatefulWidget {
  final Function imagePickerHandler;

  UserImagePicker({required this.imagePickerHandler});

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _picker = ImagePicker();

  File? imagePicked;

  void _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);

    if (image != null) {
      setState(() {
        imagePicked = File(image.path);
      });

      widget.imagePickerHandler(imagePicked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      behavior: HitTestBehavior.translucent,
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundImage:
            imagePicked != null ? FileImage(File(imagePicked!.path)) : null,
        child: const Icon(
          Icons.add_a_photo,
          color: Colors.white,
        ),
      ),
    );
  }
}
