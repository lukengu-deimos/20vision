final RegExp _emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
bool isValidEmail(String email) => _emailRegex.hasMatch(email);