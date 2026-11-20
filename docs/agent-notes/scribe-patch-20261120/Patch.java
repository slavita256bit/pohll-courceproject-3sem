import java.nio.file.*;
import java.util.*;
import java.util.zip.*;
import org.objectweb.asm.*;
import org.objectweb.asm.tree.*;
import org.objectweb.asm.tree.analysis.*;
public class Patch implements Opcodes {
 static byte[] edit(byte[] data, boolean extractor) throws Exception {
  ClassNode c = new ClassNode(); new ClassReader(data).accept(c, 0); int hits=0;
  for (MethodNode m:c.methods) for (AbstractInsnNode i:m.instructions.toArray()) {
   if (!(i instanceof MethodInsnNode call)) continue;
   if (extractor && m.name.equals("b") && m.desc.equals("(Lcom/intellij/psi/PsiElement;)Z") && call.owner.equals("com/intellij/lang/ASTNode") && call.name.equals("getElementType")) {
    m.instructions.set(i,new MethodInsnNode(INVOKESTATIC,"dev/jetplugins/typst/PreviewSafety","type","(Lcom/intellij/lang/ASTNode;)Lcom/intellij/psi/tree/IElementType;",false)); hits++;
   } else if (!extractor && m.name.equals("k") && m.desc.equals("(Ldev/jetplugins/typst/preview/TypstPreviewEditor;)V") && call.owner.equals("dev/jetplugins/typst/b") && call.name.equals("a") && call.desc.equals("(Lcom/intellij/openapi/editor/Editor;)Ljava/util/List;")) {
    InsnList ins = new InsnList(); ins.add(new VarInsnNode(ALOAD,0)); ins.add(new FieldInsnNode(GETFIELD,c.name,"a","Lcom/intellij/openapi/project/Project;")); ins.add(new VarInsnNode(ALOAD,0)); ins.add(new FieldInsnNode(GETFIELD,c.name,"b","Lcom/intellij/openapi/vfs/VirtualFile;")); m.instructions.insertBefore(i,ins);
    m.instructions.set(i,new MethodInsnNode(INVOKESTATIC,"dev/jetplugins/typst/PreviewSafety","diagnostics","(Ldev/jetplugins/typst/b;Lcom/intellij/openapi/editor/Editor;Lcom/intellij/openapi/project/Project;Lcom/intellij/openapi/vfs/VirtualFile;)Ljava/util/List;",false)); hits++;
   }
  }
  if(hits!=(extractor?2:1)) throw new IllegalStateException("unexpected matches: "+hits);
  ClassWriter w=new ClassWriter(ClassWriter.COMPUTE_MAXS);c.accept(w);byte[] result=w.toByteArray();
  ClassNode check=new ClassNode();new ClassReader(result).accept(check,0);for(MethodNode m:check.methods) if((m.access&(ACC_ABSTRACT|ACC_NATIVE))==0) new Analyzer<>(new BasicVerifier()).analyze(check.name,m);
  System.out.println(c.name+": "+hits+" replacements; verified "+check.methods.size()+" methods"); return result;
 }
 public static void main(String[] args) throws Exception {
  String helper="dev/jetplugins/typst/PreviewSafety.class", e="dev/jetplugins/typst/e.class", p="dev/jetplugins/typst/preview/TypstPreviewEditor.class";
  try(ZipFile z=new ZipFile(args[0]); ZipOutputStream out=new ZipOutputStream(Files.newOutputStream(Path.of(args[1]),StandardOpenOption.CREATE_NEW))) {
   if(z.getEntry(helper)!=null) throw new IllegalStateException("already patched");
   Enumeration<? extends ZipEntry> entries=z.entries();
   while(entries.hasMoreElements()) { ZipEntry entry=entries.nextElement(); byte[] bytes=z.getInputStream(entry).readAllBytes(); if(entry.getName().equals(e)) bytes=edit(bytes,true); if(entry.getName().equals(p)) bytes=edit(bytes,false); out.putNextEntry(new ZipEntry(entry.getName()));out.write(bytes);out.closeEntry(); }
   out.putNextEntry(new ZipEntry(helper));out.write(Files.readAllBytes(Path.of(args[2])));out.closeEntry();
  }
 }
}
