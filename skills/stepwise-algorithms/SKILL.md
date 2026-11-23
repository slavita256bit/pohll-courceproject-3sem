---
name: stepwise-algorithms
description: Write or review numbered algorithm descriptions for programming reports using the student's training-practice style and supplied source code.
---

# Step-by-step algorithm descriptions

Use this skill for textual algorithms in programming reports. Follow the assignment, the student's current instructions, and the report's language and formatting rules first. For the marketplace project, use Russian and normal document typeface for identifiers; do not use Typst backtick markup.

## Evidence and scope

- Read the actual function or method and its relevant types before writing. Trace branches, loops, returns, side effects, and error paths. Do not claim that a declaration implements an algorithm. If only a proposed design is available, identify the result as a draft and do not invent implementation details.
- Use the student's training-practice report as the primary local style example: `../studing-practice/main.typ`, sections «Алгоритм функции tree_add_element()» and «Алгоритм функции tree_save_direct()», relative to the marketplace project root. The supplied Belarusian C-lab prompt is a supplementary example, not an overriding assignment.
- Ask the student when an unresolved design choice changes the algorithm's behavior. Do not fill gaps with invented functions or values.

## Structure

Introduce the function and its purpose briefly. In the marketplace report use separate «Входные данные», «Промежуточные данные» and «Выходные данные» groups as applicable. Use simple Typst lists with `-` and write each item as «identifier -- meaning, тип X». Omit the C++ qualifier const from displayed types in the marketplace report. Retain pointers, references and template arguments. Include outputs written through parameters. Explain the concrete choices represented by a selector such as criterion, including what identifies the selected characteristic when applicable. Include a signature or task statement only if the assignment or student asks for it. Do not add laboratory numbers or a Word-specific layout to a course report.

Write a numbered list of complete, concise sentences. Following the student's practice, the first numbered step is «Начало.» and the last is «Конец.». Declare or initialize variables when that is relevant to the actual algorithm; do not invent a declaration step for a function without local variables. Inputs are parameters, not newly declared local variables.

Describe concrete operations in execution order. Keep a step focused on the action performed there. Put a longer rule shared by operations, such as how keys are compared, before the numbered steps when it makes the steps easier to follow. Pair meaningful data objects with their identifiers in the input/output description and in the steps that initialize, read, test, or update them. In this project write «бинарное дерево tree», «текущий товар product», and «список result». Use code identifiers exactly. For a draft, choose consistent provisional names for unnamed objects and record that status in project notes. Simple loop indices can be named directly. Use terms consistent with the code. Mention meaningful calls, assignments, output, returns and resource management where they occur, without expanding helper functions into unsupported detail.

For each condition, describe the condition and its action, including the alternative when needed. Make all non-obvious branches and early exits explicit with valid numbered transitions. For loops, state the iteration or continuation condition and a separate end-of-loop step, as in the practice report. Describe recursive calls and their stopping condition explicitly. Do not add a transition to the next consecutive step mechanically to every sentence.

## Required second pass

After drafting or editing, reread the rendered description and compare it with the source or agreed draft.

1. Read every numbered step. Check that each named object has a clear role and that the description of a key input, local or result includes its identifier at the point of use. Verify spelling, case and types. Check that each item in the data lists ends with «, тип X» and that enumerations and other selectors have concrete meanings. Check that Typst displays identifiers and angle brackets in the normal typeface.
2. Follow the numbered transitions by hand. Trace an ordinary run and each distinct exit, including empty inputs when applicable. Verify loop bounds, order, state changes and the result. Compare against the previous version when asked to preserve the algorithm. Keep unresolved implementation details in project notes.
3. Fix any naming, meaning, numbering or page layout problem and check the revised output again before handing off.
