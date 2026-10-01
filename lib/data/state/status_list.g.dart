// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_list.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StatusList)
final statusListProvider = StatusListProvider._();

final class StatusListProvider
    extends $AsyncNotifierProvider<StatusList, List<Status>> {
  StatusListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'statusListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$statusListHash();

  @$internal
  @override
  StatusList create() => StatusList();
}

String _$statusListHash() => r'239708b447ac70a619123e6f22529c50f230fced';

abstract class _$StatusList extends $AsyncNotifier<List<Status>> {
  FutureOr<List<Status>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Status>>, List<Status>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Status>>, List<Status>>,
              AsyncValue<List<Status>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
