String errorsCheck(String error) {
  if (error.contains("The email address is badly formatted")) {
    return "Неверный формат почтового адреса";
  }
  if (error.contains(
      "The password is invalid or the user does not have a password")) {
    return "Неверный пароль";
  }
  if (error.contains("The user may have been deleted")) {
    return "Пользователь не найден";
  }
  if (error.contains('user account has been disabled by an administrator')) {
    return "Пользователь был отключен администратором";
  }
  return "NULL";
}
