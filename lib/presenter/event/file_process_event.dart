class FileProcessEvent {
  late String fileId;
  late String received;
  late String total;

  FileProcessEvent({
    required this.fileId,
    required this.received,
    required this.total,
  });
}
