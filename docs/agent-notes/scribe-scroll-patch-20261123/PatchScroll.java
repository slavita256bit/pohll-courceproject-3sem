import java.nio.file.*;import java.util.*;import java.util.zip.*;import org.objectweb.asm.*;import org.objectweb.asm.tree.*;import org.objectweb.asm.tree.analysis.*;
public class PatchScroll implements Opcodes {
 static String ed="dev/jetplugins/typst/preview/TypstPreviewEditor",panel="dev/jetplugins/typst/preview/TypstPreviewPanel",helper="dev/jetplugins/typst/preview/InitialPreviewScroll", socket="Ljava/net/http/WebSocket;",field="L"+helper+";";
 static byte[] patch(byte[] bytes, boolean isEditor) throws Exception {
  ClassNode c=new ClassNode();new ClassReader(bytes).accept(c,0);int n=0;
  if(!isEditor){MethodNode get=new MethodNode(ACC_PUBLIC,"initialScrollBrowser","()Lcom/intellij/ui/jcef/JBCefBrowser;",null,null);get.instructions.add(new VarInsnNode(ALOAD,0));get.instructions.add(new FieldInsnNode(GETFIELD,panel,"c","Lcom/intellij/ui/jcef/JBCefBrowser;"));get.instructions.add(new InsnNode(ARETURN));c.methods.add(get);}
  else {
   c.fields.add(new FieldNode(ACC_PRIVATE|ACC_FINAL,"initialScroll",field,null,null));
   for(MethodNode m:c.methods) {
    if(m.name.equals("<init>") && m.desc.equals("(Lcom/intellij/openapi/project/Project;Lcom/intellij/openapi/vfs/VirtualFile;Lcom/intellij/openapi/fileEditor/TextEditor;)V")) {
     for(AbstractInsnNode ins:m.instructions.toArray()) if(ins instanceof MethodInsnNode x && x.owner.equals(ed)&&x.name.equals("j")&&x.desc.equals("()V")) {
      AbstractInsnNode prev=ins.getPrevious(); if(!(prev instanceof VarInsnNode) || prev.getOpcode()!=ALOAD)throw new IllegalStateException("unexpected constructor");
      InsnList v=new InsnList();v.add(new VarInsnNode(ALOAD,0));v.add(new TypeInsnNode(NEW,helper));v.add(new InsnNode(DUP));v.add(new VarInsnNode(ALOAD,0));v.add(new VarInsnNode(ALOAD,3));v.add(new VarInsnNode(ALOAD,2));v.add(new VarInsnNode(ALOAD,1));v.add(new VarInsnNode(ALOAD,0));v.add(new FieldInsnNode(GETFIELD,ed,"d","L"+panel+";"));v.add(new MethodInsnNode(INVOKEVIRTUAL,panel,"initialScrollBrowser","()Lcom/intellij/ui/jcef/JBCefBrowser;",false));v.add(new MethodInsnNode(INVOKESPECIAL,helper,"<init>","(L"+ed+";Lcom/intellij/openapi/fileEditor/TextEditor;Lcom/intellij/openapi/vfs/VirtualFile;Lcom/intellij/openapi/project/Project;Lcom/intellij/ui/jcef/JBCefBrowser;)V",false));v.add(new FieldInsnNode(PUTFIELD,ed,"initialScroll",field));m.instructions.insertBefore(prev,v);n++;
     }
    }
    if(m.name.equals("a")&&m.desc.equals("(Ljava/lang/String;)V")&&(m.access&ACC_PUBLIC)!=0){InsnList v=new InsnList();v.add(new VarInsnNode(ALOAD,0));v.add(new FieldInsnNode(GETFIELD,ed,"initialScroll",field));v.add(new VarInsnNode(ALOAD,1));v.add(new MethodInsnNode(INVOKEVIRTUAL,helper,"onMessage","(Ljava/lang/String;)V",false));m.instructions.insert(v);n++;}
    if(m.name.equals("dispose")&&m.desc.equals("()V")){InsnList v=new InsnList();v.add(new VarInsnNode(ALOAD,0));v.add(new FieldInsnNode(GETFIELD,ed,"initialScroll",field));v.add(new MethodInsnNode(INVOKEVIRTUAL,helper,"dispose","()V",false));m.instructions.insert(v);n++;}
   }
   MethodNode socketGetter=new MethodNode(ACC_PUBLIC,"initialScrollSocket","()"+socket,null,null);socketGetter.instructions.add(new VarInsnNode(ALOAD,0));socketGetter.instructions.add(new FieldInsnNode(GETFIELD,ed,"l",socket));socketGetter.instructions.add(new InsnNode(ARETURN));c.methods.add(socketGetter);
   MethodNode messageGetter=new MethodNode(ACC_PUBLIC,"initialScrollMessage","(Ljava/lang/String;II)Ljava/lang/String;",null,null);messageGetter.instructions.add(new FieldInsnNode(GETSTATIC,ed,"Companion","L"+ed+"$Companion;"));messageGetter.instructions.add(new VarInsnNode(ALOAD,1));messageGetter.instructions.add(new VarInsnNode(ILOAD,2));messageGetter.instructions.add(new VarInsnNode(ILOAD,3));messageGetter.instructions.add(new MethodInsnNode(INVOKEVIRTUAL,ed+"$Companion","buildPanelScrollMessage$dev_jetplugins_typst_intellij_typst_plugin","(Ljava/lang/String;II)Ljava/lang/String;",false));messageGetter.instructions.add(new InsnNode(ARETURN));c.methods.add(messageGetter);
   if(n!=3)throw new IllegalStateException("unexpected edits "+n);
  }
  ClassWriter w=new ClassWriter(ClassWriter.COMPUTE_MAXS);c.accept(w);byte[] out=w.toByteArray();ClassNode checked=new ClassNode();new ClassReader(out).accept(checked,0);for(MethodNode m:checked.methods)if((m.access&(ACC_ABSTRACT|ACC_NATIVE))==0)new Analyzer<>(new BasicVerifier()).analyze(checked.name,m);System.out.println("verified "+checked.name+" "+checked.methods.size()+" methods");return out;
 }
 public static void main(String[] args)throws Exception{
  try(ZipFile z=new ZipFile(args[0]);ZipOutputStream out=new ZipOutputStream(Files.newOutputStream(Path.of(args[1]),StandardOpenOption.CREATE_NEW))){
   if(z.getEntry(helper+".class")!=null)throw new IllegalStateException("already patched");int hits=0;Enumeration<? extends ZipEntry> en=z.entries();while(en.hasMoreElements()){ZipEntry e=en.nextElement();byte[] b=z.getInputStream(e).readAllBytes();if(e.getName().equals(ed+".class")||e.getName().equals(panel+".class")){b=patch(b,e.getName().equals(ed+".class"));hits++;}out.putNextEntry(new ZipEntry(e.getName()));out.write(b);out.closeEntry();}if(hits!=2)throw new IllegalStateException("missing classes");out.putNextEntry(new ZipEntry(helper+".class"));out.write(Files.readAllBytes(Path.of(args[2])));out.closeEntry();
  }
 }
}
