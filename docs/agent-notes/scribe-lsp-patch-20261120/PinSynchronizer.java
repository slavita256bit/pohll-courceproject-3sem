package dev.jetplugins.typst.lsp;
import com.intellij.ide.util.PropertiesComponent;
import com.intellij.openapi.project.Project;
import org.eclipse.lsp4j.ExecuteCommandParams;
import org.eclipse.lsp4j.jsonrpc.messages.Message;
import org.eclipse.lsp4j.jsonrpc.messages.NotificationMessage;
import org.eclipse.lsp4j.services.LanguageServer;
import java.io.File;
import java.util.*;
public final class PinSynchronizer {
 private static final Map<LanguageServer,String> pins = new WeakHashMap<>();
 public static void handle(Message message, LanguageServer server, Project project) {
  if (!(message instanceof NotificationMessage) || server == null) return;
  String method=((NotificationMessage)message).getMethod();
  if (!"textDocument/didOpen".equals(method) && !"textDocument/didChange".equals(method)) return;
  String pin=PropertiesComponent.getInstance(project).getValue("typst.pinnedMainFile","");
  if (pin != null && !new File(pin).isFile()) pin=null;
  synchronized(pins) {
   if (Objects.equals(pins.get(server),pin)) return;
   server.getWorkspaceService().executeCommand(new ExecuteCommandParams("tinymist.pinMain",Collections.singletonList(pin)));
   if (pin == null) pins.remove(server); else pins.put(server,pin);
  }
 }
}
