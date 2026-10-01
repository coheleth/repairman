import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:repairman/data/models/ticket.dart';

part 'app_state.g.dart';

@immutable
class AppStateObject {
  final bool isEditing;
  final bool isCreating;
  final bool modified;
  final Ticket? openTicket;
  final GlobalKey<NavigatorState> navigatorKey;

  const AppStateObject({
    required this.navigatorKey,
    this.isEditing = false,
    this.isCreating = false,
    this.modified = false,
    this.openTicket,
  });

  AppStateObject copyWithTicket({
    bool? isEditing,
    bool? isCreating,
    bool? modified,
    Ticket? openTicket,
  }) => AppStateObject(
    navigatorKey: navigatorKey,
    isEditing: isEditing ?? this.isEditing,
    isCreating: isCreating ?? this.isCreating,
    modified: modified ?? this.modified,
    openTicket: openTicket,
  );

  AppStateObject copyWith({
    bool? isEditing,
    bool? isCreating,
    bool? modified,
    Ticket? openTicket,
  }) => AppStateObject(
    navigatorKey: navigatorKey,
    isEditing: isEditing ?? this.isEditing,
    isCreating: isCreating ?? this.isCreating,
    modified: modified ?? this.modified,
    openTicket: openTicket ?? this.openTicket,
  );
}

@Riverpod(keepAlive: true)
class AppState extends _$AppState {
  @override
  AppStateObject build() {
    return AppStateObject(
      navigatorKey: GlobalKey<NavigatorState>(),
      isEditing: false,
    );
  }

  void setEditing(Ticket ticket) {
    state = state.copyWithTicket(
      isEditing: true,
      isCreating: false,
      modified: false,
      openTicket: ticket,
    );
  }

  void setCreating() {
    state = state.copyWith(
      isEditing: true,
      isCreating: true,
      modified: false,
      openTicket: Ticket(id: -1, service: '', statusId: 1),
    );
  }

  void setIdle() {
    state = state.copyWithTicket(
      isEditing: false,
      isCreating: false,
      modified: false,
      openTicket: null,
    );
  }

  void setModified({bool? modified}) {
    state = state.copyWith(modified: modified ?? true);
  }

  void setTicket(Ticket? ticket) {
    state = state.copyWithTicket(openTicket: ticket);
  }
}
