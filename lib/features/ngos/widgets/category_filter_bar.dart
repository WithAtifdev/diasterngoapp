import 'package:flutter/material.dart';

class CategoryFilterBar<T> extends StatelessWidget {
  final List<T> categories;
  final T selected;
  final String Function(T) labelOf;
  final void Function(T) onSelected;
  final Color activeColor;

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
    this.activeColor = const Color(0xFF2196F3),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final isSelected = cat == selected;
          return GestureDetector(
            onTap: () => onSelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.2)
                    : const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? activeColor : Colors.white12,
                ),
              ),
              child: Text(
                labelOf(cat),
                style: TextStyle(
                  color: isSelected ? activeColor : Colors.white60,
                  fontSize: 13,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}