import asyncio, json, re, sys
from websockets.asyncio.client import connect
ROOT='/home/slavita/Documents/typst-projects/pohll-courceproject-3sem'
async def main():
 p=await asyncio.create_subprocess_exec('/home/slavita/.local/share/typst-plugin/tinymist/tinymist','preview','--preview-mode','document','--root',ROOT,ROOT+'/main.typ','--no-open','--host','127.0.0.1:0','--data-plane-host','127.0.0.1:0','--control-plane-host','127.0.0.1:0',cwd=ROOT,stdout=asyncio.subprocess.PIPE,stderr=asyncio.subprocess.STDOUT)
 try:
  ctrl=data=None
  while not ctrl or not data:
   line=(await asyncio.wait_for(p.stdout.readline(),10)).decode(errors='replace')
   if not line: raise RuntimeError('preview process stopped')
   for word in ('Control panel server','Data plane server'):
    if word in line:
     m=re.search(r'listening on:\s*(\S+)',line)
     if m:
      if word.startswith('Control'):ctrl=m.group(1)
      else:data=m.group(1)
  print('server addresses obtained',flush=True)
  async with connect('ws://'+ctrl) as c, connect('ws://'+data,origin='http://127.0.0.1',max_size=None) as d:
   print('connected',flush=True)
   await c.send(json.dumps({'event':'syncMemoryFiles','files':{ROOT+'/01-literature-review.typ':open(ROOT+'/01-literature-review.typ').read()}}))
   async def control():
    while True:
     message=await asyncio.wait_for(c.recv(),12);print('control',str(message)[:180],flush=True)
   async def frames():
    for i in range(3):
     message=await asyncio.wait_for(d.recv(),12);print('data',type(message).__name__,str(message)[:60],flush=True)
     if i==0: await c.send(json.dumps({'event':'panelScrollTo','filepath':ROOT+'/01-literature-review.typ','line':0,'character':3}))
   await asyncio.gather(control(),frames())
 except (asyncio.TimeoutError,Exception) as e: print('probe ended:',type(e).__name__,str(e)[:200],flush=True)
 finally:
  p.terminate();await p.wait()
asyncio.run(main())
