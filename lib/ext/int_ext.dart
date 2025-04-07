extension IntExt on int {
  int toKj() {
    return (this * 4.184).round();
  }
  int toKcal() {
    return (this *  0.239006).round();
  }
}