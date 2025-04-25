import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jarvis_ai/components/assistant_card_widget.dart';
import 'package:jarvis_ai/pages/ai_bot_create.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:jarvis_ai/theme/jarvis_drop_down.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

const sortOptions = <String, String>{
  'Recent': 'createdAt',
  'Name': 'assistantName',
};

class AIBotsManagingPageModel extends FlutterFlowModel<AiBotsManagingPage> {
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}

class AiBotsManagingPage extends StatefulWidget {
  const AiBotsManagingPage({super.key, required this.apiStore});
  final ApiStore apiStore;

  @override
  State<AiBotsManagingPage> createState() => _AIBotsManagingPageWidgetState();
}

class _AIBotsManagingPageWidgetState extends State<AiBotsManagingPage> {
  late AIBotsManagingPageModel _model;
  final ScrollController _scrollController = ScrollController();
  String _selectedSort = 'createdAt';
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AIBotsManagingPageModel());
    _scrollController.addListener(_scrollListener);
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _loadAssistants(refresh: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      widget.apiStore.kbService.loadMoreAssistants();
    }
  }

  Future<void> _loadAssistants({bool refresh = false}) async {
    try {
      await widget.apiStore.kbService.getAssistants(
        refresh: refresh,
        search: _model.textController?.text,
        isFavorite: false,
        isPublished: false,
        order: 'ASC',
        order_field: _selectedSort,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load AI Bots: ${e.toString()}')),
      );
    }
  }

  Future<void> _deleteAssistant(String id) async {
    try {
      final result = await widget.apiStore.kbService.deleteAssistant(id: id);
      if (result) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Delete Bot successfully')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load AI Bots: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: JarvisTheme.of(context).primaryBackground,
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
          'AI Bots',
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
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
            child: JarvisIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30.0,
              borderWidth: 1.0,
              buttonSize: 60.0,
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: JarvisTheme.of(context).secondaryBackground,
                size: 30.0,
              ),
              onPressed: () async {
                Navigator.pushNamed(context, '/create-bot');
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
            child: Container(
              width: double.infinity,
              child: TextFormField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: 'Search assistants...',
                  hintStyle: JarvisTheme.of(context).labelMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: JarvisTheme.of(context).alternate,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: JarvisTheme.of(context).primary,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: JarvisTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: JarvisTheme.of(context).error,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  filled: true,
                  fillColor: JarvisTheme.of(context).secondaryBackground,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: JarvisTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
                style: JarvisTheme.of(
                  context,
                ).bodyMedium.override(fontFamily: 'Inter', letterSpacing: 0.0),
                cursorColor: JarvisTheme.of(context).primaryText,
                validator: _model.textControllerValidator,
                onChanged: (value) => _loadAssistants(refresh: true),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Assistants',
                  style: JarvisTheme.of(context).titleMedium.override(
                    fontFamily: 'Inter Tight',
                    letterSpacing: 0.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                JarvisDropDown<String>(
                  controller:
                      _model.dropDownValueController ??=
                          FormFieldController<String>(_selectedSort),
                  options: sortOptions.keys.toList(),
                  onChanged: (String? val) {
                    if (val == null) return;
                    setState(() {
                      _selectedSort = sortOptions[val] as String;
                    });
                    _loadAssistants(refresh: true);
                  },
                  width: 120.0,
                  height: 36.0,
                  textStyle: JarvisTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    fontSize: 14.0,
                    letterSpacing: 0.0,
                  ),
                  hintText: 'Sort by',
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: JarvisTheme.of(context).primaryText,
                    size: 20.0,
                  ),
                  fillColor: JarvisTheme.of(context).secondaryBackground,
                  elevation: 0.0,
                  borderColor: JarvisTheme.of(context).alternate,
                  borderWidth: 1.0,
                  borderRadius: 8.0,
                  margin: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  hidesUnderline: true,
                  isSearchable: false,
                  isMultiSelect: false,
                ),
              ],
            ),
          ),
          Expanded(
            child: Observer(
              builder: (context) {
                final assistants =
                    widget.apiStore.kbService.assistants.toList();
                if (widget.apiStore.kbService.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (assistants.isEmpty &&
                    !widget.apiStore.kbService.isLoading) {
                  return Center(
                    child: Text(
                      'No AI Bots available',
                      style: JarvisTheme.of(context).bodyMedium,
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      widget.apiStore.kbService.assistants.length +
                      (widget.apiStore.kbService.hasMoreAssistants ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= widget.apiStore.kbService.assistants.length) {
                      return widget.apiStore.kbService.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SizedBox.shrink();
                    }
                    final assistant =
                        widget.apiStore.kbService.assistants[index];
                    return AssistantCardWidget(
                      assistant: assistant,
                      onEditPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AIBotCreatePageWidget(
                                apiStore: widget.apiStore,
                                existingAssistantId: assistant.id,
                              );
                            },
                          ),
                        );
                        // If result is true, refresh assistants
                        if (result == true) {
                          await _loadAssistants(refresh: true);
                        }
                      },
                      onDeletePressed: () async {
                        if (await confirm(
                          context,
                          title: Text('Delete Confirm'),
                          content: Text(
                            'Do you want to delete ${assistant.assistantName}',
                          ),
                          textOK: Text('Yes'),
                          textCancel: Text('No'),
                        )) {
                          _deleteAssistant(assistant.id);
                        }
                      },
                      apiStore: widget.apiStore,
                    );
                  },
                );
              },
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
                  onPressed: () async {
                    // Navigate to create page and wait for result
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return AIBotCreatePageWidget(
                            apiStore: widget.apiStore,
                          );
                        },
                      ),
                    );
                    // If result is true, refresh assistants
                    if (result == true) {
                      await _loadAssistants(refresh: true);
                    }
                  },
                  text: 'Create New Assistant',
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
}
