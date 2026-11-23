# Course project plan

## Where work stopped

- The title page, assignment sheet, contents, introduction, literature review, and references are drafted. Section 2.1 and the reference to the class diagram in 2.2 are drafted. Section 2.3 remains to be written from reviewed class declarations. Sections 3.1 and 3.2 and three appendix drawings have preliminary drafts. Section 4 and the conclusion are pending.
- Section 2.1 lists four individual files and two groups of files for products and orders. It has nested tables for categories, products, and orders, plus tables for cart items and reviews. The `users.bin` field list was omitted at the student's request because the file inventory already identifies its contents. One TODO comment about containers remains in the source.
- `src/` contains copies of the student's `BinaryTree`, its traversal code, and `String` from the semester 2 lab. `src/` has draft `Account → User → Buyer/Seller/Administrator` declarations and records for products, categories, reviews, carts, and orders. `CategoryProducts` contains a product tree for one category. Product property values use a class hierarchy chosen by the student and a map keyed by property ID. The temporary sorting tree uses FilteredProduct with a comparator supplied at construction. The demonstration defines the comparator, including ID order for equal keys and missing values last. Property comparison, lookup and ProductFilter are implemented. Most other model operations are declarations. The category property collection and cart and order item lists use `std::vector` as a working choice. Initial values such as `parent_id = 0` are placeholders and do not establish a root-category encoding. Diagramator's source analyzer is used for preliminary checks.
- The filtering diagram uses a temporary tree of entries referring to products in the category tree. Its missing-value branch follows the configurable default in `src/FilterSettings.h`; ProductFilter::matches() implements the per-product predicate. The order diagram includes coordinated access around stock checks and updates, but the mechanism and recovery from file-write failures remain open.
- The revised flowcharts use the provisional methods `Buyer::place_order()` and `CategoryProducts::filter()`. Most actions in the drawings are proposed function calls to match the instructor’s convention. The filtering diagram uses the implemented PropertyValue comparison operators and Product::get_property_value(). The traversal helper labels and checkout helpers are provisional. `update_stock()` must process every order item; `save_order()` represents saving both the order and updated stocks, with failure recovery still open. `clear_result()` assumes the output tree is emptied before filtering; confirm this contract when implementing. Keep traversal and comparison helpers practical for the custom tree and iterator rather than mechanically creating wrappers for every block. The drawings need reconciliation with the code; the filtering drawing expands the matching logic inline; `ProductFilter::matches()` implements the same inner loop. The checkout method returns `bool` in the draft, but the meanings of its return values and recovery from partial write failures are not agreed and are not shown as settled behavior. Reconcile the drawings with the implementations and their return paths later.
- Flowchart variable names that do not appear in the C++ declarations are provisional. The filter label allow_missing denotes INCLUDE_PRODUCTS_WITH_MISSING_PROPERTY.
- Appendix А is a Diagramator-generated class diagram; Б and В are flowcharts for checkout and filtering. They are preliminary: the classes and algorithms must be reconciled as the code is developed. The drawings use the shared bsuir-core drawing-sheet. The class diagram is on A1 landscape, and both flowcharts are on A2 portrait. The revised class layout and manual connection anchors are saved in `src/diagramator.json`. The report export excludes Composition and Dependency, matching the selected visibility in Diagramator. The current dev build applies these switches to the canvas and resets them when restarted. The current Typst exporter centers the template label on the upper right corner, matching the editor. Older exporter builds may place it entirely above the box. Its save and export actions can still write unfiltered relations, so compare the export with the selected visibility after saving from the editor.
- Assignment schedule for 2026. Issued 15 September. Task selection and section 1 due 1 October, sections 2–3 due 1 November, results and conclusion due 1 December, sources due 11 December, report and drawings due 15 December, and defense 21–28 December.
- Keep the draft C++ files directly in src. Appendix Г reads the headers from that directory and formats the comments for print. Implementation files and the demonstration entry point are deferred at the student's request.

## Draft stepwise algorithms

- [Runnable demonstration of all four algorithms](../../examples/algorithms.cpp) uses the lab BinaryTree and String with sample model types. Checkout stores orders in memory and coordinates calls within a process. The model types, file storage and coordination across application instances still need to be integrated.

- Types in the report that lack C++ declarations are working choices. In particular, SortCriterion, SortDirection, SortValue and the sorted output container describe the draft, not the implemented API. The checkout output status names the declared bool return. Its mapping to branches remains open. The report uses provisional names for undeclared locals and sorting inputs. The tree is temporary, filtered is its input, and left and right are keys computed by the comparator. Reconcile the names with the implementation.

