import 'package:flutter/material.dart';

class InnerCard extends StatefulWidget {
  final Widget content;
  final Function onPressed;
  final bool showStar;
  final Function onStar;
  final bool isStarred;

  const InnerCard({
    super.key,
    this.content = const Text('n/a'),
    this.showStar = false,
    this.isStarred = false,
    required this.onStar,
    required this.onPressed,
  });

  @override
  State<InnerCard> createState() => _CardState();
}

class _CardState extends State<InnerCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 11),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFF444444),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.showStar) ...[
              GestureDetector(
                onTap: () {
                  widget.onStar();
                },
                child: Icon(
                  widget.isStarred ? Icons.star : Icons.star_border,
                  color: Colors.orangeAccent
                      .withOpacity(widget.isStarred ? 1 : 0.5),
                ),
              )
            ] else
              ...[],
            Expanded(
                child: GestureDetector(
              onTap: () {
                widget.onPressed();
              },
              child: Center(
                child: widget.content,
              ),
            ))
          ],
        ),
      ),
    );
  }
}
