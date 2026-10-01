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

String _$appStateHash() => r'23bd5362b05514484c9d17c70fc35501a5a3657b';

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
