import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:anandham_user/presentation/blocs/dharmas/dharmas_state.dart';
import 'package:anandham_user/presentation/blocs/dharmas/dharma_detail_cubit.dart';

class DharmaDetailPage extends StatelessWidget {
  final DharmaItemView dharma;

  const DharmaDetailPage({super.key, required this.dharma});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DharmaDetailCubit(),
      child: _DharmaDetailView(dharma: dharma),
    );
  }
}

class _DharmaDetailView extends StatefulWidget {
  final DharmaItemView dharma;

  const _DharmaDetailView({required this.dharma});

  @override
  State<_DharmaDetailView> createState() => _DharmaDetailViewState();
}

class _DharmaDetailViewState extends State<_DharmaDetailView> {
  double _fontSize = 18;

  void _increaseFontSize() {
    setState(() {
      _fontSize = (_fontSize + 2).clamp(18, 36);
    });
  }

  void _decreaseFontSize() {
    setState(() {
      _fontSize = (_fontSize - 2).clamp(18, 36);
    });
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }

  Widget _slokasSection(BuildContext context) {
    if (widget.dharma.slokas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Slokas'),
        ...widget.dharma.slokas.map((sloka) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${sloka.itemNumber}. ${sloka.text}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                if (sloka.explanation.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    sloka.explanation,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: _fontSize,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _descriptionSection(BuildContext context) {
    if (widget.dharma.description.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        widget.dharma.description,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontSize: _fontSize, height: 1.65),
      ),
    );
  }

  Widget _wordsSection(BuildContext context) {
    if (widget.dharma.words.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Table(
          columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
          border: TableBorder.symmetric(
            inside: BorderSide(color: Theme.of(context).dividerColor),
          ),
          children: widget.dharma.words
              .map(
                (word) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        word.word,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: _fontSize,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        word.meaning,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: _fontSize,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _translationSection(BuildContext context) {
    if (widget.dharma.translation.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(context, 'Translation'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            child: Text(
              widget.dharma.translation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: _fontSize,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ശ്രീനാരായണ ധർമ്മം'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.remove),
            tooltip: 'Decrease font size',
            onPressed: _decreaseFontSize,
          ),
          Center(
            child: Text(
              _fontSize.toStringAsFixed(0),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Increase font size',
            onPressed: _increaseFontSize,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
              child: Text(
                widget.dharma.title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: _fontSize + 8,
                  fontWeight: FontWeight.w800,
                  height: 1.3,
                ),
              ),
            ),
            const Divider(height: 1),
            _slokasSection(context),
            const Divider(height: 1),
            _descriptionSection(context),
            const Divider(height: 1),
            _wordsSection(context),
            const Divider(height: 1),
            _translationSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
