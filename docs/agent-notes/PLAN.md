# Course project plan

## Where work stopped

- The title page, assignment sheet, contents, introduction, literature review, and references are drafted. Section 2.1 is the last written section. Sections 2.2, 2.3, 3, and 4, the conclusion, and appendices are pending.
- Section 2.1 lists four individual files and two groups of files for products and orders. It has nested tables for categories, products, and orders, plus tables for cart items and reviews. The `users.bin` field list was omitted at the student's request because the file inventory already identifies its contents. One TODO comment about containers remains in the source.
- This repository contains the Typst report. No C++/Qt implementation is tracked here. Verify implementation progress and location with the student before describing it.
- Assignment schedule for 2026. Issued 15 September. Task selection and section 1 due 1 October, sections 2–3 due 1 November, results and conclusion due 1 December, sources due 11 December, report and drawings due 15 December, and defense 21–28 December.

## Section 2.1 TODOs

These items correspond to the original six comments in [the source](../../02-functional-design.typ#L32). The order below reflects dependencies.

| Status | Source TODO | What needs to happen |
| --- | --- | --- |
| Done | Reference `<tab-data-files>` | Added the reference before the file table. |
| Done | Consider one seller | The student chose one seller for the entire application. The order is confirmed as a whole. The draft no longer stores seller IDs in product records or divides orders into seller shares. |
| In progress | Split storage | The student chose binary product files by category and binary order files by buyer, named by ID in separate directories. Products do not move between categories. Section 2.1 uses `products/<id>.bin` and `orders/<id>.bin` as working directory names. Categories are neither deleted nor hidden. Product ID lookup and concurrent file updates remain to be designed. |
| Done | Turn field lists into tables | Converted the cart-item and review lists to tables. The user record remains omitted as previously requested. |
| Decision | Choose STL containers | Choose STL uses alongside the required custom containers, iterators, and algorithms once the data and operations are clear. Document actual choices in the report after agreement. |
| In progress | Remove or relocate the commented limits table | Removed the commented table from Typst. The proposed limits remain in the [data notes](section-2-1-plan.md). Confirm whether any limits belong in a user guide. |

After agreeing on storage, check the file inventory, record layouts, and prose against the selected model. Keep unfinished choices here or in the data notes. Compile the full report and check table numbering, links, and page fit after the edits.

## Typst package migration

The report imports `stp` and `title-page` from the student's friend's `bsuir-core` repository, version 0.1.0, through the project symlink. The title and assignment sheet are placed before `stp` to retain their layout. The 18 pt line step is explicit because the package currently defaults to 16 pt. Project list rules follow `stp` so that simple lists receive punctuation and complex lists receive numbers. Old formatting rules overridden by `stp` were removed after a page-by-page comparison of the rendered PDF, extracted text and link counts. The 18 pt step between simple-list items and the footer position were checked in the PDF. The contents page number is suppressed, with numbering displayed from the introduction onward.

## Backlog

- PyCharm preview is being handled by the student in another chat. See [the preview notes](scribe-preview-fix.md).
- Revisit nested lists and lettered items for cross-references if needed. Current list overrides cover the flat lists used in the report.
- If the contents grows to multiple pages, check that page numbers are hidden on all its pages.
- The source list includes Qt Creator documentation and the department guide without active citations in the report. Section 1.3 also lacks the planned explanation of the chosen environment. Resolve these together when writing resumes, preserving first-citation order.

## Remaining work

1. Finish the data model and section 2.1. Confirm file formats, record relationships, validation, history, shared-file access, and undo scope with the student where those choices affect the design.
2. Develop the class hierarchy and UML drawing for 2.2. Use at least three levels of inheritance. Coordinate its design with the implementation. In 2.3, reproduce actual class declarations with comments.
3. Implement and verify the agreed application requirements. Choose four distinct implemented methods for chapter 3. Give two substantial methods ГОСТ 19.701-90 flowcharts and describe two other methods in numbered steps with explicit transitions.
4. For chapter 4, capture inputs and results from the running application. Write the conclusion with launch requirements and actual limitations. Complete the appendices with the three required drawings and applicable submission materials.
5. Check the complete PDF against the assignment sheet and СТП. Verify page numbering, references and captions, layout, and report length.

## Handoff sources

- Claude Code project conversations from September and the historical `CLAUDE.md` in Git describe the initial scope, written style, and the instructor's oral notes. The longer local Claude Code transcript starts with session ID `30f42d08`.
- Codex project conversations from 11–12 October are stored under the earlier workspace spelling `phll-courceproject-3sem`. They record the assignment-photo edits, decisions about 2.1, formatting checks, and preview work. The main October session starts with `01a12c70`.
- The current Typst sources and Git commits `c8e68a7` and `3f7efed` establish the latest report state. The six comments in `c8e68a7` postdate the earlier data-layout discussion.
