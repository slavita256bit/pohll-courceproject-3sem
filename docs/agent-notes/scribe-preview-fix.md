# Scribe Pro preview in PyCharm

## Language-server null-default correction

The user reported that the Problems tab still showed the missing labels. The
PyCharm log revealed that the prior synchronizer failed before sending the pin:
`PropertiesComponent.getValue` rejects a null default value. The test stub had
not enforced that IntelliJ API constraint. The corrected helper uses an empty
default and treats it as an invalid file. Its test now rejects null defaults and
passes pin, unpin, duplicate and missing-file cases. A prepared JAR changes only
`PinSynchronizer.class` relative to the prior installed JAR. With PyCharm closed,
the corrected JAR was installed and its SHA-256 verified as
`5ec1d1b88d9d65e613bb965ee9b61e8eaba72300374a01fcce4bbf0c8b012062`.
The user confirmed that everything works after the correction.

## Language-server diagnostics patch, 20 November 2026

The user confirmed that embedded preview works, but its chapter still showed
missing labels in the Problems tab. Scribe's pin action only saves a project
property; it did not send Tinymist's `tinymist.pinMain` command. A direct LSP
test reproduced ten missing-label errors, then sent the pin command after
opening the chapter: the errors cleared, and a deliberately introduced missing
label was subsequently reported. The injected test was in memory only.

The installed 2026.2.11 JAR now forwards the saved pin to Tinymist when a Typst
document is opened or edited. It sends an unpin when a previously applied pin is
cleared or becomes invalid. A changed pin takes effect on the next open or edit;
restart the language server if needed. The pin applies to the project language
server, including files outside the main document. Initial standalone diagnostics
may briefly appear before the pin command takes effect.

Bytecode verification passed, and focused tests covered pin, unpin, duplicate
events and missing files. Archive comparison showed only the connection provider
changed and one helper added. Live PyCharm verification remains outstanding.
Sources, the LSP probe and the previous JAR are in
`scribe-lsp-patch-20261120/`. To restore the previous preview and extractor fixes,
close PyCharm and copy `previous.jar` from that directory over the installed JAR,
after checking that the installed plugin is still version 2026.2.11.

## Second patch, 20 November 2026

The user confirmed the error appears in the embedded preview after updating
Tinymist and restarting. The IDE log recorded a preview process using `main.typ`.
Bytecode inspection showed that the preview also displays error highlights
collected from the open editor, in addition to its own compiler output. Those
editor diagnostics can therefore obscure the preview even when the preview process
uses the pinned main file.

With PyCharm closed, the installed 2026.2.11 JAR was patched again. For a valid
pin different from the open file, the preview panel now excludes editor
diagnostics and retains preview compiler errors. Editor highlighting itself is
unchanged. For an unpinned file, a missing pin, or the main file itself, the
original diagnostic behavior remains. The second change handles a null AST node
in the text extractor by returning a null element type for comparison.

BasicVerifier accepted both changed classes (51 and 3 methods); focused tests
covered null and non-null nodes and pinned, same-file, unpinned, and missing-pin
cases. ZIP comparison found exactly two changed classes and one added helper.
The installed JAR matches the prepared artifact (SHA-256
`041d4b8742988db3a00c212c6b0cfb3b02fa0d1cf690919055595876440ef03d`).
Live IDE verification is still needed: restart PyCharm, open chapter 01's
embedded preview and check both the rendered report and errors; observe whether
the intermittent exception recurs. This patch can hide legitimate editor-only
errors from the preview panel for pinned chapters, although the editor still
shows them and preview compiler errors remain. Patch and test sources are in
`scribe-patch-20261120/`; `/tmp/scribe-fix-20261120/previous.jar` is a temporary
backup of the earlier preview-only patch. The original backup below remains the
durable rollback to the unpatched plugin.

## Status, 20 November 2026

The fix below is not yet confirmed to work for every preview. The user reports that
`02-functional-design.typ` works independently, while opening `01-literature-review.typ`
alone produces missing-label errors. Compiling chapter 01 directly with Typst
reproduces the same errors: its source citations are defined in `references.typ`,
which is included by `main.typ`, not by the chapter. Chapter 02 working alone does
not establish that its preview uses the main file.

