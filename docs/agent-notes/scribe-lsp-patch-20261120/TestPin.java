import com.intellij.ide.util.PropertiesComponent;
import dev.jetplugins.typst.lsp.PinSynchronizer;
import org.eclipse.lsp4j.*;
import org.eclipse.lsp4j.jsonrpc.messages.NotificationMessage;
import org.eclipse.lsp4j.services.*;
import java.lang.reflect.Proxy;import java.util.*;import java.util.concurrent.*;
public class TestPin {
 static String pin;static List<ExecuteCommandParams> calls=new ArrayList<>();
 public static void main(String[] args){
  PropertiesComponent.current=new PropertiesComponent(){public String getValue(String k,String d){Objects.requireNonNull(d);return pin==null?d:pin;}};
  WorkspaceService workspace=(WorkspaceService)Proxy.newProxyInstance(TestPin.class.getClassLoader(),new Class[]{WorkspaceService.class},(p,m,a)->{if(m.getName().equals("executeCommand")){calls.add((ExecuteCommandParams)a[0]);return CompletableFuture.completedFuture(null);} return null;});
  LanguageServer server=(LanguageServer)Proxy.newProxyInstance(TestPin.class.getClassLoader(),new Class[]{LanguageServer.class},(p,m,a)->{switch(m.getName()){case "getWorkspaceService":return workspace;case "hashCode":return 42;case "equals":return p==a[0];default:return null;}});
  NotificationMessage msg=new NotificationMessage();msg.setMethod("textDocument/didOpen");
  PinSynchronizer.handle(msg,server,null);if(!calls.isEmpty())throw new AssertionError("no pin");
  pin=args[0];PinSynchronizer.handle(msg,server,null);PinSynchronizer.handle(msg,server,null);
  if(calls.size()!=1 || !calls.get(0).getCommand().equals("tinymist.pinMain") || !calls.get(0).getArguments().get(0).equals(pin))throw new AssertionError("pin");
  pin=null;msg.setMethod("textDocument/didChange");PinSynchronizer.handle(msg,server,null);
  if(calls.size()!=2 || calls.get(1).getArguments().get(0)!=null)throw new AssertionError("unpin");
  pin="/missing/file.typ";PinSynchronizer.handle(msg,server,null);if(calls.size()!=2)throw new AssertionError("invalid pin");
  System.out.println("PASS: pin, deduplication, unpin, missing pin");
 }
}
