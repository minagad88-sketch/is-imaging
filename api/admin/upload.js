import { storage } from 'hatchable';
export const access='admin';
export const methods=['POST'];
export default async function(req,res){
  const f=req.files?.[0];
  if(!f||!f.buffer) return res.status(400).json({error:'No image uploaded'});
  if(!String(f.contentType||'').startsWith('image/')) return res.status(400).json({error:'Only image files are allowed'});
  if(f.buffer.length>10*1024*1024) return res.status(400).json({error:'Image is too large (max 10 MB)'});
  const safe=String(f.filename||'image').replace(/[^a-zA-Z0-9._-]+/g,'-').replace(/^-+|-+$/g,'')||'image';
  const key='site-images/'+Date.now()+'-'+safe;
  const url=await storage.put(key,f.buffer,f.contentType);
  return res.status(201).json({url,name:safe,type:f.contentType});
}
