import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ticket_sort.g.dart';

enum TicketSortMode {
  startDate,
  deliveryDate,
  client,
  service,
  status,
  priority,
}

enum TicketSortDirection { ascending, descending }

class TicketSortObject {
  final TicketSortMode mode;
  final TicketSortDirection direction;
  final int status;
  const TicketSortObject({
    this.mode = TicketSortMode.startDate,
    this.direction = TicketSortDirection.descending,
    this.status = 0,
  });

  TicketSortObject copyWith({
    TicketSortMode? mode,
    TicketSortDirection? direction,
    int? status,
  }) => TicketSortObject(
    mode: mode ?? this.mode,
    direction: direction ?? this.direction,
    status: status ?? this.status,
  );
}

@riverpod
class TicketSort extends _$TicketSort {
  @override
  TicketSortObject build() {
    return TicketSortObject();
  }

  void setSort(TicketSortMode sortMode, TicketSortDirection sortDirection) {
    state = state.copyWith(mode: sortMode, direction: sortDirection);
  }

  void setStatus(int statusId) {
    state = state.copyWith(status: statusId);
  }
}
