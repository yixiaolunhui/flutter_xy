import '../../core/view_model.dart';

class RulerViewModel extends ViewModel {
  int num = 50;

  updateNum(int num) {
    this.num = num;
    setState(() {});
  }
}
