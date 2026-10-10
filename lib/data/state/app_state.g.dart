// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppState)
final appStateProvider = AppStateProvider._();

final class AppStateProvider
    extends $NotifierProvider<AppState, AppStateObject> {
  AppStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStateHash();

  @$internal
  @override
  AppState create() => AppState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppStateObject value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppStateObject>(value),
    );
  }
}

String _$appStateHash() => r'fa21da673ee47676b2ca534a8a01d0b949226ef6';

abstract class _$AppState extends $Notifier<AppStateObject> {
  AppStateObject build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppStateObject, AppStateObject>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppStateObject, AppStateObject>,
              AppStateObject,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
