# Report and Typst guide

## Assignment

«Разработка кроссплатформенного приложения „Маркетплейс“», semester 3 of «Программирование на языках высокого уровня» at БГУИР, ФКСиС, кафедра ЭВМ. Student Ермаков Виталий Сергеевич (В. С. Ермаков), group **550503**. Supervisor and consultant А. М. Ковальчук.

- [Лист задания КП ПнаЯВУ](<../../Лист задания КП ПнаЯВУ.doc.pdf>) governs the report structure.
- [СТП 01-2024](../../СТП_01_2024.pdf) governs formatting and takes precedence over the [department guide](../../методичка_КПиЯП.doc.pdf).
- [БГУИР course project regulations](<../../Курсовое проектирование.docx.pdf>) include the assignment form in Appendix Б.

## Structure and content

- Title page, assignment sheet, contents, introduction. The instructor allows the contents at the beginning or end. The current document places it at the beginning. The assignment sheet must fit two pages using layout adjustments while preserving its font and size. Keep «к курсовой работе» off the title page.
- **1 Обзор литературы.** 1.1 covers analogues in 1.1.1 and methods and algorithms in 1.1.2. Cover Wildberries, Ozon, Amazon, and AliExpress, with screenshots only for Wildberries and Ozon. In 1.2 discuss language alternatives in prose and explain that C++ reinforces the course material. Keep discussion of the language in 1.2.1 and the introduction focused on relevance, goal, and tasks. In 1.3 follow the photographed assignment wording as captured in the current draft, omitting its note and adapting the final paragraph. Explain the toolchain and IDE there.
- **2 Функциональное проектирование.** 2.1 covers interface input and file reading and writing. Use logical field types such as `string`, `int`, `bool`, and `перечисление`. Defer machine sizes and encoding details. Use merged cells for nested records, keep category properties inside the category record, and use `record-sheet` for the horizontal product and order tables on one page. Rotate long field labels with `vertical-field`, keep captions and group names horizontal, and omit level numbers. See the [plan](PLAN.md) for the newer flat-table and STL TODOs. Draw the UML class diagram for 2.2 at a suitable drawing size, likely larger than A4. In 2.3 reproduce program declarations with comments.
- **3 Разработка программных модулей.** In 3.1 use two important methods for ГОСТ 19.701-90 flowcharts. In 3.2 use two other methods and numbered steps with explicit «перейти к шагу N» transitions. Choose substantive application methods.
- **4 Результаты работы программы.** Show sample inputs and resulting behavior with screenshots. A screenshot poster can go in an appendix.
- **Заключение**, **Список использованных источников**, then **Приложения**. Use one conclusion section with the runtime environment, OS requirements, unsupported actions, and any inputs or exceptions the program leaves unhandled. Include at least three drawings in the appendices, one UML class diagram and two flowcharts, plus the applicable listing and ведомость.

## Writing

- Use short, impersonal paragraphs, one where it suffices. Introduce each table in the prose. Use quotes in Typst for product, language, and OS names so that they render as «ёлочки». Use `#file-name("users.bin")` for filenames. Write data types and identifiers in the normal document font without Typst backtick markup, as requested by the student.
- Keep generic claims about processing, “current version” caveats, and deferred features out of 2.1. Include concrete implementation mechanisms only when the student uses and can explain them. The agreed password-hash field is a logical data field. Its algorithm remains open.
- Cite relevant material actually used. Official Java and Python references support their brief discussion as alternatives. Prefer the analogue sites, cppreference, Qt/CMake/Qt Creator documentation, and the department guide as applicable. Format references per ГОСТ, include access dates for online sources, and order entries by first citation.
- See `../studing-practice/main.typ` from the project root for merged cells in nested data tables, brief explanations, and numbered algorithm steps. Its C structs and fixed arrays are specific to that project. See `../aalub-courseproject-1/` for a main Typst file that includes chapters.

## Formatting and verification

- A4, 30 mm left, 15 mm right, 20 mm top and bottom. Use Times New Roman 14 pt, a 1.25 cm paragraph indent, justified text, and an 18 pt line step. Keep optical punctuation overhang disabled. Verify the rendered text and footer separately.
- Page numbering runs from the title page and is displayed after the contents. The lower edge of the footer digits is 10 mm above the bottom edge per Appendix Л. The `stp` footer controls numbered pages, `no-page-number()` suppresses the contents page number, and the assignment sheet retains `footer: none`.
- Begin each numbered section on a new page, in bold uppercase, with the number followed by a space. Subsections use bold sentence case. Omit final periods and hyphenation in headings. Center unnumbered headings such as ВВЕДЕНИЕ, ЗАКЛЮЧЕНИЕ, СОДЕРЖАНИЕ, and СПИСОК ИСПОЛЬЗОВАННЫХ ИСТОЧНИКОВ.
- Leave one blank line between headers and text and around tables with captions. Keep table captions left-aligned above the table and figure captions centered below the figure. Number by section. Use «Продолжение таблицы 1.1» on continuation pages when applicable.
- The report uses `stp` from the friend's library, with an explicit 18 pt line step. The library controls heading and figure spacing, table continuation, numbering, and the footer. The project retains custom source references and list rules. Check these interactions when editing layout.
- Use `-` for simple lists. The project show rule after `stp` supplies the en dash from the paragraph indent and trailing punctuation. Wrap lines from the left margin and keep the 18 pt line step, including between items. Use `+` for numbered items made of sentences. Write each item with an initial capital and final period. Use «а)», «б)», then nested «1)» for items cited individually, for example «в пункте 1.7, б». End the lead-in with a complete phrase. Avoid bold labels inside prose paragraphs.
- Use automatic references everywhere. In `references.typ` write `#source[...]` with a label and use `@key` in the text. Use `fig-` and `tab-` labels for figures and tables. Escape a literal numbered line start such as `1\.`.
- Use Cyrillic appendix letters excluding Ё, З, Й, О, Ч, Ь, Ъ, Ы, with «(обязательное)» below the heading. In UML use `+`, `–`, and `#` for visibility. Allow 3–6 pages for the cited literature review and 25–35 pages for the report excluding appendices.

## Typst files

`main.typ` contains the shared rules and introduction, and includes the assignment sheet, chapters, and references. The title lives in `title.typ` and uses `title-page` from `bsuir-core`. The `task` dictionary lives in `task-sheet.typ`. Included files import what they use. The report imports `stp` through the `bsuir-core` symlink to `../bsuir-core`. The title and assignment sheet precede the `stp` show rule to preserve their layout.

Compile and preview `main.typ` for global styling and cross-file references. Pin it in PyCharm when using Scribe Pro. A separate `template.typ` was discussed and has not been implemented. See the [preview note](scribe-preview-fix.md) for the local plugin fix and its verification status.
