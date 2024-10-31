// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:salon_user/app/utils/all_dependency.dart';

void showUploadImgDialog({
  required List img,
  required BuildContext context,
  required String path,
  required Function(List data) onBack,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => UploadImgDialog(
      img,
      path: path,
      onBack: onBack,
    ),
  );
}

class UploadImgDialog extends StatefulWidget {
  final List img;
  final String path;
  final Function(List<String> data) onBack;
  const UploadImgDialog(
    this.img, {
    super.key,
    required this.path,
    required this.onBack,
  });

  @override
  State<UploadImgDialog> createState() => _UploadImgDialogState();
}

class _UploadImgDialogState extends State<UploadImgDialog> {
  double _progress = 0;
  int _currentImageIndex = 0;
  List<String> urls = [];
  List imgList = [];

  uploadImagesSequentially() async {
    imgList = widget.img
        .where((element) => !(element as String).contains("https"))
        .toList();
    setState(() {
      _currentImageIndex = 0;
      _progress = 0;
    });

    for (int i = 0; i < imgList.length; i++) {
      await uploadSingleImage(imgList[i], i);
    }
  }

  Future<void> uploadSingleImage(String image, int index) async {
    String fileName = '${widget.path}image${widget.img.indexOf(image) + 1}.png';
    Reference ref = FirebaseStorage.instance.ref().child(fileName);

    UploadTask uploadTask = ref.putFile(File(image));

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _progress = snapshot.bytesTransferred / snapshot.totalBytes;
        _currentImageIndex = index;
      });
    });

    await uploadTask.whenComplete(() async {
      var dowurl = await (await uploadTask).ref.getDownloadURL();
      for (int i = 0; i < widget.img.length; i++) {
        if (widget.img[i] == image) {
          urls.removeAt(i);
          urls.insert(i, dowurl);
        }
      }
      if (index + 1 == imgList.length) {
        widget.onBack(urls);
      }
    });
  }

  @override
  void initState() {
    for (var element in widget.img) {
      urls.add(element);
    }
    uploadImagesSequentially();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: _progress,
                    color: AppColor.primaryColor,
                    backgroundColor: AppColor.grey40,
                  ),
                  10.horizontal(),
                  Text(
                    'Uploading Image ${_currentImageIndex + 1} of ${imgList.length}',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
