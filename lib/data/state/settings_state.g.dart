// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SettingsState)
final settingsStateProvider = SettingsStateProvider._();

final class SettingsStateProvider
    extends $NotifierProvider<SettingsState, SettingsStateObject> {
  SettingsStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsStateHash();

  @$internal
  @override
  SettingsState create() => SettingsState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsStateObject value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsStateObject>(value),
    );
  }
}

String _$settingsStateHash() => r'38791d6bb223624e3a2cd62670ef1b0ac14a3b28';

abstract class _$SettingsState extends $Notifier<SettingsStateObject> {
  SettingsStateObject build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SettingsStateObject, SettingsStateObject>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SettingsStateObject, SettingsStateObject>,
              SettingsStateObject,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
