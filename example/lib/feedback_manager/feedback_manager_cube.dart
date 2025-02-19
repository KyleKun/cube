import 'package:cubes/cubes.dart';

class FeedbackManagerCube extends Cube {
  final dialogControl = CFeedBackControl<String>().obsValue;
  final bottomSheetControl = CFeedBackControl<String>().obsValue;
  final snackBarControl = CFeedBackControl<String>().obsValue;

  void showDialogPer3Seconds() async {
    if (dialogControl.value.show) return;
    dialogControl.show(data: 'Dialog Example\n\nawait 3 seconds');
    await Future.delayed(Duration(seconds: 3));
    dialogControl.hide();
  }

  void showBottomSheetPer3Seconds() async {
    if (bottomSheetControl.value.show) return;
    bottomSheetControl.show(data: 'BottomSheet Example\n\nawait 3 seconds');
    await Future.delayed(Duration(seconds: 3));
    bottomSheetControl.hide();
  }

  void showSnackBar() {
    snackBarControl.show(data: 'SnackBar Example');
  }
}
