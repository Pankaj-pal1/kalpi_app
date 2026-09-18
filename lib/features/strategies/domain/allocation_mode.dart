/// How weight is distributed across the selected holdings.
enum AllocationMode {
  equal('equal', 'Equal weight'),
  marketCap('marketCap', 'Market-cap weight');

  const AllocationMode(this.key, this.label);

  final String key;
  final String label;

  static AllocationMode fromKey(String key) => AllocationMode.values.firstWhere(
    (a) => a.key == key,
    orElse: () => AllocationMode.equal,
  );
}
