import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/state/ticket_sort.dart';

part 'ticket_list.g.dart';

@riverpod
class TicketList extends _$TicketList {
  late TicketSortObject ticketSort = TicketSortObject();

  @override
  List<Ticket> build() {
    ref.listen<TicketSortObject>(ticketSortProvider, (previous, next) {
      ticketSort = next;
      refresh();
    });
    refresh();
    return [];
  }

  void refresh() async {
    state = await DBController().getAllTickets(
      statusFilter: ticketSort.status,
      sortMode: ticketSort.mode,
      sortDirection: ticketSort.direction,
    );
  }

  void update(Ticket ticket) {
    DBController().updateTicket(ticket);
    state = [
      for (final originalTicket in state)
        if (originalTicket.id == ticket.id) ticket else originalTicket,
    ];
  }

  void create(Ticket ticket) async {
    final id = await DBController().createTicket(ticket);
    final ticketSort = ref.read(ticketSortProvider);
    if (ticketSort.status == ticket.statusId || ticketSort.status == 0) {
      state = [ticket.copyWith(id: id), ...state];
    }
  }

  void delete(int id) {
    DBController().deleteTicketById(id);

    state = [
      for (final ticket in state)
        if (ticket.id != id) ticket,
    ];
  }
}