- `Category::collect_properties()` is declared but not implemented. The report draft assumes that `result` is cleared first and characteristics are collected from the selected category towards the root. Confirm the output-list contract, category lookup and handling of inconsistent parent references during implementation.
- The sorting implementation is in the demonstration. It uses a second BinaryTree<FilteredProduct> with a custom comparator, zero for unrated products, missing optional values last in either direction and product ID for ties. Integrate it into the application once the lifetime of references during catalog updates is defined.

## Section 2.1 TODOs

These items correspond to the original six comments in [the source](../../02-functional-design.typ#L32). The order below reflects dependencies.

| Status | Source TODO | What needs to happen |
| --- | --- | --- |
| Done | Reference `<tab-data-files>` | Added the reference before the file table. |
| Done | Consider one seller | The student chose one seller for the entire application. The order is confirmed as a whole. The draft no longer stores seller IDs in product records or divides orders into seller shares. |
| In progress | Split storage | The student chose binary product files by category and binary order files by buyer, named by ID in separate directories. Products do not move between categories. Section 2.1 uses `products/<id>.bin` and `orders/<id>.bin` as working directory names. Categories are neither deleted nor hidden. Product ID lookup and concurrent file updates remain to be designed. |
| Done | Turn field lists into tables | Converted the cart-item and review lists to tables. The user record remains omitted as previously requested. |
| In progress | Choose containers | The student chose the lab `BinaryTree` and `String`. Determine their application and required adaptation, then agree on STL usage and custom algorithms. |
| Done | Remove or relocate the commented limits table | The student chose limits for the application and asked to keep them outside the explanatory note. They are recorded in the [data notes](section-2-1-plan.md). |

After agreeing on storage, check the file inventory, record layouts, and prose against the selected model. Keep unfinished choices here or in the data notes. Compile the full report and check table numbering, links, and page fit after the edits.

## Typst package migration

The report imports `stp` and `title-page` from the student's friend's `bsuir-core` repository, version 0.1.0, through the Git submodule at bsuir-core. Initialize it after cloning with git submodule update --init. The title and assignment sheet are placed before `stp` to retain their layout. The 18 pt line step is explicit because the package currently defaults to 16 pt. Project list rules follow `stp` so that simple lists receive punctuation and complex lists receive numbers. Old formatting rules overridden by `stp` were removed after a page-by-page comparison of the rendered PDF, extracted text and link counts. The 18 pt step between simple-list items and the footer position were checked in the PDF. The contents page number is suppressed, with numbering displayed from the introduction onward.

## Backlog

- PyCharm preview is being handled by the student in another chat. See [the preview notes](scribe-preview-fix.md).
- Revisit nested lists and lettered items for cross-references if needed. Current list overrides cover the flat lists used in the report.
- If the contents grows to multiple pages, check that page numbers are hidden on all its pages.
- Confirm the document codes and the remaining title-block fields.
- The source list includes Qt Creator documentation and the department guide without active citations in the report. Section 1.3 also lacks the planned explanation of the chosen environment. Resolve these together when writing resumes, preserving first-citation order.

## Remaining work

1. Finish the data model and section 2.1. Confirm file formats, record relationships, validation, history, shared-file access, and undo scope with the student where those choices affect the design. Keep field-length limits outside the explanatory note.
2. Draft the application classes in `src/` in parallel with section 2. Develop a meaningful hierarchy with at least three levels of inheritance. Generate the UML class drawing with Diagramator at `/home/slavita/Documents/typst-projects/diagramator` for 2.2. In 2.3, reproduce the actual class declarations with comments. The code is initially a diagram draft and will later be moved into the Qt project and improved to match the labs.
3. In section 3.1, draw two important methods: placing an order and filtering products by category and characteristics. Use `bsuir-core/src/block-schemes` and ГОСТ 19.701-90. In 3.2, describe two different methods step by step with explicit transitions: collecting inherited category properties and sorting the result list by the selected criterion. Keep diagrams and prose consistent with the draft code. Prepare the required two flowchart drawings in the appendices.
4. For chapter 4, capture inputs and results from the running application. Write the conclusion with launch requirements and actual limitations. Complete the appendices with the three required drawings and applicable submission materials.
5. Check the complete PDF against the assignment sheet and СТП. Verify page numbering, references and captions, layout, and report length.

The frames and title blocks are in the report. Review the fit again after any changes to the diagrams.

## Handoff sources

- Claude Code project conversations from September and the historical `CLAUDE.md` in Git describe the initial scope, written style, and the instructor's oral notes. The longer local Claude Code transcript starts with session ID `30f42d08`.
- Codex project conversations from 11–12 October are stored under the earlier workspace spelling `phll-courceproject-3sem`. They record the assignment-photo edits, decisions about 2.1, formatting checks, and preview work. The main October session starts with `01a12c70`.
- The current Typst sources and Git commits `c8e68a7` and `3f7efed` establish the latest report state. The six comments in `c8e68a7` postdate the earlier data-layout discussion.
