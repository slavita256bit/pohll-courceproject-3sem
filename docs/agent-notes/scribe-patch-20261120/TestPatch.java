import com.intellij.ide.util.PropertiesComponent;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.openapi.editor.Editor;
import com.intellij.psi.tree.IElementType;
import dev.jetplugins.typst.PreviewSafety;
import dev.jetplugins.typst.b;
import java.util.*;
public class TestPatch {
 static String pin;
 public static void main(String[] args) {
  PropertiesComponent.current = new PropertiesComponent(){public String getValue(String key,String fallback){return pin==null?fallback:pin;}};
  String main=args[0], chapter=args[1];
  VirtualFile file=new VirtualFile(){public String getPath(){return chapter;}};
  List<String> errors=List.of("real editor error"); b source=new b(){public List a(Editor e){return errors;}};
  if (PreviewSafety.type(null)!=null) throw new AssertionError("null node");
  IElementType type=new IElementType(); if(PreviewSafety.type(()->type)!=type) throw new AssertionError("node type");
  pin=main; if(!PreviewSafety.diagnostics(source,null,null,file).isEmpty()) throw new AssertionError("pinned chapter");
  pin=chapter; if(PreviewSafety.diagnostics(source,null,null,file)!=errors) throw new AssertionError("pinned same file");
  pin=null; if(PreviewSafety.diagnostics(source,null,null,file)!=errors) throw new AssertionError("no pin");
  pin="/nonexistent/scribe-main.typ"; if(PreviewSafety.diagnostics(source,null,null,file)!=errors) throw new AssertionError("missing pin");
  System.out.println("PASS: null/non-null AST and pinned, unpinned, missing entry cases");
 }
}
