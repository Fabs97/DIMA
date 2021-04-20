import 'dart:io';

import 'package:citylife/models/cl_impression.dart';
import 'package:citylife/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SharedForm extends StatefulWidget {
  List<File> imageList;
  final bool watchStructural;

  SharedForm({Key key, this.imageList, @required this.watchStructural})
      : super(key: key);
  @override
  _SharedFormState createState() => _SharedFormState();
}

class _SharedFormState extends State<SharedForm> {
  bool fromGallery;
  File imageFile;
  List<Widget> gridView;

  final _picker = ImagePicker();

  TextEditingController _notesController = TextEditingController();
  @override
  initState() {
    super.initState();
    imageList = <File>[];
    _notesController.addListener(() => setState(() {
          _notesController.text;
        }));
  }

  List<File> get imageList => widget.imageList;

  set imageList(value) {
    widget.imageList = value;
    gridView = [
      _addNewImage(),
      ...widget.imageList
          .map(
            (e) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: FileImage(e),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          )
          .toList()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Container(
          width: constraints.maxWidth * 0.8,
          height: constraints.maxHeight,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.minHeight,
              maxHeight: constraints.maxHeight,
            ),
            child: Column(
              children: [
                Flexible(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 122.0 / 86.0,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: gridView,
                  ),
                ),
                Consumer<CLImpression>(
                  builder: (context, impression, _) => Flexible(
                    flex: 1,
                    child: TextFormField(
                      maxLines: null,
                      controller: _notesController,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 255,
                      decoration: InputDecoration(
                        hintText: "Notes",
                        counterText: "${_notesController.text.length}/255",
                        prefixIcon: Icon(
                          Icons.edit_outlined,
                          color: T.primaryColor,
                        ),
                      ),
                      onChanged: (v) => impression.notes = v,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _getPhoto(value) async {
    PickedFile pickedFile = await _picker.getImage(
      source: value ? ImageSource.gallery : ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
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
      label: Text(""),
    );
  }
}
