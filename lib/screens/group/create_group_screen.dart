import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/group.dart';
import '../../providers/scroller_providers.dart';
import '../../providers/group_providers.dart';

/// 建立群組頁面
/// 允許用戶選擇多個Scroller並設定播放順序
/// 提供重複播放次數設定
class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nameController = TextEditingController(text: 'New Group');
  int _repeatTimes = 1;
  bool _repeatForever = false;
  final Map<String, int> _scrollerOrders = {};

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveGroup() {
    final selectedIds = ref.read(selectedScrollersProvider);

    if (selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one scroller')),
      );
      return;
    }

    // Ensure all selected scrollers have an order
    for (final id in selectedIds) {
      if (!_scrollerOrders.containsKey(id)) {
        _scrollerOrders[id] = _scrollerOrders.length + 1;
      }
    }

    final group = ScrollerGroup.create(
      name: _nameController.text,
      scrollerIds: selectedIds,
      scrollerOrder: Map.from(_scrollerOrders),
      repeatTimes: _repeatTimes,
      repeatForever: _repeatForever,
    );

    ref.read(groupsProvider.notifier).addGroup(group);
    ref.read(selectedScrollersProvider.notifier).clear();

    context.pop();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Group created'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scrollers = ref.watch(scrollersProvider);
    final selectedIds = ref.watch(selectedScrollersProvider);

    // Filter out scrollers that are already in groups
    final availableScrollers = scrollers.where((s) => !s.isInGroup).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveGroup,
          ),
        ],
      ),
      body: Column(
        children: [
          // Group name input
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Selected count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  'Selected ${selectedIds.length} of ${availableScrollers.length}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: availableScrollers.isEmpty ? null : () {
                    ref.read(selectedScrollersProvider.notifier)
                        .selectAll(availableScrollers.map((s) => s.id).toList());

                    // Auto-assign order based on selection
                    int order = 1;
                    for (final id in ref.read(selectedScrollersProvider)) {
                      _scrollerOrders[id] = order++;
                    }
                  },
                  child: const Text('Select All'),
                ),
                TextButton(
                  onPressed: selectedIds.isEmpty ? null : () {
                    ref.read(selectedScrollersProvider.notifier).clear();
                    _scrollerOrders.clear();
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),

          // Available scrollers
          Expanded(
            child: availableScrollers.isEmpty
                ? const Center(child: Text('No available scrollers'))
                : ListView.builder(
              itemCount: availableScrollers.length,
              itemBuilder: (context, index) {
                final scroller = availableScrollers[index];
                final isSelected = selectedIds.contains(scroller.id);

                return ListTile(
                  leading: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      if (value == true) {
                        ref.read(selectedScrollersProvider.notifier).select(scroller.id);
                        _scrollerOrders[scroller.id] = _scrollerOrders.length + 1;
                      } else {
                        ref.read(selectedScrollersProvider.notifier).unselect(scroller.id);
                        _scrollerOrders.remove(scroller.id);

                        // Reorder remaining items
                        final newOrders = <String, int>{};
                        int order = 1;
                        for (final entry in _scrollerOrders.entries) {
                          if (selectedIds.contains(entry.key)) {
                            newOrders[entry.key] = order++;
                          }
                        }
                        _scrollerOrders.clear();
                        _scrollerOrders.addAll(newOrders);
                      }
                    },
                  ),
                  title: Text(
                    scroller.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: isSelected
                      ? SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          child: Text(
                            '${_scrollerOrders[scroller.id] ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward),
                          onPressed: () {
                            setState(() {
                              final currentOrder = _scrollerOrders[scroller.id] ?? 0;
                              if (currentOrder > 1) {
                                // Find the item with the previous order
                                final prevId = _scrollerOrders.entries
                                    .firstWhere((e) => e.value == currentOrder - 1)
                                    .key;

                                // Swap orders
                                _scrollerOrders[prevId] = currentOrder;
                                _scrollerOrders[scroller.id] = currentOrder - 1;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  )
                      : null,
                );
              },
            ),
          ),

          // Repeat settings
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Repeat Settings',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: SwitchListTile(
                        title: const Text('Repeat Forever'),
                        value: _repeatForever,
                        onChanged: (value) {
                          setState(() {
                            _repeatForever = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (!_repeatForever) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Repeat Times:'),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Slider(
                          value: _repeatTimes.toDouble(),
                          min: 1,
                          max: 10,
                          divisions: 9,
                          label: _repeatTimes.toString(),
                          onChanged: (value) {
                            setState(() {
                              _repeatTimes = value.toInt();
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$_repeatTimes',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(selectedScrollersProvider.notifier).clear();
                    context.pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  onPressed: _saveGroup,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}