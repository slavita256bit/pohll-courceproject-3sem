from pathlib import Path
p=Path('/tmp/scribe-initial-scroll-20261123/testsrc')
files={
'com/intellij/openapi/Disposable.java':'package com.intellij.openapi; public interface Disposable {}',
'com/intellij/openapi/project/Project.java':'package com.intellij.openapi.project; public interface Project {}',
'com/intellij/openapi/vfs/VirtualFile.java':'package com.intellij.openapi.vfs; public class VirtualFile { public String getPath(){return "chapter.typ";} }',
'com/intellij/openapi/editor/LogicalPosition.java':'package com.intellij.openapi.editor; public class LogicalPosition {public int line,column; public LogicalPosition(int l,int c){line=l;column=c;}}',
'com/intellij/openapi/editor/Document.java':'package com.intellij.openapi.editor; public interface Document {String getText();}',
'com/intellij/openapi/editor/CaretModel.java':'package com.intellij.openapi.editor; public interface CaretModel {LogicalPosition getLogicalPosition();}',
'com/intellij/openapi/editor/Editor.java':'package com.intellij.openapi.editor; public interface Editor {boolean isDisposed(); CaretModel getCaretModel(); Document getDocument();}',
'com/intellij/openapi/fileEditor/TextEditor.java':'package com.intellij.openapi.fileEditor; import com.intellij.openapi.editor.Editor; public interface TextEditor {Editor getEditor();}',
'com/intellij/util/Alarm.java':'package com.intellij.util; import com.intellij.openapi.Disposable; public class Alarm {public enum ThreadToUse{SWING_THREAD};public static Runnable pending; public Alarm(ThreadToUse t,Disposable d){} public boolean isDisposed(){return false;} public void addRequest(Runnable r,int n){pending=r;} }',
'org/cef/browser/CefFrame.java':'package org.cef.browser; public interface CefFrame {boolean isMain();}',
'org/cef/browser/CefBrowser.java':'package org.cef.browser; public interface CefBrowser {String getURL();}',
'org/cef/handler/CefLoadHandlerAdapter.java':'package org.cef.handler; import org.cef.browser.*; public class CefLoadHandlerAdapter {public void onLoadEnd(CefBrowser b,CefFrame f,int s){}}',
'com/intellij/ui/jcef/JBCefBrowser.java':'package com.intellij.ui.jcef; import org.cef.browser.CefBrowser; import org.cef.handler.CefLoadHandlerAdapter; public class JBCefBrowser {public JBCefBrowser getJBCefClient(){return this;} public CefBrowser getCefBrowser(){return null;} public JBCefBrowser addLoadHandler(CefLoadHandlerAdapter h,CefBrowser b){return this;} public void removeLoadHandler(CefLoadHandlerAdapter h,CefBrowser b){} }',
'dev/jetplugins/typst/preview/TypstPreviewEditor.java':'package dev.jetplugins.typst.preview; import com.intellij.openapi.Disposable; import java.net.http.WebSocket; public class TypstPreviewEditor implements Disposable { public WebSocket socket; public WebSocket initialScrollSocket(){return socket;} public String initialScrollMessage(String f,int l,int c){return f+":"+l+":"+c;} }',
'dev/jetplugins/typst/preview/PinnedPreviewEntry.java':'package dev.jetplugins.typst.preview; import com.intellij.openapi.project.Project; import com.intellij.openapi.vfs.VirtualFile; public class PinnedPreviewEntry { public static String resolve(Project p,VirtualFile f){return "main.typ";} }',
'dev/jetplugins/typst/preview/TestScroll.java':'''package dev.jetplugins.typst.preview;
import com.intellij.openapi.editor.*;import com.intellij.openapi.vfs.VirtualFile;import com.intellij.util.Alarm;import java.net.http.WebSocket;import java.lang.reflect.Proxy;import java.util.*;import java.util.concurrent.CompletableFuture;
public class TestScroll {
 public static void main(String[] args){
  List<String> sent=new ArrayList<>(); TypstPreviewEditor owner=new TypstPreviewEditor();
  owner.socket=(WebSocket)Proxy.newProxyInstance(TestScroll.class.getClassLoader(),new Class[]{WebSocket.class},(p,m,a)->{if(m.getName().equals("isOutputClosed"))return false;if(m.getName().equals("sendText")){sent.add(a[0].toString());return CompletableFuture.completedFuture(null);}return null;});
  Editor editor=new Editor(){public boolean isDisposed(){return false;} public CaretModel getCaretModel(){return ()->new LogicalPosition(0,0);} public Document getDocument(){return ()->"// comment\\n#let x=1\\n= Heading\\ntext";}};
  InitialPreviewScroll h=new InitialPreviewScroll(owner,()->editor,new VirtualFile(),null,new com.intellij.ui.jcef.JBCefBrowser());
  h.onMessage("{\\"event\\":\\"compileStatus\\",\\"kind\\":\\"CompileSuccess\\"}");if(Alarm.pending!=null)throw new AssertionError("must wait for page");
  h.onLoadEnd(()->"http://127.0.0.1:123",()->true,200);if(Alarm.pending==null)throw new AssertionError("ready");
  Alarm.pending.run();if(!sent.equals(List.of("chapter.typ:2:3")))throw new AssertionError(sent.toString());
  Alarm.pending=null;h.onMessage("{\\"event\\":\\"compileStatus\\",\\"kind\\":\\"CompileSuccess\\"}");if(Alarm.pending!=null)throw new AssertionError("one jump");
  if(InitialPreviewScroll.firstHeading("// x\\n= H")!=1 || InitialPreviewScroll.firstHeading("no heading")!=-1)throw new AssertionError("heading");
  System.out.println("PASS: wait for load and compile, chapter heading fallback, one jump");
 }
}'''
}
for name,source in files.items():
 f=p/name;f.parent.mkdir(parents=True,exist_ok=True);f.write_text(source)
