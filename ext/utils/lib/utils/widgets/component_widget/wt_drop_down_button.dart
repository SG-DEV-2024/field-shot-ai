import 'package:utils/utils.dart';

class WtDropDownButton extends StatelessWidget {
  const WtDropDownButton({Key? key, required this.title, required this.onTap}) : super(key: key);

  final String title;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: WtColors.gray4,
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: WtTextStyle.bodyMedium),
            const Icon(WtIcons.expand_more_s),
          ],
        ),
      ),
    );
  }
}
