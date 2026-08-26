---
name: latex-writing
description: Create, revise, and review readable, maintainable LaTeX source while preserving authorial intent and rendered output. Use when writing or editing .tex files for papers, theses, books, presentations, or technical documents; applying semantic line breaks; improving source readability; managing structural comments and TODOs; deciding source-file organization; or reviewing LaTeX diffs.
---

# LaTeX Writing

Improve the maintainability of LaTeX source
without changing the author's intended meaning or rendered output.

## Inspect the project

1. Read applicable repository instructions.
2. Inspect the main document, preamble, custom commands,
   nearby source, and build configuration relevant to the task.
3. Follow established terminology, macros, file organization,
   and formatting conventions.
4. Treat project conventions as authoritative over this skill's defaults.

## Preserve the author's work

- Preserve wording, voice, mathematical notation, equations,
  citations, labels, comments, and custom commands
  unless the task explicitly requires changing them.
- Never invent citation keys, references, results, or source material.
- Make the smallest coherent edit that fulfills the request.
- Avoid reformatting or reflowing unrelated text.
- Keep semantic changes separate from broad formatting changes
  whenever the task permits.

## Use semantic line breaks

- Apply semantic line breaks to new or substantially revised prose.
- Start a new source line after each complete sentence.
- Break long sentences at meaningful clause or phrase boundaries.
- Place logically parallel elements on separate lines when useful.
- Aim for roughly 60--80 characters per line,
  but prioritize logical structure over a rigid width.
- Allow longer lines for indivisible commands, command arguments,
  inline mathematics, URLs, and other markup
  when splitting them would reduce clarity.
- Ensure source-only line breaks do not change the rendered document.
- Do not reflow untouched paragraphs merely to enforce line length.
- Use blank lines only where LaTeX should begin a new paragraph.

## Use comments deliberately

- Preserve existing comments, TODO markers, and annotations.
- Add comments only when they clarify non-obvious intent,
  document structure, or unfinished work.
- Do not add a summary comment to every paragraph mechanically.
- Follow editor-specific folding conventions only when the project uses them.
- Do not remove or silently resolve TODOs unless requested.

## Respect document organization

- Preserve the existing single-file or multi-file organization
  unless the user asks for restructuring.
- Prefer a single main source file for a new short paper
  when no project convention dictates otherwise.
- Split a new long work at natural boundaries such as chapters
  when this improves navigation or selective compilation.
- Keep inclusions and paths consistent with the project's existing approach.

## Validate the edit

1. Inspect the diff for accidental prose reflow,
   lost comments, broken commands, and unrelated changes.
2. Run the project's existing build or lint command when available
   and proportionate to the task.
3. Check warnings or errors relevant to the changed source.
4. Report what was validated and any checks that could not be run.
