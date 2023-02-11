enum AuthFailure {
 none,
  //The server might be down.
 serverError,
  //The user may enter an invalid phone number.
 invalidPhoneNumber,
  //This phone number is not allowed to use the app
 phoneNumberNotAllowed,
  //The user abuses the authentication service with too many requests.
 tooManyRequests,
  //The user device does not support phone number sign-in(emulators).
 deviceNotSupported,
  //The timeout to enter the SMS code may be expired.
 smsTimeout,
  //The user session may expire.
 sessionExpired,
  //The verification code the user entered may be incorrect.
 invalidVerificationCode

}




String authFailureToText(AuthFailure authFailure){
 Map<String,String> map = {
  AuthFailure.invalidPhoneNumber.name: "המספר אינו תקין",
  AuthFailure.phoneNumberNotAllowed.name: "המספר השלכם אינו ברשימת המספרים המאושרים" + "\n" + "אנא פנו לאחראי הבטיחות",
  AuthFailure.tooManyRequests.name: "יותר מידי ניסיונות, נסו מאוחר יותר",
  AuthFailure.deviceNotSupported.name: "המחשיר אינו נתמך",
  AuthFailure.smsTimeout.name: "עבר יותר מידי זמן, נסו שוב",
  AuthFailure.sessionExpired.name: "הקישור עם השרת אינו תקף",
  AuthFailure.serverError.name: "בעיה בשרת, בידקו שיש לכם אינטרנט",
  AuthFailure.invalidVerificationCode.name: "קוד שגוי",
 };

 return map[authFailure.name] ?? "שגיעה";
}



