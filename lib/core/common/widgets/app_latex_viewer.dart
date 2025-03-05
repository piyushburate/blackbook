import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class AppLatexViewer extends StatelessWidget {
  final String data;
  final TextStyle? style;
  final int? maxLines;
  const AppLatexViewer(this.data, {super.key, this.style, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return GptMarkdown(
      data,
      style: style ?? Theme.of(context).textTheme.titleSmall,
      maxLines: maxLines,
      latexBuilder: (context, tex, style, inline) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: GptMarkdown(
            "\$\$ $tex \$\$",
            style: this.style ?? Theme.of(context).textTheme.titleSmall,
          ),
        );
      },
    );
  }
}
