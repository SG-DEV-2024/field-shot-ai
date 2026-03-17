import 'package:utils/utils.dart';

class EasyIconButton extends StatelessWidget {
  const EasyIconButton({
    super.key,
    required this.onChanged,
    required this.icon,
    this.selectedIcon,
    this.selected,
    this.padding,
  });

  final ValueChanged<bool?> onChanged;
  final Widget icon;
  final Widget? selectedIcon;
  final bool? selected;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) => selected != null
      ? ObxValue(
          (data) => InkWell(
              onTap: () {
                data.toggle();
                onChanged(data.value);
              },
              child: Padding(
                padding: padding ?? EdgeInsets.zero,
                child: data.isTrue ? selectedIcon : icon,
              )),
          selected!.obs,
        )
      : InkWell(
          onTap: () {
            onChanged(null);
          },
          child: Ink(
            child: Container(
              padding: padding ?? EdgeInsets.zero,
              child: icon,
            ),
          ));
}

class EasyTriIconButton extends StatelessWidget {
  const EasyTriIconButton({
    super.key,
    required this.onChanged,
    required this.icon,
    required this.selectedIcon,
    required this.nullIcon,
    required this.selected,
    this.padding = const EdgeInsets.all(8.0),
  });

  final ValueChanged<bool?> onChanged;
  final Widget icon;
  final Widget selectedIcon;
  final Widget nullIcon;
  final RxnBool selected;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Obx(
        () => InkWell(
            onTap: () {
                switch (selected.value) {
                  case true:
                    selected.value = null;
                  case false:
                    selected.value = true;
                  case null:
                    selected.value = false;
                }
              onChanged(selected.value);
            },
            child: Padding(
              padding: padding,
              child: selected.value == true
                  ? selectedIcon
                  : selected.value == null
                      ? nullIcon
                      : icon,
            )),
      );
}
