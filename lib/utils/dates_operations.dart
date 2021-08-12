int convertDateToTimestamp(DateTime date) {
  var timestamp = date.toUtc().millisecondsSinceEpoch;
  return timestamp;
}

DateTime convertTimestampToDate(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  return date;
}