import 'package:flutter/material.dart';

class GameNode extends StatefulWidget {
  final String title;
  final bool isLocked;
  final VoidCallback? onTap;
  final IconData icon;
  final Color color;

  const GameNode({
    super.key,
    required this.title,
    this.isLocked = false,
    this.onTap,
    this.icon = Icons.videogame_asset,
    this.color = Colors.amber,
  });

  @override
  State<GameNode> createState() => _GameNodeState();
}

class _GameNodeState extends State<GameNode> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isLocked ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final float = widget.isLocked ? 0.0 : _controller.value * 8.0;
          return Transform.translate(
            offset: Offset(0, -float),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: widget.isLocked ? Colors.grey.shade300 : widget.color.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (!widget.isLocked)
                        BoxShadow(
                          color: widget.color.withValues(alpha: 0.4),
                          blurRadius: 12 + (_controller.value * 4),
                          spreadRadius: 2 + (_controller.value * 2),
                        ),
                    ],
                    border: Border.all(
                      color: widget.isLocked ? Colors.grey.shade400 : widget.color,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    widget.isLocked ? Icons.lock : widget.icon,
                    color: widget.isLocked ? Colors.grey.shade600 : Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
