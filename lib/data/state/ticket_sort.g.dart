// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_sort.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TicketSort)
final ticketSortProvider = TicketSortProvider._();

final class TicketSortProvider
    extends $NotifierProvider<TicketSort, TicketSortObject> {
  TicketSortProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ticketSortProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ticketSortHash();

  @$internal
  @override
  TicketSort create() => TicketSort();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketSortObject value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketSortObject>(value),
    );
  }
}

String _$ticketSortHash() => r'd64b3a7aa7b0a50cb534c1001cba6d4eec8ff2b7';

abstract class _$TicketSort extends $Notifier<TicketSortObject> {
  TicketSortObject build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TicketSortObject, TicketSortObject>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TicketSortObject, TicketSortObject>,
              TicketSortObject,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
