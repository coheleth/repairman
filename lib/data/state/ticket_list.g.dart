// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TicketList)
final ticketListProvider = TicketListProvider._();

final class TicketListProvider
    extends $NotifierProvider<TicketList, List<Ticket>> {
  TicketListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketListHash();

  @$internal
  @override
  TicketList create() => TicketList();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Ticket> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Ticket>>(value),
    );
  }
}

String _$ticketListHash() => r'f808825fc7b11c6fe394635e9e7dcf643700060b';

abstract class _$TicketList extends $Notifier<List<Ticket>> {
  List<Ticket> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Ticket>, List<Ticket>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Ticket>, List<Ticket>>,
              List<Ticket>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
