import '../../consts/consts.dart';
Widget commonTextField({label, hint, isDesc = false,text,icon,value,onSaved,validator,controller}) {
  return TextFormField(
    controller: controller,
    initialValue: value,
    onSaved: onSaved,
    validator: validator,
    maxLines: isDesc ? 2 : 1,
    style: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w400,),
    decoration: InputDecoration(
      prefixIcon: icon,
      isDense: true,
      label:Text(label,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.black)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(11),
          borderSide: const BorderSide(color: Colors.black,width: 1.2)),
      hintText: hint,
      hintStyle: const TextStyle(color:fontGrey),
    ),
  );
}