// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get uiCreateTicket => 'Criar Ordem de Serviço';

  @override
  String get uiSearch => 'Pesquisar OSs';

  @override
  String get uiContextMenuPrint => 'Imprimir';

  @override
  String get uiContextMenuExport => 'Exportar PDF';

  @override
  String get uiContextMenuDelete => 'Excluir';

  @override
  String get uiConfirmDiscardLabel => 'Descartar Mudanças?';

  @override
  String get uiConfirmDiscardActionConfirm => 'Sim, Descartar';

  @override
  String get uiConfirmDiscardActionCancel => 'Cancelar';

  @override
  String get uiConfirmDeleteLabel => 'Excluir Ordem de Serviço?';

  @override
  String get uiConfirmDeleteSubLabel => 'Isso não pode ser desfeito.';

  @override
  String get uiConfirmDeleteActionConfirm => 'Sim, Excluir';

  @override
  String get uiConfirmDeleteActionCancel => 'Cancelar';

  @override
  String get uiConfirmSaveLabel =>
      'Você tem alterações não salvas.\nÉ necessário salvar antes de continuar. \nSalvar agora?';

  @override
  String get uiConfirmSaveActionConfirm => 'Salvar e Continuar';

  @override
  String get uiConfirmSaveActionCancel => 'Cancelar';

  @override
  String get status => 'Status';

  @override
  String get statusNotStarted => 'Não Iniciado';

  @override
  String get statusAwaitingMaterials => 'Aguardando Materiais';

  @override
  String get statusOngoing => 'Em Andamento';

  @override
  String get statusFinished => 'Concluído';

  @override
  String get statusDelivered => 'Entregue';

  @override
  String get statusShowAll => 'Todos';

  @override
  String get ticket => 'Ordem de Serviço';

  @override
  String get tickets => 'Ordens de Serviço';

  @override
  String get ticketStartDate => 'Data de Entrada';

  @override
  String get ticketDeliveryDate => 'Data de Entrega';

  @override
  String get ticketClientName => 'Cliente';

  @override
  String get ticketClientDocument => 'Documento';

  @override
  String get ticketClientAddress => 'Endereço';

  @override
  String get ticketClientContact => 'Contato';

  @override
  String get ticketLocation => 'Local';

  @override
  String get ticketRepairTarget => 'Objeto/Equipamento';

  @override
  String get ticketRepairCondition => 'Briefing/Condições de Entrada';

  @override
  String get ticketRepairDiagnosis => 'Diagnóstico';

  @override
  String get ticketObs => 'Obs.';

  @override
  String get ticketService => 'Serviço';

  @override
  String get ticketServicePrice => 'Mão de Obra';

  @override
  String get ticketPriority => 'Prioridade';

  @override
  String get ticketTotal => 'Preço Total';

  @override
  String get ticketSaved => 'Alterações Salvas.';

  @override
  String ticketExportFileName(String id) {
    return 'ordem_de_servico_$id';
  }

  @override
  String get part => 'Material/Peça';

  @override
  String get parts => 'Materiais/Peças';

  @override
  String get partQuantity => 'Qtd.';

  @override
  String get partPrice => 'Preço';

  @override
  String get partAdd => 'Adicionar Material/Peça';

  @override
  String get partAddCancel => 'Cancelar';

  @override
  String get partTotal => 'Total';

  @override
  String partRemoved(String partName) {
    return 'Material $partName Removido';
  }

  @override
  String get partRemovedUndo => 'Desfazer';

  @override
  String get sortAscending => 'Crescente';

  @override
  String get sortDescending => 'Decrescente';

  @override
  String get sortAscendingText => 'A a Z';

  @override
  String get sortDescendingText => 'Z a A';

  @override
  String get sortAscendingDate => 'Anterior a Posterior';

  @override
  String get sortDescendingDate => 'Posterior a Anterior';

  @override
  String get sortAscendingDatePast => 'Mais Antiga a Mais Recente';

  @override
  String get sortDescendingDatePast => 'Mais Recente a Mais Antiga';

  @override
  String get settings => 'Configurações';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsCurrency => 'Moeda';

  @override
  String get settingsLanguageDefault => 'Padrão do Sistema';
}
