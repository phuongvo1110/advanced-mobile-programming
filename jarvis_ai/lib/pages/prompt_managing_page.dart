import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jarvis_ai/components/card_prompt_widget.dart';
import 'package:jarvis_ai/pages/prompt_create._page.dart';
import 'package:jarvis_ai/stores/api_store.dart';
import 'package:jarvis_ai/theme/flutter_flow_choice_chips.dart';
import 'package:jarvis_ai/theme/flutter_flow_model.dart';
import 'package:jarvis_ai/theme/flutter_flow_theme.dart';
import 'package:jarvis_ai/theme/flutter_flow_util.dart';
import 'package:jarvis_ai/theme/form_field_controller.dart';
import 'package:jarvis_ai/theme/jarvis_icon_button.dart';
import 'package:jarvis_ai/theme/jarvis_theme.dart';

class PromptManagingModel extends FlutterFlowModel<PromptManagingPage> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(String?)? textControllerValidator;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // Model for CardPromt component.
  late CardPromtModel cardPromtModel;

  @override
  void initState(BuildContext context) {
    cardPromtModel = CardPromtModel();
    choiceChipsValueController = FormFieldController<List<String>>(['All']);
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();

    cardPromtModel.dispose();
  }
}

class PromptManagingPage extends StatefulWidget {
  const PromptManagingPage({super.key, required this.apiStore});
  final ApiStore apiStore;
  @override
  State<PromptManagingPage> createState() => _PromptManagingWidgetState();
}

class _PromptManagingWidgetState extends State<PromptManagingPage> {
  late PromptManagingModel _model;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PromptManagingModel());
    _scrollController.addListener(_scrollListener);
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _loadPrompts(refresh: true);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      print('fwefnweoifwnfoiwenfow');
      widget.apiStore.jarvisService.loadMorePrompts();
    }
  }

  Future<void> _loadPrompts({bool refresh = false}) async {
    try {
      await widget.apiStore.jarvisService.getPrompts(
        refresh: refresh,
        search: _model.textController.text,
        isPublic:
            _model.choiceChipsValue == 'Public'
                ? true
                : _model.choiceChipsValue == 'Private'
                ? false
                : null,
        isFavorite: _model.choiceChipsValue == 'Favorites' ? true : null,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load prompts: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    // _model.textController.removeListener(_onSearchChanged);
    _scrollController.dispose();
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
          'My Prompts',
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
                // context.pushNamed(
                //   LoginScreenWidget.routeName,
                //   extra: <String, dynamic>{
                //     kTransitionInfoKey: TransitionInfo(
                //       hasTransition: true,
                //       transitionType: PageTransitionType.bottomToTop,
                //       duration: Duration(milliseconds: 200),
                //     ),
                //   },
                // );
              },
            ),
          ),
        ],
        centerTitle: false,
        elevation: 0.0,
      ),
      body: SafeArea(
        top: true,
        child: Column(
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
                  onChanged: (value) {
                    _loadPrompts(refresh: true);
                  },
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
                  style: JarvisTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    letterSpacing: 0.0,
                  ),
                  cursorColor: JarvisTheme.of(context).primaryText,
                  validator: _model.textControllerValidator,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16.0),
              child: FlutterFlowChoiceChips(
                options: [
                  ChipData('All'),
                  ChipData('Public'),
                  ChipData('Private'),
                  ChipData('Favorites'),
                ],
                onChanged:
                    (val) => {
                      safeSetState(
                        () => _model.choiceChipsValue = val?.firstOrNull,
                      ),
                      _loadPrompts(refresh: true),
                    },
                selectedChipStyle: ChipStyle(
                  backgroundColor: JarvisTheme.of(context).secondary,
                  textStyle: JarvisTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: JarvisTheme.of(context).info,
                    letterSpacing: 0.0,
                  ),
                  iconColor: JarvisTheme.of(context).info,
                  iconSize: 16.0,
                  labelPadding: EdgeInsetsDirectional.fromSTEB(
                    15.0,
                    5.0,
                    15.0,
                    5.0,
                  ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                unselectedChipStyle: ChipStyle(
                  backgroundColor: JarvisTheme.of(context).secondaryBackground,
                  textStyle: JarvisTheme.of(context).bodyMedium.override(
                    fontFamily: 'Inter',
                    color: JarvisTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
                  iconColor: JarvisTheme.of(context).secondaryText,
                  iconSize: 16.0,
                  labelPadding: EdgeInsetsDirectional.fromSTEB(
                    15.0,
                    5.0,
                    15.0,
                    5.0,
                  ),
                  elevation: 0.0,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                chipSpacing: 18.0,
                rowSpacing: 8.0,
                multiselect: false,
                alignment: WrapAlignment.center,
                controller:
                    _model.choiceChipsValueController ??=
                        FormFieldController<List<String>>([]),
                wrapped: true,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => _loadPrompts(refresh: true),
                child: Observer(
                  builder: (context) {
                    final prompts =
                        widget.apiStore.jarvisService.prompts.toList();
                    if (widget.apiStore.jarvisService.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (prompts.isEmpty &&
                        !widget.apiStore.jarvisService.isLoading) {
                      return Center(
                        child: Text(
                          'No prompts available',
                          style: JarvisTheme.of(context).bodyMedium,
                        ),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          widget.apiStore.jarvisService.prompts.length +
                          (widget.apiStore.jarvisService.hasMorePrompts
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index >=
                            widget.apiStore.jarvisService.prompts.length) {
                          return widget.apiStore.jarvisService.isLoading
                              ? Center(child: CircularProgressIndicator())
                              : SizedBox.shrink();
                        }

                        final prompt =
                            widget.apiStore.jarvisService.prompts[index];
                        return CardPromtWidget(
                          prompt: prompt,
                          onFavoriteChanged: (isFavorite) {
                            // Handle favorite toggle
                          },
                          jarvisService: widget.apiStore.jarvisService,
                          onEditPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return PromptCreatingPage(
                                    apiStore: widget.apiStore,
                                    existingPrompt: prompt,
                                  );
                                },
                              ),
                            );
                          },
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
                  padding: EdgeInsetsDirectional.fromSTEB(
                    16.0,
                    0.0,
                    16.0,
                    16.0,
                  ),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.pushNamed(context, '/create-prompt');
                    },
                    text: 'Create New Prompt',
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
      ),
    );
  }
}
