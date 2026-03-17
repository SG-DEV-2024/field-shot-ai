enum ServiceState {
  none('none'),
  loading('loading'),
  success('success'),
  failed('failed'),
  ;

  final String state;
  const ServiceState(this.state);

  bool get isNone => this == none;
  bool get isSuccess => this == success;
  bool get isEnd => this == success || this == failed;

  @override
  String toString() => state;
}
