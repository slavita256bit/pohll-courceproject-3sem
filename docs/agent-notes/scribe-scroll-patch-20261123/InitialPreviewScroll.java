package dev.jetplugins.typst.preview;
import com.intellij.openapi.editor.Editor;
import com.intellij.openapi.editor.LogicalPosition;
import com.intellij.openapi.fileEditor.TextEditor;
import com.intellij.openapi.project.Project;
import com.intellij.openapi.vfs.VirtualFile;
import com.intellij.ui.jcef.JBCefBrowser;
import com.intellij.util.Alarm;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.net.http.WebSocket;
import org.cef.browser.CefBrowser;
import org.cef.browser.CefFrame;
import org.cef.handler.CefLoadHandlerAdapter;

public final class InitialPreviewScroll extends CefLoadHandlerAdapter {
 private final TypstPreviewEditor owner;
 private final TextEditor textEditor;
 private final VirtualFile file;
 private final Project project;
 private final JBCefBrowser browser;
 private final Alarm alarm;
 private boolean loaded, compiled, scheduled, completed;
 public InitialPreviewScroll(TypstPreviewEditor owner, TextEditor textEditor, VirtualFile file, Project project, JBCefBrowser browser) {
  this.owner=owner; this.textEditor=textEditor; this.file=file; this.project=project; this.browser=browser;
  this.alarm=new Alarm(Alarm.ThreadToUse.SWING_THREAD,owner);
  if(browser!=null) browser.getJBCefClient().addLoadHandler(this,browser.getCefBrowser());
 }
 @Override public void onLoadEnd(CefBrowser cef, CefFrame frame, int status) {
  if(frame==null || !frame.isMain() || status<200 || status>=400 || !cef.getURL().startsWith("http://127.0.0.1:")) return;
  synchronized(this) { loaded=true; schedule(); }
 }
 public void onMessage(String message) {
  try {
   JsonObject obj=JsonParser.parseString(message).getAsJsonObject();
   if(!obj.has("event") || !obj.has("kind") || !"compileStatus".equals(obj.get("event").getAsString()) || !"CompileSuccess".equals(obj.get("kind").getAsString())) return;
   synchronized(this) { compiled=true; schedule(); }
  } catch (RuntimeException ignored) { }
 }
 private void schedule() {
  if(!loaded || !compiled || scheduled || completed || alarm.isDisposed()) return;
  scheduled=true;
  alarm.addRequest(this::jump,500);
 }
 private void jump() {
  synchronized(this) { scheduled=false; if(completed || alarm.isDisposed()) return; }
  Editor editor=textEditor.getEditor(); WebSocket ws=owner.initialScrollSocket();
  if(editor.isDisposed() || ws==null || ws.isOutputClosed()) return;
  LogicalPosition pos=editor.getCaretModel().getLogicalPosition();
  int line=pos.line, col=pos.column;
  if (!PinnedPreviewEntry.resolve(project,file).equals(file.getPath())) {
   int heading=firstHeading(editor.getDocument().getText());
   if(heading>=0 && line<heading) {line=heading;col=3;}
  }
  String message=owner.initialScrollMessage(file.getPath(),line,Math.max(1,col));
  try { ws.sendText(message,true); synchronized(this) { completed=true; } }
  catch (RuntimeException ignored) { }
 }
 static int firstHeading(String source) {
  String[] lines=source.split("\\R",-1);
  for(int i=0;i<lines.length;i++) if(lines[i].startsWith("= ")) return i;
  return -1;
 }
 public void dispose() {
  if(browser!=null) browser.getJBCefClient().removeLoadHandler(this,browser.getCefBrowser());
 }
}
