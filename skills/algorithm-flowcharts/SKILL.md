---
name: algorithm-flowcharts
description: Create or review programming flowcharts with bsuir-core using the student's approved construction and wording conventions.
---

# Algorithm flowcharts

Use for programming flowcharts, not numbered textual algorithms. Follow the current assignment and the student's instructions. In this project use Russian and the report's normal typeface for identifiers; do not use Typst backtick markup.

## Sources and algorithm

Before drawing, read the current `bsuir-core/src/block-schemes/construction-style.md`, `writing-style.md`, the constructors in `lib.typ`, and relevant examples: `tree-insertion.typ` and `product-menu.typ` for calls and comments, `loop-example.typ` and `continuation.typ` for loops and connectors. Paths are relative to the marketplace project root. The practice report `../studing-practice/main.typ` refers to the student's original `scheme1.svg` and `scheme2.svg` drawings. Current library constraints take precedence over old dimensions in a project drawing.

Read the whole method and related types, or the agreed design when implementation is unfinished. Trace inputs, outputs, state changes, conditions, iterations, calls and exceptional paths. Identify the method depicted. Ask about behavior that affects scope or has not been agreed; do not silently settle it. Distinguish existing code from provisional design in project notes, including unresolved signatures, ownership, return values, persistence and failure handling.

For this student's course project the instructor expects most substantive actions to be calls shown as predefined processes; ordinary process blocks are mainly for initial data and simple assignments. When implementation is unfinished, propose coherent helper functions as part of the design and document their purpose and provisional status. Their names and decomposition should be practical for future implementation; avoid claiming they already exist or creating wrappers solely to fill blocks. When implementation exists, match its actual calls and behavior and discuss any mismatch instead of inventing calls.

## Wording and detail

- Show the meaningful initialization, conditions, branches, iteration, operations, calls and result of the chosen method. Do not hide essential behavior in ellipses or copy whole source fragments.
- Start with a variables block when relevant: input, intermediate and output data. In the marketplace project use «Вх.», «Пр.» and «Вых.» in the data block as applicable. Give each variable its own line in a compact attached comment in the order «identifier -- meaning, тип X», for example «product -- текущий товар, тип Product*». Omit the C++ qualifier const from displayed types in the marketplace report. Retain pointers, references and template arguments. Keep identifiers and types in the normal typeface. Distinguish inputs, outputs and local state accurately. Use the same identifiers inside action and decision blocks. Specify the traversal order when it determines what «first» and «next» mean.
- For calls use the predefined-process symbol and «ф. name()» followed by the purpose or result. Preserve actual names and case; identify the owning class in the block or an attached comment when needed. Explain important arguments and returns. Proposed function names must be recorded as provisional.
- Write conditions without question marks; label every outgoing branch next to its line and show all applicable paths. Keep pointer depth, types, bounds and data relationships consistent with the code or agreed draft. Use one language for prose.

## Layout and verification

- Plan the flow and every exit before placing nodes. Prefer a compact top-to-bottom main path and one common end. Put related nodes close enough to avoid excessive empty space and long lines, leaving room for labels, loops and comments. Do not stretch a scheme just to fill the page; select a suitable canvas and sheet, respecting reserved frame space.
- Respect the dimensions enforced by the current library. At present ordinary symbols are 40 × 20 mm, terminals 40 × 10 mm and connectors 10 mm across. Do not override node sizes to accommodate text. Use concise wording, line breaks or an attached comment; adjust font size only as needed and keep it readable at the final printed size. Decision text must fit inside the diamond, and call text between its inner bars. Choose page size rather than scaling symbols when more space is needed.
- Use ports and orthogonal routes; minimize unnecessary detours and crossings while maintaining clear direction, branch labels and merges. Do not draw through nodes, comments or text. For the marketplace drawings use at most one continuation (one pair of same-letter connectors) per flowchart. Reserve it for the transition that most benefits from it. Put adjacent calls on the same path and merge branches with a shared destination. Put an arrow on the returning segment at the junction before a loop condition so the direction is visible even when the shared segment already has an arrow. For a longer drawing that appears to require a second pair, rework the layout and consult the student if it still cannot fit legibly. If coordinates or block dimensions change, recalculate ports, bends, merge points, labels and comment leaders rather than blindly scaling the drawing.
- Use library comment facilities: a solid open bracket and dashed attachment line, never a control-flow line. Frames and title blocks are needed for course drawings but are deferred until requested. Do not add captions under appendix drawings when project rules prohibit them.
## Required second pass

After laying out the scheme, compile the complete report. Review the rendered pages as if seeing the drawing for the first time.

1. Count the connector symbols on each drawing. The marketplace limit is two symbols bearing the same letter, with one incoming and one outgoing transition. Follow every branch from its label to the destination, including both loop exits and error paths, and compare with the original algorithm.
2. Inspect the whole page for alignment and large empty gaps, then zoom in to check that text fits inside each shape, comments fit the text closely and sit clear of routes, and arrows and branch labels are unambiguous. Compare the data block with the legend line by line. Verify that each variable includes its type after its meaning and that the loop return arrows point into the correct junctions. Look for adjacent calls separated by a connector, routes that unnecessarily wrap around the drawing, and branches that could share a line.
3. Fix any issue found. Recompile and repeat these checks on the changed pages before handing off. Log provisional behavior in project notes. A clean build alone cannot establish that the drawing is legible or that it matches the algorithm.
