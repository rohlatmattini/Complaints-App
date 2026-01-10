// lib/core/events/complaint_events.dart
import 'package:get/get.dart';

class ComplaintEvents {


  static final Rx<ComplaintEventType> complaintStream =
      ComplaintEventType.none.obs;

  static void notify(ComplaintEventType event) {
    complaintStream.value = ComplaintEventType.none;
    complaintStream.refresh();
    complaintStream.value = event;
  }

  static void refreshAll() {
    notify(ComplaintEventType.refreshAll);
  }
}

enum ComplaintEventType {
  none,
  newComplaint,
  statusUpdated,
  refreshAll,
}


