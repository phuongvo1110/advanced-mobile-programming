import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jarvis_ai/models/datasource.dart'; // Import Datasource models
import 'package:jarvis_ai/models/knowledgebase.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:mobx/mobx.dart';

class KnowledgeBasePageModel extends FlutterFlowModel<KnowledgeBasePage> {
  ScrollController? knowledgeBaseScrollController;
  ScrollController? knowledgeUnitsScrollController;
  FocusNode? knowledgeBasesSearchFieldFocusNode;
  FocusNode? knowledgeUnitsSearchFieldFocusNode;
  TextEditingController? knowledgeBasesSearchController;
  TextEditingController? knowledgeUnitsSearchController;

  @override
  void initState(BuildContext context) {
    knowledgeBaseScrollController = ScrollController();
    knowledgeUnitsScrollController = ScrollController();
    knowledgeBasesSearchFieldFocusNode = FocusNode();
    knowledgeUnitsSearchFieldFocusNode = FocusNode();
    knowledgeBasesSearchController = TextEditingController();
    knowledgeUnitsSearchController = TextEditingController();
  }

  @override
  void dispose() {
    knowledgeBaseScrollController?.dispose();
    knowledgeUnitsScrollController?.dispose();
    knowledgeBasesSearchFieldFocusNode?.dispose();
    knowledgeUnitsSearchFieldFocusNode?.dispose();
    knowledgeBasesSearchController?.dispose();
    knowledgeUnitsSearchController?.dispose();
  }

  @observable
  ObservableList<PlatformFile> selectedFiles = ObservableList<PlatformFile>();
  @observable
  String? fileError;
  @action
  void addFiles(List<PlatformFile> files) {
    selectedFiles.addAll(files);
  }

