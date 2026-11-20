import subprocess,json,os,select,time,pathlib
root=pathlib.Path('/home/slavita/Documents/typst-projects/pohll-courceproject-3sem'); f=root/'01-literature-review.typ'
p=subprocess.Popen(['/home/slavita/.local/share/typst-plugin/tinymist/tinymist','lsp'],cwd=root,stdin=subprocess.PIPE,stdout=subprocess.PIPE,stderr=open('/tmp/tinymist-probe-after-20261120.log','wb'))
def send(v):
 b=json.dumps(v).encode(); p.stdin.write(b'Content-Length: %d\r\n\r\n'%len(b)+b);p.stdin.flush()
def recv(t):
 if not select.select([p.stdout],[],[],t)[0]: return None
 h=b''
 while not h.endswith(b'\r\n\r\n'): h+=os.read(p.stdout.fileno(),1)
 n=int(next(x.split(b':',1)[1] for x in h.split(b'\r\n') if x.lower().startswith(b'content-length:')));b=b''
 while len(b)<n:b+=os.read(p.stdout.fileno(),n-len(b))
 return json.loads(b)
def wait(t):
 end=time.monotonic()+t
 while time.monotonic()<end:
  v=recv(end-time.monotonic())
  if v is None:break
  if v.get('method')=='textDocument/publishDiagnostics':print('DIAGNOSTICS',v['params']['uri'],[x['message'] for x in v['params']['diagnostics']],flush=True)
  elif 'id' in v and 'method' in v:send({'jsonrpc':'2.0','id':v['id'],'result':None})
  else: print('EVENT',v,flush=True)
send({'jsonrpc':'2.0','id':1,'method':'initialize','params':{'processId':os.getpid(),'rootUri':root.as_uri(),'capabilities':{},'initializationOptions':{}}})
while True:
 v=recv(10)
 if v.get('id')==1:break
send({'jsonrpc':'2.0','method':'initialized','params':{}})
send({'jsonrpc':'2.0','method':'textDocument/didOpen','params':{'textDocument':{'uri':f.as_uri(),'languageId':'typst','version':1,'text':f.read_text()}}})
wait(3)
send({'jsonrpc':'2.0','id':3,'method':'workspace/executeCommand','params':{'command':'tinymist.pinMain','arguments':[str(root/'main.typ')]}})
wait(3)
send({'jsonrpc':'2.0','method':'textDocument/didChange','params':{'textDocument':{'uri':f.as_uri(),'version':2},'contentChanges':[{'text':f.read_text()+'\n@scribe-test-missing-label\n'}]}})
wait(5)
send({'jsonrpc':'2.0','id':4,'method':'shutdown','params':None});send({'jsonrpc':'2.0','method':'exit','params':None});p.wait(timeout=5)