The project currently stores `main.typ` as `typst.pinnedMainFile` in
`.idea/workspace.xml`. The screenshot is consistent with chapter 01 being compiled
as the entry point, but does not prove which process or plugin path produced the
error. Preview `main.typ` for the complete report and its cross-file references.
After restarting PyCharm, close and reopen the chapter preview and verify whether it
shows the complete report. If the error persists, inspect the actual preview process
and its entry-point argument before changing the patch. Also verify which JAR and
Tinymist executable the IDE actually loads. The original patch was tested outside
the IDE, not confirmed in its live preview.

The user subsequently updated Tinymist and restarted the IDE; the missing-label
errors still occur. On 20 November `typst compile main.typ` succeeded, while
compiling chapter 01 directly reproduced the reported labels. The JAR at the
path below has the same SHA-256 as the saved patched JAR, but this does not prove
that PyCharm loaded it or that the error comes from the patched preview path.
Other Typst plugin JARs are also present in the PyCharm plugin directory. The
running IDE and preview process were not visible from this session, so the actual
entry point and active plugins remain unknown.

## Intermittent text extractor exception

The user also reported a `NullPointerException` in
`dev.jetplugins.typst.TypstTextExtractor` at line 91: `PsiElement.getNode()`
returned null. The stack trace shows it was called by the IDE's Grazie grammar
inspection. This is a plugin-side failure during text extraction; the trace
does not establish why the node was absent or a connection to the preview patch.
The preview patch changed a different class. As a temporary diagnostic, disable
the grammar inspection for the affected file or project and see whether the
exception stops; this suspends grammar checking in that scope. Report the full
stack trace, plugin and IDE versions, and reproduction steps to the plugin vendor.

## Original diagnosis and local patch

On 12 October 2026, Scribe Pro 2026.2.11 was inspected. Pin as main file saved
`typst.pinnedMainFile` in project settings, but the original `TypstPreviewEditor`
passed the open chapter to a separate `tinymist preview` process. This omitted the
main file's formatting and bibliography.

The installed JAR was modified only in its choice of preview entry point.
`PinnedPreviewEntry.resolve` reads the project's `PropertiesComponent` and uses
the pinned file if it exists; otherwise it falls back to the open file. Text
synchronization for the open chapter was left unchanged.

JAR: `/home/slavita/.local/share/JetBrains/PyCharm2026.1/intellij-typst-plugin-2026.2.11.jar`.
Original backup, patched JAR, and patch sources:
`/home/slavita/.local/share/typst-plugin/backups/scribe-pro-2026.2.11-preview-fix-20261012/`.

Restart PyCharm after changing the JAR. Reopen preview tabs after changing the
pinned file: the entry point is selected when the process starts. A plugin update
or reinstall may replace the patch. Do not apply it automatically to another
version; inspect that version's preview startup code first.

## Previous verification

- BasicVerifier accepted all 51 methods of the changed class.
- Selection of the pinned main file, no pin, a missing file, an empty value, and a
  directory path were tested with the JVM's `-Xverify:all` option.
- Archive comparison showed only `TypstPreviewEditor.class` changed and only
  `PinnedPreviewEntry.class` added; all other entries matched byte for byte.
- `tinymist compile main.typ` succeeded at the time. Live IDE preview remained
  unverified.

## Update check

On 20 November 2026, the [Tinymist 0.15.12 release](https://github.com/Myriad-Dreamin/tinymist/releases/tag/v0.15.12)
was marked latest. Its listed preview fix concerns low-DPI scrolling; the
[0.15.10 notes](https://github.com/Myriad-Dreamin/tinymist/releases/tag/v0.15.10)
do not identify this entry-point issue either. There is no evidence that an update
will fix this particular error. Tinymist was not on the shell PATH, so the version
used by PyCharm remains unknown. Check Settings → Tools → Typst → Language Server
and the executable's `--version` before deciding whether to update. The
[Scribe Pro manual](https://jetplugins.dev/docs/scribe-pro/overview/) documents
version 2026.2.11; check the IDE Marketplace for the installed version and updates.

## Rollback

Close PyCharm, verify that the installed plugin is still version 2026.2.11, then
restore the original JAR with the following command. Do not overwrite a newer
plugin with this older backup.

```bash
cp '/home/slavita/.local/share/typst-plugin/backups/scribe-pro-2026.2.11-preview-fix-20261012/original.jar' '/home/slavita/.local/share/JetBrains/PyCharm2026.1/intellij-typst-plugin-2026.2.11.jar'
```

Restart PyCharm afterwards.
