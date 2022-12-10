import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NotifierWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T viewModel;

  final Widget? child;

  final Widget Function(
    BuildContext context,
    T viewModel,
    Widget? child,
  ) builder;

  final Function(T)? onInit;

  const NotifierWidget({
    Key? key,
    required this.viewModel,
    required this.builder,
    this.child,
    this.onInit,
  }) : super(key: key);

  @override
  State<NotifierWidget> createState() => _NotifierWidgetState<T>();
}

class _NotifierWidgetState<T extends ChangeNotifier>
    extends State<NotifierWidget<T>> {
  late T viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = widget.viewModel;
    widget.onInit?.call(viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Consumer<T>(
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
