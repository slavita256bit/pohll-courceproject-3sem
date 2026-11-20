from pathlib import Path
p=Path('/tmp/scribe-fix-20261120/src')
files={
'com/intellij/psi/tree/IElementType.java':'package com.intellij.psi.tree; public class IElementType {}',
'com/intellij/lang/ASTNode.java':'package com.intellij.lang; import com.intellij.psi.tree.IElementType; public interface ASTNode { IElementType getElementType(); }',
'com/intellij/openapi/editor/Editor.java':'package com.intellij.openapi.editor; public interface Editor {}',
'com/intellij/openapi/project/Project.java':'package com.intellij.openapi.project; public interface Project {}',
'com/intellij/openapi/vfs/VirtualFile.java':'package com.intellij.openapi.vfs; public abstract class VirtualFile { public abstract String getPath(); }',
'com/intellij/ide/util/PropertiesComponent.java':'package com.intellij.ide.util; import com.intellij.openapi.project.Project; public abstract class PropertiesComponent { public static PropertiesComponent getInstance(Project p) { return null; } public abstract String getValue(String key, String fallback); }',
'dev/jetplugins/typst/b.java':'package dev.jetplugins.typst; import java.util.List; import com.intellij.openapi.editor.Editor; public class b { public List a(Editor e) { return null; } }',
'dev/jetplugins/typst/PreviewSafety.java':'''package dev.jetplugins.typst;
import com.intellij.lang.ASTNode;
import com.intellij.psi.tree.IElementType;
import com.intellij.openapi.editor.Editor;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.ide.util.PropertiesComponent;
import java.io.File;
import java.util.List;
import java.util.Collections;
public final class PreviewSafety {
  public static IElementType type(ASTNode n) { return n == null ? null : n.getElementType(); }
  public static List diagnostics(b source, Editor editor, Project project, VirtualFile file) {
    String opened = file.getPath();
    String pinned = PropertiesComponent.getInstance(project).getValue("typst.pinnedMainFile", opened);
    if (pinned != null && new File(pinned).isFile() && !new File(pinned).equals(new File(opened))) return Collections.emptyList();
    return source.a(editor);
  }
}'''
}
for name,content in files.items(): (p/name).write_text(content)
