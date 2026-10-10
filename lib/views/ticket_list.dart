import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:repairman/l10n/app_localizations.dart';
import 'package:repairman/shortcuts.dart';
import 'package:repairman/data/db/db_controller.dart';
import 'package:repairman/data/models/ticket.dart';
import 'package:repairman/data/state/app_state.dart';
import 'package:repairman/data/state/ticket_list.dart';
import 'package:repairman/components/confirm_close.dart';
import 'package:repairman/components/ticket_card.dart';
import 'package:repairman/components/status_tab_list.dart';
import 'package:repairman/components/ticket_sort_menu.dart';
import 'package:repairman/views/settings.dart';

class TicketList extends ConsumerStatefulWidget {
  final Function? onOpenSettings;
  const TicketList({super.key, this.onOpenSettings});

  @override
  ConsumerState<TicketList> createState() => _TicketListState();
}

class _TicketListState extends ConsumerState<TicketList> {
  List<Ticket> searchList = [];
  bool searching = false;

  void _search(String query) async {
    final results = await DBController().searchTickets(query);
    setState(() {
      searchList = results;
    });
  }

  void _handleNew(BuildContext context, WidgetRef ref) async {
    if (context.mounted) {
      if (ref.read(appStateProvider).isEditing) {
        if (!await confirmClose(context, ref)) {
          return;
        }
      }
      ref.read(appStateProvider.notifier).setCreating();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    ShortcutController().on<NewEvent>().listen((event) {
      if (context.mounted) _handleNew(context, ref);
    });

    final ticketList = ref.watch(ticketListProvider);

    return Scaffold(
      appBar: searching
          ? AppBar(
              title: SearchBar(
                hintText: locale.uiSearch,
                constraints: const BoxConstraints(maxHeight: 40.0),
                elevation: WidgetStateProperty.all(0),
                leading: Icon(Icons.search),
                trailing: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        searching = false;
                      });
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
                onChanged: _search,
                autoFocus: true,
              ),
            )
          : AppBar(
              title: FilledButton.icon(
                onPressed: () {
                  _handleNew(context, ref);
                },
                label: Text(locale.uiCreateTicket),
                icon: Icon(Icons.add),
              ),
              actionsPadding: EdgeInsets.only(right: 16),
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      searching = true;
                    });
                  },
                  icon: Icon(Icons.search_outlined),
                ),
                IconButton(
                  onPressed: () {
                    widget.onOpenSettings?.call();
                  },
                  icon: Icon(Icons.settings_outlined),
                ),
              ],
            ),
      body: IndexedStack(
        index: searching ? 1 : 0,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.0,
                children: [
                  StatusTabList(),
                  TicketSortMenu(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: ticketList.length,
                      itemBuilder: (context, index) =>
                          TicketCard(ticket: ticketList[index]),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListView.builder(
            itemCount: searchList.length,
            itemBuilder: (context, index) =>
                TicketCard(ticket: searchList[index]),
          ),
        ],
      ),
    );
  }
}
