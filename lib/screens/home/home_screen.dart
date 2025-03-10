import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scroller_providers.dart';
import '../../models/scroller.dart';
import 'widgets/scroller_card.dart';

/// 首頁畫面
/// 顯示所有已建立的Scroller列表
/// 提供建立新Scroller和群組的入口
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isSelectionMode = false;
  final Set<String> _selectedItems = {};

  @override
  Widget build(BuildContext context) {
    final scrollers = ref.watch(scrollersProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 添加 "Led Scroller" 標題
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Led Scroller',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // App Logo and Create New Button
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [Colors.blue, Colors.purple, Colors.red],
                          ),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            // Clear current scroller before creating a new one
                            ref.read(currentScrollerProvider.notifier).state = null;
                            context.push('/create');
                          },
                          child: const Text('+ Create New'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // My Collections Section with Action Buttons
              const Text(
                'My collections',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons Row (Delete and Create Group)
              Row(
                children: [
                  // Delete Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSelectionMode ? _deleteSelected : _enterSelectionMode,
                      icon: const Icon(Icons.delete),
                      label: Text(_isSelectionMode ? 'Delete Selected' : 'Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2A3E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Create Group Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Clear selections before creating a group
                        ref.read(selectedScrollersProvider.notifier).clear();
                        context.push('/create-group');
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Create group'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2A2A3E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selection Mode Indicator & Cancel Button
              if (_isSelectionMode) ...[
                Row(
                  children: [
                    Text(
                      'Selected: ${_selectedItems.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _exitSelectionMode,
                      child: const Text('Cancel'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],

              // 將整個列表放入一個帶框的 Card 中
              Expanded(
                child: Card(
                  margin: const EdgeInsets.only(top: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xFF2A2A3E), // 設定與設計稿相符的深色背景
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: scrollers.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                      itemCount: scrollers.length,
                      itemBuilder: (context, index) {
                        final scroller = scrollers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: _isSelectionMode
                              ? _buildSelectableCard(scroller)
                              : ScrollerCard(
                            scroller: scroller,
                            onEdit: () {
                              // 修改流程：點擊scroller時直接進入Preview頁面，而不是Edit頁面
                              ref.read(currentScrollerProvider.notifier).state = scroller;
                              context.push('/preview');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectableCard(Scroller scroller) {
    final isSelected = _selectedItems.contains(scroller.id);

    // Convert hex string to color
    final backgroundColor = Color(int.parse(scroller.backgroundColor.replaceAll('#', '0xFF')));
    final textColor = Color(int.parse(scroller.textColor.replaceAll('#', '0xFF')));

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedItems.remove(scroller.id);
          } else {
            _selectedItems.add(scroller.id);
          }
        });
      },
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          )
              : BorderSide.none,
        ),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: backgroundColor,
              ),
              child: Text(
                scroller.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: scroller.fontSize.toDouble(),
                  fontFamily: scroller.fontFamily,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
      _selectedItems.clear();
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedItems.clear();
    });
  }

  void _deleteSelected() {
    if (_selectedItems.isEmpty) return;

    // Convert to List<String> to avoid concurrent modification and type issues
    final itemsToDelete = _selectedItems.toList();
    ref.read(scrollersProvider.notifier).deleteSelectedScrollers(itemsToDelete);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${itemsToDelete.length} scrollers deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Add the scrollers back if user presses undo
            // This would require keeping a copy of deleted scrollers
            // Not implemented in this example
          },
        ),
      ),
    );

    _exitSelectionMode();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.text_fields_rounded,
            size: 64,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 16),
          Text(
            'No scrollers yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first LED scroller',
            style: TextStyle(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}