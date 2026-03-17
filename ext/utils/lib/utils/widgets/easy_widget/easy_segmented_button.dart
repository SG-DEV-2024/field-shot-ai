import 'package:utils/utils.dart';

part 'easy_segmented_button.res.dart';

class EasySegmentedButton<T> extends StatelessWidget {
  const EasySegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onSelectionChanged,
    this.noneSelectionEnabled = false,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.showSelectedIcon = true,
    this.expand,
  });

  final List<ButtonSegment<T>> segments;
  final Set<T> selected;
  final void Function(Set<T>)? onSelectionChanged;
  final bool noneSelectionEnabled;
  final bool multiSelectionEnabled;
  final bool emptySelectionAllowed;
  final bool showSelectedIcon;
  final bool? expand;

  @override
  Widget build(BuildContext context) {
    if (expand == true) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_segmentedButton()],
      );
    } else {
      return _segmentedButton();
    }
  }

  Widget _segmentedButton() {
    return ObxValue<Rx<Set<T>>>(
      (selected) => SegmentedButton<T>(
        segments: segments,
        selected: selected.value,
        onSelectionChanged: onSelectionChanged == null
            ? null
            : (newSelected) {
                if (!noneSelectionEnabled) selected(newSelected);
                onSelectionChanged!(newSelected);
              },
        multiSelectionEnabled: multiSelectionEnabled,
        emptySelectionAllowed: emptySelectionAllowed,
        showSelectedIcon: showSelectedIcon,
        selectedIcon: Icon(MdiIcons.check),
      ),
      Rx<Set<T>>(selected),
    );
  }
}
