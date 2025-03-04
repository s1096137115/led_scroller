import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/scroller_providers.dart';
import '../../models/scroller.dart';
import 'widgets/scroller_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollers = ref.watch(scrollersProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // My Collections Section with Group Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My collections',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Clear selections before creating a group
                      ref.read(selectedScrollersProvider.notifier).clear();
                      context.push('/create-group');
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create group'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Scrollers List or Empty State
              Expanded(
                child: scrollers.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                  itemCount: scrollers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ScrollerCard(
                        scroller: scrollers[index],
                        onEdit: () {
                          // Set current scroller for editing
                          ref.read(currentScrollerProvider.notifier).state = scrollers[index];
                          context.push('/create');
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
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