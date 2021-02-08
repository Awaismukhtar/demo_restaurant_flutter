String validatePhoneNumber(String value){
  String pattern = r'(^((\+92))\d{3}\d{7}$)';
  RegExp regExp = new RegExp(pattern);

  if(!regExp.hasMatch(value)){
    return 'Please provide valid phone number with country code +92';
  }
  return null;
}
String validateName(String value) {
  String patttern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return "Name is Required";
  } else if (!regExp.hasMatch(value)) {
    return "Name must be a-z and A-Z";
  }
  return null;
}
