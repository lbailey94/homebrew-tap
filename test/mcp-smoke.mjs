// Owned scratch-store create/read/restart control; no hosted operations.
import {spawn} from 'node:child_process';
import {mkdtempSync,rmSync,writeFileSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import assert from 'node:assert/strict';
const [command,...args]=process.argv.slice(2);
if(!command)throw Error('Expected command and serve arguments');
const store=mkdtempSync(join(tmpdir(),'wm-package-smoke-')),clients=[];
async function open(){
 const child=spawn(command,[...args,'--store',store,'--rate-limit','0'],{stdio:['pipe','pipe','pipe'],detached:process.platform!=='win32'});
 let buffer='',stderr='',id=0,closed=false; const waits=new Map();
 const completion=new Promise(resolve=>child.on('close',()=>{closed=true;resolve();}));
 const reject=error=>{for(const waiter of waits.values())waiter.reject(error);waits.clear();};
 const kill=()=>{if(!closed)try{process.platform==='win32'?child.kill():process.kill(-child.pid,'SIGTERM');}catch{}};
 child.on('error',reject); child.on('close',()=>reject(Error('MCP closed: '+stderr)));
 child.stderr.on('data',d=>{stderr=(stderr+d).slice(-4000);});
 child.stdout.on('data',d=>{buffer+=d;if(buffer.length>2097152){reject(Error('Output bound'));kill();return;}
  while(buffer.includes('\n')){const i=buffer.indexOf('\n'),line=buffer.slice(0,i);buffer=buffer.slice(i+1);let msg;
   try{msg=JSON.parse(line);}catch{continue;}const waiter=waits.get(msg.id);
   if(waiter){waits.delete(msg.id);msg.error?waiter.reject(Error(JSON.stringify(msg.error))):waiter.resolve(msg.result);}
  }});
 const send=data=>child.stdin.write(JSON.stringify(data)+'\n');
 const request=(method,params)=>new Promise((resolve,reject)=>{const own=++id;waits.set(own,{resolve,reject});send({jsonrpc:'2.0',id:own,method,params});});
 const timer=setTimeout(()=>{reject(Error('MCP deadline: '+stderr));kill();},120000);
 const client={request,async close(){if(closed){clearTimeout(timer);return;}child.stdin.end();const grace=setTimeout(kill,3000);await completion;clearTimeout(grace);clearTimeout(timer);}};
 clients.push(client);
 const init=await request('initialize',{protocolVersion:'2024-11-05',capabilities:{},clientInfo:{name:'package-smoke',version:'2'}});
 assert.equal(init.serverInfo.version,'9.3.4');send({jsonrpc:'2.0',method:'notifications/initialized'});
 const list=await request('tools/list',{});for(const name of ['wm','memory.create','memory.read'])assert(list.tools.some(t=>t.name===name),name);
 if(process.env.WM_TOOLS_OUTPUT)writeFileSync(process.env.WM_TOOLS_OUTPUT,JSON.stringify(list.tools,null,2)+'\n');
 return client;
}
function payload(result){assert.notEqual(result.isError,true,JSON.stringify(result));if(result.structuredContent)return result.structuredContent;
 const texts=result.content?.filter(b=>b.type==='text');assert.equal(texts?.length,1);return JSON.parse(texts[0].text);}
try{
 const marker='Owned restart fixture '+Date.now(),first=await open();
 const created=payload(await first.request('tools/call',{name:'memory.create',arguments:{content:marker,title:'Owned package fixture',source:'agent'}}));
 console.log('create result:',JSON.stringify(created));assert.equal(typeof created.id,'string');
 const read=async client=>payload(await client.request('tools/call',{name:'memory.read',arguments:{id:created.id}}));
 assert(JSON.stringify(await read(first)).includes(marker));await first.close();
 const second=await open();assert(JSON.stringify(await read(second)).includes(marker));await second.close();
 console.log(JSON.stringify({serverVersion:'9.3.4',scope:'owned create/read/process-restart/read',pass:true}));
}finally{await Promise.all(clients.map(c=>c.close()));rmSync(store,{recursive:true,force:true,maxRetries:5,retryDelay:100});}
