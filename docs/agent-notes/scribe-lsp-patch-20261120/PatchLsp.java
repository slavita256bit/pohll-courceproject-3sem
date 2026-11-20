import java.nio.file.*;import java.util.*;import java.util.zip.*;
import org.objectweb.asm.*;import org.objectweb.asm.tree.*;import org.objectweb.asm.tree.analysis.*;
public class PatchLsp implements Opcodes {
 public static void main(String[] args) throws Exception {
  String target="dev/jetplugins/typst/lsp/e.class", helper="dev/jetplugins/typst/lsp/PinSynchronizer.class"; int found=0;
  try(ZipFile z=new ZipFile(args[0]);ZipOutputStream out=new ZipOutputStream(Files.newOutputStream(Path.of(args[1]),StandardOpenOption.CREATE_NEW))) {
   if(z.getEntry(helper)!=null) throw new IllegalStateException("already patched");
   Enumeration<? extends ZipEntry> entries=z.entries();
   while(entries.hasMoreElements()) {ZipEntry ent=entries.nextElement(); byte[] bytes=z.getInputStream(ent).readAllBytes();
    if(ent.getName().equals(target)) {
     found++; ClassNode c=new ClassNode();new ClassReader(bytes).accept(c,0);
     String desc="(Lorg/eclipse/lsp4j/jsonrpc/messages/Message;Lorg/eclipse/lsp4j/services/LanguageServer;Lcom/intellij/openapi/vfs/VirtualFile;)V";
     for(MethodNode m:c.methods) if(m.name.equals("handleMessage") && m.desc.equals(desc)) throw new IllegalStateException("method exists");
     MethodNode m=new MethodNode(ACC_PUBLIC,"handleMessage",desc,null,null);
     m.instructions.add(new VarInsnNode(ALOAD,1));m.instructions.add(new VarInsnNode(ALOAD,2));m.instructions.add(new VarInsnNode(ALOAD,0));m.instructions.add(new FieldInsnNode(GETFIELD,c.name,"a","Lcom/intellij/openapi/project/Project;"));
     m.instructions.add(new MethodInsnNode(INVOKESTATIC,"dev/jetplugins/typst/lsp/PinSynchronizer","handle","(Lorg/eclipse/lsp4j/jsonrpc/messages/Message;Lorg/eclipse/lsp4j/services/LanguageServer;Lcom/intellij/openapi/project/Project;)V",false));m.instructions.add(new InsnNode(RETURN));c.methods.add(m);
     ClassWriter w=new ClassWriter(ClassWriter.COMPUTE_MAXS);c.accept(w);bytes=w.toByteArray();ClassNode check=new ClassNode();new ClassReader(bytes).accept(check,0);for(MethodNode v:check.methods) if((v.access&(ACC_ABSTRACT|ACC_NATIVE))==0)new Analyzer<>(new BasicVerifier()).analyze(check.name,v);System.out.println("Verified "+check.methods.size()+" methods");
    }
    out.putNextEntry(new ZipEntry(ent.getName()));out.write(bytes);out.closeEntry();
   }
   if(found!=1)throw new IllegalStateException("missing class");out.putNextEntry(new ZipEntry(helper));out.write(Files.readAllBytes(Path.of(args[2])));out.closeEntry();
  }
 }
}
