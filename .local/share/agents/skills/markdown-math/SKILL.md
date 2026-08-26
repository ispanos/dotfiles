---
name: markdown-math
description: Write and revise LaTeX-style mathematical notation in Markdown using syntax that renders consistently in VS Code Markdown Preview and Obsidian. Use whenever creating or editing .md files, Obsidian notes, Markdown explanations, README files, or chat-delivered Markdown containing inline or display mathematics, equations, derivations, economic models, or statistical notation. Local Markdown skills and instructions for the target project or directory take precedence over this skill, including for mathematical notation.
---

# Markdown Math

Write math using the portable subset shared by VS Code's Markdown preview and
Obsidian. Preserve the mathematical meaning while prioritizing reliable
rendering in both applications.

## Precedence

Follow Markdown skills and instructions local to the target project or
directory before this skill. They take precedence over every rule here,
including mathematical notation and formatting conventions. Apply this skill
only as a non-conflicting fallback when local guidance does not cover a case.

## Delimiters

- Write inline math with single dollar signs: `$x_t = \beta E_t x_{t+1}$`.
- Write display math with double dollar signs on lines of their own, with blank
  lines before and after the block:

  ```markdown
  $$
  V(a) = \max_{c,a'} \left\{u(c) + \beta E[V(a')]\right\}
  $$
  ```

- Do not use `\(...\)` for inline math or `\[...\]` for display math.
- Do not use `equation`, `displaymath`, or `align` as outer environments.
- Keep inline math on one source line.

For multiple aligned lines, put `aligned` inside a display block:

```markdown
$$
\begin{aligned}
y_t &= c_t + i_t, \\
k_{t+1} &= (1-\delta)k_t + i_t.
\end{aligned}
$$
```

## Portable LaTeX

- Prefer standard commands such as `\frac`, `\sum`, `\int`, `\sqrt`,
  `\left`, `\right`, `\text`, `\operatorname`, `\mathbf`, `\mathbb`, and
  ordinary Greek-letter commands.
- Avoid document-level or package-specific commands, including `\usepackage`,
  `\newcommand`, `\require`, `\label`, and `\ref`.
- Avoid custom macros unless the target note already defines and successfully
  renders them in both applications.
- Use `\text{...}` for short prose inside math rather than leaving bare words.

## Markdown Safety

- Do not wrap intended math in backticks or code fences. Use code formatting
  only when showing the literal Markdown source.
- Inside Markdown tables, replace mathematical pipe characters with `\vert` or
  `\mid`; a literal `|` can split the table cell. Move complicated math outside
  the table when practical.
- Do not escape underscores that are inside math delimiters.
- Escape a literal currency dollar sign in prose as `\$` when it could be
  mistaken for a math delimiter.
- Keep display blocks out of headings and avoid four-space indentation, which
  can turn them into code blocks.

## Editing Workflow

1. Preserve the author's notation and mathematical meaning.
2. Convert `\(...\)` to `$...$` and `\[...\]` to standalone `$$` blocks.
3. Convert outer `equation` or `align` environments to `$$`; use an inner
   `aligned` environment only when alignment is necessary.
4. Check for balanced dollar delimiters and blank lines around every display.
5. Check tables, lists, headings, and code spans for Markdown conflicts.
6. Keep source readable; do not compress a derivation merely to reduce lines.

## Final Check

Before returning or saving Markdown containing math, verify that:

- every inline expression uses `$...$`;
- every display uses standalone `$$` delimiters;
- no display block is interpreted as a code block;
- no literal table pipe occurs inside math; and
- no unsupported document-level LaTeX command remains.
