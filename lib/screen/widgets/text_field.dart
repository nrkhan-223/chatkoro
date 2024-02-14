import '../../consts/consts.dart';

class TextInputField extends StatelessWidget {
  final String hint;
  final Icon icon;
  final TextEditingController? controller;
  final bool max;

  const TextInputField(
      {super.key,
      this.controller,
      required this.max,
      required this.hint,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.2),
              borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                    autofocus: false,
                    maxLines: max ? 4 : 1,
                    controller: controller,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      prefixIcon: icon,
                      border: InputBorder.none,
                      hintText: hint,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
