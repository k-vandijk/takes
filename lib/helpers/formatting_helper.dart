// Formats a date to a string in the format 'dd MM yyyy' in Amsterdam time
String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')} '
         '${date.month.toString().padLeft(2, '0')} '
         '${date.year}';
}

// Formats a date to a string in the format 'MM/yyyy' in Amsterdam time
String formatMonth(DateTime date) {
  return '${date.month.toString().padLeft(2, '0')}/${date.year}';
}

// Formats a time to a string in the format 'hh:mm' in Amsterdam time
String formatTime(DateTime date) {
  return '${date.hour.toString().padLeft(2, '0')}:'
         '${date.minute.toString().padLeft(2, '0')}';
}