  @action
  void removeFile(PlatformFile file) {
    selectedFiles.remove(file);
  }
}

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key, required this.apiStore});

  final ApiStore apiStore;

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  late KnowledgeBasePageModel _model;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedKnowledgeBaseId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => KnowledgeBasePageModel());
    _fetchGlobalKnowledgeBases(refresh: true);

    _model.knowledgeBaseScrollController?.addListener(() {
      if (_model.knowledgeBaseScrollController!.position.pixels >=
          _model.knowledgeBaseScrollController!.position.maxScrollExtent -
              200) {
        if (widget.apiStore.kbService.hasMoreGlobalKnowledgeBases &&
            !widget.apiStore.kbService.isLoading) {
          widget.apiStore.kbService.loadMoreGlobalKnowledgeBases();
        }
      }
    });

    _model.knowledgeUnitsScrollController?.addListener(() {
      if (_model.knowledgeUnitsScrollController!.position.pixels >=
          _model.knowledgeUnitsScrollController!.position.maxScrollExtent -
              50) {
        if (widget.apiStore.kbService.hasMoreUnits &&
            !widget.apiStore.kbService.isUnitLoading &&
            selectedKnowledgeBaseId != null) {
          widget.apiStore.kbService.loadMoreKnowledgeUnits(
            id: selectedKnowledgeBaseId as String,
          );
        }
      }
    });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'docx',
          'pdf',
          '.c',
          '.cpp',
          '.html',
          '.java',
          '.json',
          '.md',
          '.php',
          '.pptx',
          '.py',
          '.rb',
          '.tex',
          '.txt',
        ],
        allowMultiple: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final files = result.files;
        files.forEach(
          (file) => print(
            'Picked file: name=${file.name}, path=${file.path}, bytes=${file.bytes?.length}, size=${file.size}',
          ),
        );
        setState(() {
          _model.addFiles(files);
        });
      } else {
        print('No file picked');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to pick file: $e')));
    }
  }

  Future<void> _fetchGlobalKnowledgeBases({bool refresh = false}) async {
    try {
      await widget.apiStore.kbService.getGlobalKnowledgeBases(
        refresh: refresh,
        search: _model.knowledgeBasesSearchController?.text ?? '',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load global knowledge bases: $e')),
      );
    }
  }

  Future<void> _fetchUnits({
    bool refresh = false,
    required String knowledgeId,
  }) async {
    setState(() {
      selectedKnowledgeBaseId = knowledgeId;
    });
    try {
      await widget.apiStore.kbService.getKnowledgeUnits(
        refresh: refresh,
        search: _model.knowledgeUnitsSearchController?.text ?? '',
        knowledgeId: knowledgeId,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load Units: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteKnowledgeBase(String id) async {
    try {
      await widget.apiStore.kbService.deleteKnowledgeBase(knowledgeId: id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge base deleted successfully')),
      );
      await _fetchGlobalKnowledgeBases(refresh: true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete knowledge base: $e')),
      );
    }
  }

  Future<void> _editKnowledgeBase(
    String id,
    String name,
    String description,
  ) async {
    final TextEditingController nameController = TextEditingController(
      text: name,
    );
    final TextEditingController descriptionController = TextEditingController(
      text: description,
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Edit Knowledge Base', style: theme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Knowledge Base Name',
                            style: theme.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        maxLength: 50,
                        decoration: InputDecoration(
                          hintText:
                              'Enter a unique name for your knowledge base',
                          hintStyle: theme.bodyMedium.copyWith(
                            color: theme.secondaryText,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          if (value.length > 50) {
                            return 'Name cannot exceed 50 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${nameController.text.length}/50 characters',
                          style: theme.bodySmall.copyWith(
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: descriptionController,
                        maxLength: 500,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              'Briefly describe the purpose of the knowledge base',
                          hintStyle: theme.bodyMedium.copyWith(
                            color: theme.secondaryText,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value != null && value.length > 500) {
                            return 'Description cannot exceed 500 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${descriptionController.text.length}/500 characters',
                          style: theme.bodySmall.copyWith(
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: theme.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        await widget.apiStore.kbService.updateKnowledgeBase(
                          knowledgeId: id,
                          knowledgeName: nameController.text.trim(),
                          description: descriptionController.text.trim(),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Knowledge base updated successfully',
                            ),
                          ),
                        );
                        await _fetchGlobalKnowledgeBases(refresh: true);
                        Navigator.of(dialogContext).pop();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Failed to update knowledge base: $e',
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: theme.info,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.addListener(() {
      setState(() {});
    });
    descriptionController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = JarvisTheme.of(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: JarvisTheme.of(context).secondary,
        automaticallyImplyLeading: false,
        leading: JarvisIconButton(
          borderRadius: 8.0,
          buttonSize: 40.0,
          fillColor: JarvisTheme.of(context).secondary,
          icon: Icon(
            Icons.arrow_back,
            color: JarvisTheme.of(context).info,
            size: 24.0,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        title: Text(
          'Knowledge Base',
          style: JarvisTheme.of(context).displaySmall.override(
            fontFamily: 'Poppins',
            color: JarvisTheme.of(context).primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: JarvisTheme.of(context).secondaryText,
                offset: Offset(2.0, 2.0),
                blurRadius: 2.0,
              ),
            ],
          ),
        ),
        actions: [],
        centerTitle: false,
        elevation: 0.0,
      ),
      endDrawer:
          selectedKnowledgeBaseId != null
              ? Drawer(
                width: 400,
                backgroundColor: theme.secondaryBackground,
                child: Column(
                  children: [
                    AppBar(
                      backgroundColor: theme.secondaryBackground,
                      automaticallyImplyLeading: false,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          setState(() {
                            selectedKnowledgeBaseId = null;
                            widget.apiStore.kbService.units.clear();
                          });
                          _scaffoldKey.currentState?.openEndDrawer();
                        },
                      ),
                      title: Text(
                        widget.apiStore.kbService.globalKnowledgeBases
                                .firstWhere(
                                  (kb) => kb.id == selectedKnowledgeBaseId,
                                  orElse:
                                      () => KnowledgeBase(
                                        knowledgeName: 'Knowledge Base',
                                      ),
                                )
                                .knowledgeName ??
                            'Knowledge Base',
                        style: theme.titleMedium,
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              selectedKnowledgeBaseId = null;
                              widget.apiStore.kbService.units.clear();
                              widget.apiStore.kbService.unitsPage = 0;
                              widget.apiStore.kbService.hasMoreUnits = true;
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: TextFormField(
                        controller: _model.knowledgeUnitsSearchController,
                        focusNode: _model.knowledgeUnitsSearchFieldFocusNode,
                        onChanged: (value) {
                          _fetchUnits(
                            knowledgeId: selectedKnowledgeBaseId!,
                            refresh: true,
                          );
                        },
                        decoration: InputDecoration(
                          hintText: 'Search units...',
                          hintStyle: theme.labelMedium,
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          if (selectedKnowledgeBaseId != null) {
                            await _fetchUnits(
                              refresh: true,
                              knowledgeId: selectedKnowledgeBaseId!,
                            );
                          }
                        },
                        child: Observer(
                          builder: (context) {
                            final isLoading =
                                widget.apiStore.kbService.isUnitLoading;
                            final units = widget.apiStore.kbService.units;
                            if (isLoading && units.isEmpty) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (units.isEmpty) {
                              return Center(
                                child: Text(
                                  'No knowledge units found',
                                  style: theme.bodyMedium,
                                ),
                              );
                            }
                            return ListView.builder(
                              controller: _model.knowledgeUnitsScrollController,
                              itemCount: widget.apiStore.kbService.units.length,
                              itemBuilder: (context, index) {
                                final unit =
                                    widget.apiStore.kbService.units[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: theme.alternate,
                                        width: 1,
                                      ),
                                    ),
                                    child: ListTile(
                                      leading: typeTransform(
                                        unit.type!,
                                        context,
                                      ),
                                      title: Text(
                                        unit.name ?? 'Untitled',
                                        style: theme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            '${unit.size!.toStringAsFixed(2)} KB',
                                            style: theme.bodySmall.copyWith(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Switch(
                                            value: unit.status!,
                                            onChanged: (value) {
                                              setState(() {
                                                unit.status = value;
                                              });
                                              updateUnitStatus(
                                                selectedKnowledgeBaseId!,
                                                unit.id!,
                                                value,
                                              );
                                            },
                                            activeColor: theme.primary,
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: theme.error,
                                            ),
                                            onPressed: () async {
                                              if (await confirm(
                                                context,
                                                title: Text('Delete Confirm'),
                                                content: Text(
                                                  'Do you want to delete ${unit.name}?',
                                                ),
                                                textOK: Text('Yes'),
                                                textCancel: Text('No'),
                                              )) {
                                                removeUnit(
                                                  unit.id!,
                                                  selectedKnowledgeBaseId!,
                                                );
                                                await _fetchGlobalKnowledgeBases(
                                                  refresh: true,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          showAddKnowledgeUnitDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primary,
                          foregroundColor: theme.info,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: const Text('Add Knowledge Unit'),
                      ),
                    ),
                  ],
                ),
              )
              : null,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: TextFormField(
              controller: _model.knowledgeBasesSearchController,
              focusNode: _model.knowledgeBasesSearchFieldFocusNode,
              onChanged: (value) {
                _fetchGlobalKnowledgeBases(refresh: true);
              },
              decoration: InputDecoration(
                hintText: 'Search knowledge bases...',
                hintStyle: theme.labelMedium,
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.alternate),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.alternate),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.primary),
                ),
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchGlobalKnowledgeBases(refresh: true),
              child: Observer(
                builder: (context) {
                  final kbService = widget.apiStore.kbService;
                  if (kbService.isLoading &&
                      kbService.globalKnowledgeBases.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (kbService.globalKnowledgeBases.isEmpty) {
                    return const Center(
                      child: Text('No knowledge bases found'),
                    );
                  }
                  return ListView.builder(
                    controller: _model.knowledgeBaseScrollController,
                    itemCount: kbService.globalKnowledgeBases.length,
                    itemBuilder: (context, index) {
                      final kb = kbService.globalKnowledgeBases[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            await _fetchUnits(
                              refresh: true,
                              knowledgeId: kb.id!,
                            );
                            _scaffoldKey.currentState?.openEndDrawer();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.alternate,
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          kb.knowledgeName ?? 'Untitled',
                                          style: theme.bodyLarge,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Last updated: ${DateFormat('MMM d, yyyy').format(DateTime.parse(kb.updatedAt ?? DateTime.now().toIso8601String()))}',
                                          style: theme.bodySmall.copyWith(
                                            color: theme.secondaryText,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Units: ${kb.numUnits ?? 0} • Size: ${(kb.totalSize ?? 0).toStringAsFixed(2)} KB',
                                          style: theme.bodySmall.copyWith(
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: theme.primary,
                                        ),
                                        onPressed: () {
                                          _editKnowledgeBase(
                                            kb.id!,
                                            kb.knowledgeName ?? '',
                                            kb.description ?? '',
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: theme.error,
                                        ),
                                        onPressed: () async {
                                          if (await confirm(
                                            context,
                                            title: const Text('Delete Confirm'),
                                            content: Text(
                                              'Do you want to delete ${kb.knowledgeName}?',
                                            ),
                                            textOK: const Text('Yes'),
                                            textCancel: const Text('No'),
                                          )) {
                                            _deleteKnowledgeBase(kb.id!);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0x00FFFFFF),
                    JarvisTheme.of(context).primaryBackground,
                  ],
                  stops: [0.0, 1.0],
                  begin: AlignmentDirectional(-1.0, 0.0),
                  end: AlignmentDirectional(1.0, 0),
                ),
              ),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 16.0),
                child: FFButtonWidget(
                  onPressed: () {
                    _showCreateKnowledgeBaseDialog();
                  },
                  text: 'Create New Knowledge Base',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50.0,
                    padding: EdgeInsetsDirectional.fromSTEB(
                      16.0,
                      0.0,
                      16.0,
                      0.0,
                    ),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(
                      0.0,
                      0.0,
                      0.0,
                      0.0,
                    ),
                    color: JarvisTheme.of(context).secondary,
                    textStyle: JarvisTheme.of(context).titleSmall.override(
                      fontFamily: 'Inter Tight',
                      color: JarvisTheme.of(context).info,
                      letterSpacing: 0.0,
                    ),
                    elevation: 0.0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showImportConfluenceDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController wikiPageUrlController = TextEditingController(
      text: 'https://example.atlassian.net/wiki',
    );
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController accessTokenController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Import Confluence Source', style: theme.titleMedium),
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Unit Name',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Confluence unit name',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Unit name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Confluence Wiki Page URL',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: wikiPageUrlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.atlassian.net/wiki',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Wiki page URL is required';
                      }
                      final urlPattern = RegExp(
                        r'^(https?:\/\/)?([\w\d\-_]+(\.[\w\d\-_]+)+)([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
                      );
                      if (!urlPattern.hasMatch(value)) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Confluence Username',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Confluence username',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Confluence Access Token',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: accessTokenController,
                    decoration: InputDecoration(
                      hintText: 'Enter your Confluence access token',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Access token is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How to get Confluence Access Token:',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Log in to your Confluence account',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Go to Profile > Personal Access Tokens > Create token',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Copy the generated token and paste it here',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Need help? Contact us at myjarvischat@gmail.com',
                          style: theme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: theme.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final datasource = Datasource(
                      type: 'confluence',
                      name: nameController.text.trim(),
                      credentials: {
                        'url': wikiPageUrlController.text.trim(),
                        'username': usernameController.text.trim(),
                        'token': accessTokenController.text.trim(),
                      },
                    );
                    final datasourceRequest = DatasourceRequest(
                      datasources: [datasource],
                    );
                    final response = await widget.apiStore.kbService
                        .uploadConfluenceToKnowledgeBase(
                          knowledgeId: selectedKnowledgeBaseId!,
                          request: datasourceRequest,
                        );
                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Confluence source imported successfully',
                          ),
                        ),
                      );
                      await _fetchUnits(
                        refresh: true,
                        knowledgeId: selectedKnowledgeBaseId!,
                      );
                      await _fetchGlobalKnowledgeBases(refresh: true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to import Confluence source'),
                        ),
                      );
                    }
                    Navigator.of(dialogContext).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to import Confluence source: $e'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateKnowledgeBaseDialog() {
    final TextEditingController knowledgeBaseNameController =
        TextEditingController();
    final TextEditingController knowledgeBaseDescriptionController =
        TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Create a Knowledge Base', style: theme.titleMedium),
                  IconButton(
                    icon: const Icon(Icons.close, size: 24),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Knowledge Base Name',
                            style: theme.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(' *', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: knowledgeBaseNameController,
                        maxLength: 50,
                        decoration: InputDecoration(
                          hintText:
                              'Enter a unique name for your knowledge base',
                          hintStyle: theme.bodyMedium.copyWith(
                            color: theme.secondaryText,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name is required';
                          }
                          if (value.length > 50) {
                            return 'Name cannot exceed 50 characters';
                          }
                          if (widget.apiStore.kbService.globalKnowledgeBases
                              .any((kb) => kb.knowledgeName == value.trim())) {
                            return 'Name must be unique';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${knowledgeBaseNameController.text.length}/50 characters',
                          style: theme.bodySmall.copyWith(
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Description',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: knowledgeBaseDescriptionController,
                        maxLength: 500,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              'Briefly describe the purpose of the knowledge base',
                          hintStyle: theme.bodyMedium.copyWith(
                            color: theme.secondaryText,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.alternate),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          counterText: '',
                        ),
                        validator: (value) {
                          if (value != null && value.length > 500) {
                            return 'Description cannot exceed 500 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 4),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${knowledgeBaseDescriptionController.text.length}/500 characters',
                          style: theme.bodySmall.copyWith(
                            color: theme.secondaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: theme.primaryText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      final newKnowledgeBase = await widget.apiStore.kbService
                          .createKnowledgeBase(
                            name: knowledgeBaseNameController.text.trim(),
                            description:
                                knowledgeBaseDescriptionController.text.trim(),
                          );
                      if (newKnowledgeBase != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Knowledge base created successfully',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Knowledge base created failed'),
                          ),
                        );
                      }
                      Navigator.of(dialogContext).pop();
                      await _fetchGlobalKnowledgeBases(refresh: true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primary,
                    foregroundColor: theme.info,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );

    knowledgeBaseNameController.addListener(() {
      setState(() {});
    });
    knowledgeBaseDescriptionController.addListener(() {
      setState(() {});
    });
  }

  Future<void> updateUnitStatus(
    String knowledgeId,
    String unitId,
    bool status,
  ) async {
    try {
      await widget.apiStore.kbService.updateStatusUnit(
        knowledgeId: knowledgeId,
        unitId: unitId,
        status: status,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge unit status updated')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update knowledge unit status: $e')),
      );
    }
  }

  Future<void> removeUnit(String unitId, String knowledgeId) async {
    try {
      await widget.apiStore.kbService.deleteUnit(
        unitId: unitId,
        knowledgeId: knowledgeId,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Knowledge unit removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove knowledge unit: $e')),
      );
    }
  }

  void showAddKnowledgeUnitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Knowledge Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.file_upload),
                  title: const Text('Local files'),
                  subtitle: const Text('Upload pdf, docx, ...'),
                  onTap: () {
                    Navigator.pop(context);
                    showAddLocalFile(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Website'),
                  subtitle: const Text('Connect Website to get data'),
                  onTap: () {
                    Navigator.pop(context);
                    showImportWebSourceDialog();
                  },
                ),
                ListTile(
                  leading: const Image(
                    image: AssetImage('assets/Slack_icon.png'),
                    width: 20.0,
                    height: 20.0,
                  ),
                  title: const Text('Slack'),
                  subtitle: const Text('Connect to Slack workspace'),
                  onTap: () {
                    Navigator.pop(context);
                    showImportSlackDialog();
                  },
                ),
                ListTile(
                  leading: const Image(
                    image: AssetImage('assets/confluence.png'),
                    width: 20.0,
                    height: 20.0,
                  ),
                  title: const Text('Confluence'),
                  subtitle: const Text('Connect to Confluence'),
                  onTap: () {
                    Navigator.pop(context);
                    showImportConfluenceDialog();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cloud),
                  title: const Text('Google Drive'),
                  subtitle: const Text('Coming soon'),
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitHub Repository'),
                  subtitle: const Text('Connect to GitHub repositories'),
                  enabled: false,
                ),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitLab Repository'),
                  subtitle: const Text('Connect to GitLab repositories'),
                  enabled: false,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void showAddLocalFile(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Import local files'),
          content: SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: JarvisTheme.of(context).secondaryBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: JarvisTheme.of(context).alternate,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Upload documents',
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodyMedium.override(
                                      fontFamily: 'Inter',
                                      color:
                                          JarvisTheme.of(context).primaryText,
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                  JarvisIconButton(
                                    borderRadius: 20.0,
                                    buttonSize: 40.0,
                                    icon: Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: JarvisTheme.of(context).primary,
                                      size: 24.0,
                                    ),
                                    onPressed: () {
                                      _pickFile();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Divider(
                                height: 1.0,
                                thickness: 1.0,
                                color: JarvisTheme.of(context).alternate,
                              ),
                              const SizedBox(height: 16.0),
                              if (_model.fileError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    _model.fileError!,
                                    style: JarvisTheme.of(
                                      context,
                                    ).bodySmall.copyWith(
                                      color: JarvisTheme.of(context).error,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 8.0),
                              Observer(
                                builder:
                                    (_) =>
                                        _model.selectedFiles.isEmpty
                                            ? Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional.fromSTEB(
                                                        4.0,
                                                        0.0,
                                                        4.0,
                                                        0.0,
                                                      ),
                                                  child: Icon(
                                                    Icons.description_outlined,
                                                    color:
                                                        JarvisTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                    size: 24.0,
                                                  ),
                                                ),
                                                Text(
                                                  'No documents uploaded yet',
                                                  style: JarvisTheme.of(
                                                    context,
                                                  ).bodyMedium.override(
                                                    fontFamily: 'Inter',
                                                    color:
                                                        JarvisTheme.of(
                                                          context,
                                                        ).secondaryText,
                                                    letterSpacing: 0.0,
                                                  ),
                                                ),
                                              ],
                                            )
                                            : Column(
                                              children:
                                                  _model.selectedFiles.map((
                                                    file,
                                                  ) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 8.0,
                                                          ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional.fromSTEB(
                                                                      4.0,
                                                                      0.0,
                                                                      4.0,
                                                                      0.0,
                                                                    ),
                                                                child: Icon(
                                                                  Icons
                                                                      .description_outlined,
                                                                  color:
                                                                      JarvisTheme.of(
                                                                        context,
                                                                      ).primaryText,
                                                                  size: 24.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                _truncateFilename(
                                                                  file.name,
                                                                  maxLength: 20,
                                                                ),
                                                                style: JarvisTheme.of(
                                                                  context,
                                                                ).bodyMedium.override(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color:
                                                                      JarvisTheme.of(
                                                                        context,
                                                                      ).primaryText,
                                                                  letterSpacing:
                                                                      0.0,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                                softWrap: false,
                                                              ),
                                                            ],
                                                          ),
                                                          JarvisIconButton(
                                                            borderRadius: 20.0,
                                                            buttonSize: 40.0,
                                                            icon: Icon(
                                                              Icons
                                                                  .delete_outline,
                                                              color:
                                                                  JarvisTheme.of(
                                                                    context,
                                                                  ).error,
                                                              size: 24.0,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                _model
                                                                    .removeFile(
                                                                      file,
                                                                    );
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }).toList(),
                                            ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Observer(
              builder:
                  (_) => ElevatedButton(
                    onPressed:
                        _model.selectedFiles.isEmpty
                            ? null
                            : () async {
                              try {
                                await widget.apiStore.kbService
                                    .uploadFileToKnowledgeBase(
                                      files: _model.selectedFiles,
                                      knowledgeId: selectedKnowledgeBaseId!,
                                    );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Files imported successfully',
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to import files: $e'),
                                  ),
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Import'),
                  ),
            ),
          ],
        );
      },
    );
  }

  void showImportWebSourceDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController urlController = TextEditingController(
      text: 'https://example.com',
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Import Web Source', style: theme.titleMedium),
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Name',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter knowledge unit name',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Web URL',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.com',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'URL is required';
                      }
                      final urlPattern = RegExp(
                        r'^(https?:\/\/)?([\w\d\-_]+(\.[\w\d\-_]+)+)([\w\-\.,@?^=%&:/~\+#]*[\w\-\@?^=%&/~\+#])?$',
                      );
                      if (!urlPattern.hasMatch(value)) {
                        return 'Please enter a valid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Limitation:',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• You can load up to 64 pages at a time',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Need more? Contact us at myjarvischat@gmail.com',
                          style: theme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: theme.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final response = await widget.apiStore.kbService
                        .uploadWebToKnowledgeBase(
                          knowledgeId: selectedKnowledgeBaseId!,
                          unitName: nameController.text,
                          webUrl: urlController.text,
                        );
                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Web source imported successfully'),
                        ),
                      );
                      await _fetchUnits(
                        refresh: true,
                        knowledgeId: selectedKnowledgeBaseId!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to import web source'),
                        ),
                      );
                    }
                    Navigator.of(dialogContext).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to import web source: $e'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  void showImportSlackDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController tokenController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final theme = JarvisTheme.of(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Import Slack Workspace', style: theme.titleMedium),
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Workspace Name',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Enter Slack workspace name',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Workspace name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Slack Token',
                        style: theme.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(' *', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: tokenController,
                    decoration: InputDecoration(
                      hintText: 'xoxb-...',
                      hintStyle: theme.bodyMedium.copyWith(
                        color: theme.secondaryText,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.alternate),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.primary),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Slack token is required';
                      }
                      if (!value.startsWith('xoxb-')) {
                        return 'Slack token must start with "xoxb-"';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How to get Slack Token:',
                          style: theme.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '• Create a Slack app and install it to your workspace',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Copy the Bot User OAuth Token (starts with xoxb-)',
                          style: theme.bodySmall,
                        ),
                        Text(
                          '• Need help? Contact us at myjarvischat@gmail.com',
                          style: theme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
                foregroundColor: theme.primaryText,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Back'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final datasource = Datasource(
                      type: 'slack',
                      name: nameController.text.trim(),
                      credentials: {'token': tokenController.text.trim()},
                    );
                    final request = DatasourceRequest(
                      datasources: [datasource],
                    );
                    final response = await widget.apiStore.kbService
                        .uploadSlackToKnowledgeBase(
                          knowledgeId: selectedKnowledgeBaseId!,
                          request: request,
                        );
                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Slack workspace imported successfully',
                          ),
                        ),
                      );
                      await _fetchUnits(
                        refresh: true,
                        knowledgeId: selectedKnowledgeBaseId!,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to import Slack workspace'),
                        ),
                      );
                    }
                    Navigator.of(dialogContext).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to import Slack workspace: $e'),
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text('Import'),
            ),
          ],
        );
      },
    );
  }

  String _truncateFilename(String filename, {int maxLength = 20}) {
    if (filename.length <= maxLength) return filename;

    final extension = filename.split('.').last;
    final nameWithoutExt = filename.substring(
      0,
      filename.length - extension.length - 1,
    );
    final prefixLength = (maxLength - extension.length - 3) ~/ 2; // 3 for "..."
    final suffixLength = maxLength - extension.length - 3 - prefixLength;

    return '${nameWithoutExt.substring(0, prefixLength)}...${nameWithoutExt.substring(nameWithoutExt.length - suffixLength)}.$extension';
  }
}

dynamic typeTransform(String type, BuildContext context) {
  final theme = JarvisTheme.of(context);
  switch (type) {
    case 'web':
      return Icon(Icons.web, color: theme.secondaryText);
    case 'slack':
      return Image(
        image: AssetImage('assets/Slack_icon.png'),
        width: 20,
        height: 20,
      );
    case 'confluence':
      return Image(
        image: AssetImage('assets/confluence.png'),
        width: 20,
        height: 20,
      );
    default:
      return Icon(Icons.description, color: theme.secondaryText);
  }
}
