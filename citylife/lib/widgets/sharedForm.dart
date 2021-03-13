import 'dart:io';

import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SharedForm extends StatefulWidget {
  List<File> imageList;

  SharedForm({Key key, this.imageList}) : super(key: key);
  @override
  _SharedFormState createState() => _SharedFormState();
}

class _SharedFormState extends State<SharedForm> {
  bool fromGallery;
  File imageFile;
  List<Widget> gridView;

  @override
  initState() {
    super.initState();
    imageList = <File>[];
  }

  List<File> get imageList => widget.imageList;

  set imageList(value) {
    widget.imageList = value;
    gridView = [
      _addNewImage(),
      ...widget.imageList
          .map((e) => Image(
                image: FileImage(e),
                fit: BoxFit.fill,
              ))
          .toList()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Container(
              width: constraints.maxWidth * 0.8,
              height: constraints.maxHeight,
              child: Consumer<CLImpression>(
                builder: (context, impression, _) => Column(
                  children: [
                    Container(
                      height: constraints.maxHeight * 0.75,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 122.0 / 86.0,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 3),
                          itemCount: gridView.length,
                          itemBuilder: (BuildContext context, index) {
                            return gridView[index];
                          }),
                    ),
                    TextFormField(
                      maxLines: 3,
                      initialValue: "Notes",
                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Icon(Icons.edit_outlined),
                        ),
                      ),
                      onChanged: (v) => impression.notes = v,
                    ),
                  ],
                ),
              ),
            ));
  }

  _getPhoto(value) async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: value ? ImageSource.gallery : ImageSource.camera,
      maxWidth: 122,
      maxHeight: 86,
    );
    if (pickedFile != null) {
      setState(() {
        File imageFile = File(pickedFile.path);
        imageList = [imageFile, ...imageList];
      });
    }
  }

  _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        fromGallery = true;
                        _getPhoto(fromGallery);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      fromGallery = false;
                      _getPhoto(fromGallery);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _addNewImage() {
    return ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: Color(0xFFC4C4C4)),
        onPressed: () {
          _showPicker(context);
        },
        icon: Icon(
          Icons.add_a_photo_outlined,
          color: T.textLightColor,
        ),
        label: Text(""));
  }
}
