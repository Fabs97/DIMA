import 'dart:io';

import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SharedForm extends StatefulWidget {
  @override
  _SharedFormState createState() => _SharedFormState();
}

class _SharedFormState extends State<SharedForm> {
  File imageFile;
  List<File> imageList;

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 122,
      maxHeight: 86,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      imageList.add(imageFile);
    }
  }

  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 122,
      maxHeight: 86,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      imageList.add(imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final structuralImpression = context.watch<CLImpression>();
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              width: constraints.maxWidth * 0.8,
              height: constraints.maxHeight,
              child: Column(
                children: [
                  Container(
                    height: constraints.maxHeight * 0.75,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 122.0 / 86.0,
                            crossAxisSpacing: 3,
                            mainAxisSpacing: 3),
                        itemCount: imageList.length,
                        itemBuilder: (BuildContext context, index) {
                          return Container(
                            alignment: Alignment.center,
                            child: Image(
                              image: FileImage(File(imageList[index].path)),
                            ),
                          );
                        }),
                  ),
                  ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFFC4C4C4)),
                      onPressed: () {
                        // TODO: decide here to pick from gallery or camera
                      },
                      icon: Icon(
                        Icons.add_a_photo_outlined,
                        color: T.textLightColor,
                      ),
                      label: Text("")),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextFormField(
                        maxLines: 3,
                        initialValue: "Notes",
                        decoration: InputDecoration(
                            prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Icon(Icons.edit_outlined),
                        ))),
                  )
                ],
              ),
            ));
  }
}
