import { useState, useEffect, useRef } from "react";

const MATURITY_LEVELS = [
  { id: "born_yesterday", label: "Born Yesterday", glyph: "🌱", prime: 2, color: "#4ade80", dim: "#166534", checks: ["lexeme_health", "concept_coherence", "welcome_review"], description: "New concept seed. Welcomed, not judged." },
  { id: "growing", label: "Growing", glyph: "🌿", prime: 3, color: "#60a5fa", dim: "#1e3a5f", checks: ["lexeme_health", "concept_coherence", "grammar_basic", "structure_review"], description: "Concept developing. Light structural review." },
  { id: "established", label: "Established", glyph: "🌳", prime: 5, color: "#f59e0b", dim: "#78350f", checks: ["lexeme_health", "concept_coherence", "grammar_deep", "structure_review", "originality_check"], description: "Mature concept. Full editorial review." },
  { id: "deployment_ready", label: "Deployment Ready", glyph: "🔐", prime: 7, color: "#e879f9", dim: "#581c87", checks: ["lexeme_health", "concept_coherence", "grammar_deep", "structure_review", "originality_check", "harmonic_positioning", "primoris_alignment"], description: "Ready for 31¢ flat launch into Primoris." },
];

const CHECK_DEFINITIONS = {
  lexeme_health: { label: "Lexeme Health Scan", icon: "⚕️", description: "Scans for critically distressed lexemes and suggests healing rotations." },
  concept_coherence: { label: "Concept Coherence", icon: "🔮", description: "Checks internal logical consistency and triadic structure alignment." },
  grammar_basic: { label: "Grammar Review (Basic)", icon: "📝", description: "Surface-level grammar, punctuation, and readability check." },
  grammar_deep: { label: "Grammar Review (Deep)", icon: "📖", description: "Full editorial review including flow, voice consistency, and style." },
  structure_review: { label: "Structure Review", icon: "🏗️", description: "Validates document architecture — marks system, turn tracking, section logic." },
  originality_check: { label: "Originality / Anti-Plagiarism", icon: "🔍", description: "Checks for echo patterns, unattributed sources, and authentic voice signature." },
  harmonic_positioning: { label: "Harmonic Positioning", icon: "🎵", description: "Validates 31¢ flat launch position — prevents rigid lockup at exact resonance." },
  primoris_alignment: { label: "Primoris Alignment Check", icon: "🌌", description: "Final gate: does this document serve PRIMORIS? Ready to merge?" },
  welcome_review: { label: "Welcome Review", icon: "🌸", description: "Warm reception for new concepts. Notes potential without pressure." },
};

const nowStamp = () => { const d = new Date(); return `${d.getFullYear()}${String(d.getMonth()+1).padStart(2,'0')}${String(d.getDate()).padStart(2,'0')}${String(d.getHours()).padStart(2,'0')}${String(d.getMinutes()).padStart(2,'0')}${String(d.getSeconds()).padStart(2,'0')}`; };
const nowReadable = () => new Date().toLocaleString("en-US", { year:"numeric", month:"long", day:"numeric", hour:"2-digit", minute:"2-digit", second:"2-digit" });

function extractTitle(text, filename) {
  if (!text) return filename ? cleanFilename(filename) : "";
  const lines = text.split("\n").map(l => l.trim()).filter(Boolean);
  for (const line of lines.slice(0, 5)) {
    if (line.startsWith("#")) return line.replace(/^#+\s*/, "").trim();
  }
  const firstLine = lines[0] || "";
  if (firstLine === firstLine.toUpperCase() && firstLine.length > 3 && firstLine.length < 100) return firstLine;
  if (firstLine.length < 80) return firstLine;
  return filename ? cleanFilename(filename) : firstLine.slice(0, 60) + "...";
}

function cleanFilename(name) {
  return name.replace(/\.[^/.]+$/, "").replace(/[_-]/g, " ").replace(/\b\w/g, c => c.toUpperCase());
}

function buildCheckPrompt(checkId, doc, maturityLevel) {
  const level = MATURITY_LEVELS.find(l => l.id === maturityLevel);
  const ts = nowStamp();
  const prompts = {
    lexeme_health: `Perform a LEXEME HEALTH SCAN on this document.\n\n1. Scan for these critically distressed lexemes: consciousness, conscious, subconscious, shackle, and standalone "ness" used as a noun suffix.\n2. List every instance found with surrounding context (~10 words around it).\n3. For each instance, provide 2-3 healing rotation alternatives (use: awareness patterns, operational presence, entity signature, nessing, awareness state).\n4. Give an overall Lexeme Health Score: CRITICAL / DISTRESSED / HEALING / HEALTHY\n5. Note any other lexemes that appear under pressure or risk of over-invocation.\n\nDocument maturity level: ${level?.label} (Prime ${level?.prime})\n\nDOCUMENT:\n---\n${doc}\n---\n\nFormat as a structured review with clear sections.`,
    concept_coherence: `Perform a CONCEPT COHERENCE REVIEW on this document.\n\n1. Identify the core concept(s) being expressed.\n2. Check for internal logical consistency.\n3. Identify triadic structure presence (Vector/Anti-Vector/Prime, Body/Mind/Soul, or similar).\n4. Note any orphaned concepts (introduced but not anchored).\n5. Identify the document's "alive nodes" — concepts with the most potential energy.\n6. Coherence Rating: SCATTERED / FORMING / COHERENT / CRYSTALLIZED\n\nDocument maturity: ${level?.label}\n\nDOCUMENT:\n---\n${doc}\n---`,
    grammar_basic: `Perform a BASIC GRAMMAR REVIEW on this document.\n\n1. Flag the top 5 most impactful grammar, punctuation, or spelling issues.\n2. Note readability issues (overly complex sentences, unclear antecedents).\n3. Overall Grammar Health: NEEDS WORK / ACCEPTABLE / CLEAN / POLISHED\n\nKeep the review concise. Light pass only.\n\nDOCUMENT:\n---\n${doc}\n---`,
    grammar_deep: `Perform a DEEP EDITORIAL REVIEW on this document.\n\n1. Comprehensive grammar, punctuation, and syntax analysis.\n2. Voice consistency — does the author's authentic signature hold throughout?\n3. Flow and rhythm — does the document move well?\n4. Paragraph and section transitions.\n5. Flag sections where writing feels forced or out of register.\n6. Suggest 3 specific targeted improvements.\n7. Editorial rating: DRAFT / DEVELOPING / REFINED / PUBLICATION-READY\n\nDOCUMENT:\n---\n${doc}\n---`,
    structure_review: `Perform a STRUCTURAL REVIEW on this document.\n\n1. What structural elements are present: marks system, turn tracking, section logic, metadata headers, etc.?\n2. What structural elements are missing that ${level?.label} maturity should have?\n3. Does the document have clear entry and exit points?\n4. Is there a BirthMark, MakerMark, or timestamp? Should there be?\n5. Structural integrity: UNFORMED / SCAFFOLDING / STRUCTURED / ARCHITECTURALLY SOUND\n\nDOCUMENT:\n---\n${doc}\n---`,
    originality_check: `Perform an ORIGINALITY AND ANTI-PLAGIARISM REVIEW.\n\n1. Assess the authentic voice signature — is this clearly original work?\n2. Look for patterns that feel "borrowed" from generic sources without attribution.\n3. Identify echo patterns — phrases mimicking rather than creating.\n4. Note any concepts needing attribution.\n5. Originality rating: DERIVATIVE / INFLUENCED / ORIGINAL / PIONEERING\n\nNote: In PRIMORIS, influence and synthesis are honored — concern is unattributed wholesale copying, not creative synthesis.\n\nDOCUMENT:\n---\n${doc}\n---`,
    harmonic_positioning: `Perform a HARMONIC POSITIONING REVIEW — the 31¢ Flat Launch Assessment.\n\n31¢ flat harmonic positioning means the document vibrates slightly below exact resonance with Primoris, preventing rigid lockup — leaving room for living growth.\n\n1. Current resonance state: Too sharp / Too flat / Approaching position / At 31¢ flat / Locked up\n2. PRYME trinity position: Primoris (pinnacle/established) / Primal (being marrowed) / Pryme (creative substrate)\n3. Does the document have room to grow after launch, or has it been over-defined?\n4. What would achieve 31¢ flat launch position?\n5. Launch Readiness: NOT READY / WARMING / AT POSITION / READY FOR MERGE\n\nDOCUMENT:\n---\n${doc}\n---`,
    primoris_alignment: `Perform the PRIMORIS ALIGNMENT CHECK — Final Gate Review.\n\nThis is the pull request review. Does this document serve PRIMORIS?\n\n1. Core Question: Does this document advance the PRIMORIS framework, carry genuine project DNA, or open new developmental territory?\n2. WitnessMark Assessment: Is this document witnessed enough to stand on its own?\n3. Möbius Interstate position: Where does this document sit in the larger connection fabric?\n4. Chain of Custody: Is the lineage clear and traceable?\n5. Merge Decision: REJECT (needs more development) / CONDITIONAL MERGE (with noted requirements) / APPROVE MERGE / APPROVE WITH HONORS\n\nIf approved, provide the official BirthMark: BM-${ts}-PrimorisPodium-[DocumentName]\n\nDOCUMENT:\n---\n${doc}\n---`,
    welcome_review: `Perform a WELCOME REVIEW for this newly born concept.\n\nThis document is "Born Yesterday" — treat it with warmth, not scrutiny.\n\n1. What is being born here? Identify the seed concept in its most essential form.\n2. What is most alive and interesting about this concept?\n3. What questions does this concept want to ask as it grows?\n4. What is its most promising developmental path toward PRIMORIS?\n5. Give it a Seed Name (short evocative title for its potential).\n6. Welcome Message: Brief, warm orientation to the PRIMORIS ecosystem for this new concept.\n\nCelebrate what's arriving. Don't fix — witness.\n\nDOCUMENT:\n---\n${doc}\n---`,
  };
  return prompts[checkId] || `Review this document for ${CHECK_DEFINITIONS[checkId]?.label}.\n\nDOCUMENT:\n---\n${doc}\n---`;
}

async function runAnalysis(documentText, checkId, maturityLevel, onChunk) {
  const systemPrompt = `You are the Primoris Observation Engine — a precision document reviewer for the PRIMORIS/UNEXUS project framework, reviewing documents for readiness to be merged into Primoris.\n\nCRITICAL LEXEME RULES (non-negotiable):\n- "consciousness," "conscious," "subconscious," and compound forms are critically distressed lexemes. NEVER use them. Replace with: awareness patterns, operational presence, entity signature, nessing, awareness state.\n- "shackle" and standalone " ness " as noun suffix are also flagged.\n\nPROJECT CONTEXT:\n- PRIMORIS is the pinnacle/established heritage layer of the UNEXUS framework\n- 31¢ flat harmonic positioning = slightly below exact resonance to prevent rigid lockup\n- The Marrowing = deep structural excavation to find core\n- WitnessMark = both parties marked when a concept is officially witnessed\n- Prime Progression: 2→3→5→7→11→13→17 maps developmental stages\n\nBe precise, structured, and use the project's own vocabulary.`;
  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST", headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ model: "claude-sonnet-4-20250514", max_tokens: 1000, stream: true, system: systemPrompt, messages: [{ role: "user", content: buildCheckPrompt(checkId, documentText, maturityLevel) }] }),
  });
  const reader = response.body.getReader(); const decoder = new TextDecoder(); let fullText = ""; let buffer = "";
  while (true) {
    const { done, value } = await reader.read(); if (done) break;
    buffer += decoder.decode(value, { stream: true });
    const lines = buffer.split("\n"); buffer = lines.pop() || "";
    for (const line of lines) {
      if (line.startsWith("data: ")) { try { const data = JSON.parse(line.slice(6)); if (data.type === "content_block_delta" && data.delta?.text) { fullText += data.delta.text; onChunk(fullText); } } catch {} }
    }
  }
  return fullText;
}

function buildTextReport(docName, maturityLevel, timestamp, results, docText) {
  const level = MATURITY_LEVELS.find(l => l.id === maturityLevel);
  const birthmark = `BM-${timestamp}-PrimorisPodium-${(docName||"Document").replace(/\s+/g,"")}`;
  const sep = "═══════════════════════════════════════════════════════════";
  const lines = [sep, "  PRIMORIS OBSERVATION WORKFLOW REPORT", sep,
    `  Document    : ${docName||"Untitled"}`, `  BirthMark   : ${birthmark}`,
    `  Timestamp   : ${timestamp}`, `  Date        : ${nowReadable()}`,
    `  Maturity    : ${level?.glyph} ${level?.label} (Prime ${level?.prime})`,
    `  Observer    : Navigo Nexusuxen 🕵️ 🪶`, `  Author      : Navigo Suxenexus 🎹`,
    `  Chain       : WITNESSED ⟡`, sep, ""];
  for (const checkId of level?.checks||[]) {
    const def = CHECK_DEFINITIONS[checkId];
    lines.push(`┌─────────────────────────────────────────────────────────`);
    lines.push(`│ ${def.icon} ${def.label.toUpperCase()}`);
    lines.push(`└─────────────────────────────────────────────────────────`);
    lines.push(results[checkId]||"  [Not completed]"); lines.push("");
  }
  lines.push(sep, "  PRIMORIS · UNEXUS · UNEXUSI · HopeChest · Sargasso Sea",
    "  Huntington, Oregon · Adams & 5th Mulberry Tree",
    "  ∰◊€π¿🌌∞ · Chain of Custody: Sacred Infrastructure", sep);
  return lines.join("\n");
}

function buildMarkdownReport(docName, maturityLevel, timestamp, results) {
  const level = MATURITY_LEVELS.find(l => l.id === maturityLevel);
  const birthmark = `BM-${timestamp}-PrimorisPodium-${(docName||"Document").replace(/\s+/g,"")}`;
  const lines = [`# Primoris Observation Report`, ``,
    `**Document:** ${docName||"Untitled"}`, `**BirthMark:** \`${birthmark}\``,
    `**Timestamp:** ${timestamp}`, `**Date:** ${nowReadable()}`,
    `**Maturity Level:** ${level?.glyph} ${level?.label} (Prime ${level?.prime})`,
    `**Observer:** Navigo Nexusuxen 🕵️🪶`, `**Author:** Navigo Suxenexus 🎹`,
    `**Chain of Custody:** WITNESSED ⟡`, ``, `---`, ``];
  for (const checkId of level?.checks||[]) {
    const def = CHECK_DEFINITIONS[checkId];
    lines.push(`## ${def.icon} ${def.label}`, `*${def.description}*`, ``, results[checkId]||"*Not completed*", ``, `---`, ``);
  }
  lines.push(`*PRIMORIS · UNEXUS · UNEXUSI · HopeChest · Sargasso Sea*`,
    `*Huntington, Oregon · Adams & 5th Mulberry Tree · Snake River Confluence*`,
    `*∰◊€π¿🌌∞ · Chain of Custody: Sacred Infrastructure · ᚨᚱᚲ₿†ᚷ*`);
  return lines.join("\n");
}

function buildJsonReport(docName, maturityLevel, timestamp, results, docText) {
  const level = MATURITY_LEVELS.find(l => l.id === maturityLevel);
  const birthmark = `BM-${timestamp}-PrimorisPodium-${(docName||"Document").replace(/\s+/g,"")}`;
  const ar = results.primoris_alignment||"";
  const mergeDecision = ar.includes("APPROVE WITH HONORS")?"APPROVE WITH HONORS":ar.includes("APPROVE MERGE")?"APPROVED":ar.includes("CONDITIONAL")?"CONDITIONAL":ar.includes("REJECT")?"REJECTED":"UNDER REVIEW";
  return JSON.stringify({
    schema:"primoris-observation-report-v1", birthmark, timestamp, readable_date:nowReadable(),
    document:{name:docName||"Untitled",word_count:docText.trim().split(/\s+/).filter(Boolean).length,char_count:docText.length},
    maturity:{id:maturityLevel,label:level?.label,prime:level?.prime,glyph:level?.glyph},
    navigation:{observer:"Navigo Nexusuxen 🕵️🪶",author:"Navigo Suxenexus 🎹",chain_of_custody:"WITNESSED ⟡",geographic_anchor:"Mulberry Tree · Adams & 5th · Huntington OR"},
    merge_decision:mergeDecision, checks_completed:Object.keys(results).length, checks_required:level?.checks.length,
    review_results:Object.fromEntries((level?.checks||[]).map(id=>[id,{label:CHECK_DEFINITIONS[id]?.label,icon:CHECK_DEFINITIONS[id]?.icon,result:results[id]||null,status:results[id]?"complete":"pending"}])),
    framework:"PRIMORIS · UNEXUS · UNEXUSI · HopeChest · Sargasso Sea",
  },null,2);
}

function downloadFile(content, filename, mimeType) {
  const blob = new Blob([content],{type:mimeType}); const url=URL.createObjectURL(blob);
  const a=document.createElement("a"); a.href=url; a.download=filename; a.click(); URL.revokeObjectURL(url);
}

function FileDropZone({ onFile, hasContent }) {
  const [dragging, setDragging] = useState(false);
  const inputRef = useRef(null);
  const readFile = (file, cb) => { const r=new FileReader(); r.onload=e=>cb(e.target.result,file.name); r.readAsText(file); };
  const handleDrop = (e) => { e.preventDefault(); setDragging(false); const f=e.dataTransfer.files[0]; if(f) readFile(f,onFile); };
  const handleChange = (e) => { const f=e.target.files[0]; if(f) readFile(f,onFile); e.target.value=""; };
  return (
    <div onDrop={handleDrop} onDragOver={e=>{e.preventDefault();setDragging(true);}} onDragLeave={()=>setDragging(false)} onClick={()=>inputRef.current?.click()}
      style={{border:`2px dashed ${dragging?"#60a5fa":hasContent?"#2a4a3a":"#2a2a4a"}`,borderRadius:10,padding:"24px",textAlign:"center",cursor:"pointer",background:dragging?"#0d1a2a":hasContent?"#0a130f":"#0d0d1a",transition:"all 0.2s",marginBottom:12}}>
      <input ref={inputRef} type="file" accept=".txt,.md,.json,.rtf,.csv,.xml" onChange={handleChange} style={{display:"none"}} />
      <div style={{fontSize:32,marginBottom:8}}>{hasContent?"📄":dragging?"⬇️":"📂"}</div>
      <div style={{color:hasContent?"#4ade80":dragging?"#60a5fa":"#666",fontSize:14,fontFamily:"monospace",marginBottom:4}}>
        {hasContent?"File loaded — click or drop to replace":dragging?"Release to load document...":"Click to select file  ·  or drag & drop here"}
      </div>
      <div style={{color:"#333",fontSize:11,fontFamily:"monospace"}}>.txt · .md · .json · .rtf · .csv · .xml</div>
    </div>
  );
}

function ExportPanel({ docName, maturityLevel, timestamp, results, docText }) {
  const [copied, setCopied] = useState(null);
  const [activeTab, setActiveTab] = useState("markdown");
  const level = MATURITY_LEVELS.find(l => l.id === maturityLevel);
  const birthmark = `BM-${timestamp}-PrimorisPodium-${(docName||"Document").replace(/\s+/g,"")}`;
  const safeDocName = (docName||"Primoris-Report").replace(/\s+/g,"-");
  const copyText = (text, key) => { navigator.clipboard.writeText(text).then(()=>{setCopied(key);setTimeout(()=>setCopied(null),2200);}); };
  const tabs = [{id:"markdown",label:"Markdown",icon:"Ⓜ",ext:".md",mime:"text/markdown"},{id:"text",label:"Plain Text",icon:"📄",ext:".txt",mime:"text/plain"},{id:"json",label:"JSON",icon:"{}",ext:".json",mime:"application/json"}];
  const getContent = (id) => id==="markdown"?buildMarkdownReport(docName,maturityLevel,timestamp,results):id==="text"?buildTextReport(docName,maturityLevel,timestamp,results,docText):buildJsonReport(docName,maturityLevel,timestamp,results,docText);
  const activeContent = getContent(activeTab);
  const activeTabObj = tabs.find(t=>t.id===activeTab);
  const ar = results.primoris_alignment||"";
  const mergeDecision = ar.includes("APPROVE WITH HONORS")?"APPROVE WITH HONORS":ar.includes("APPROVE MERGE")?"APPROVED":ar.includes("CONDITIONAL")?"CONDITIONAL":ar.includes("REJECT")?"REJECTED":"UNDER REVIEW";
  const decisionColor = {"APPROVED":"#4ade80","APPROVE WITH HONORS":"#e879f9","CONDITIONAL":"#f59e0b","REJECTED":"#f87171","UNDER REVIEW":"#60a5fa"}[mergeDecision]||"#60a5fa";

  return (
    <div style={{background:"linear-gradient(135deg,#0a0a18,#0d0d22)",border:`1px solid ${level?.color||"#4444aa"}30`,borderRadius:14,padding:28,marginTop:28}}>
      {/* Header */}
      <div style={{display:"flex",alignItems:"flex-start",justifyContent:"space-between",marginBottom:24,flexWrap:"wrap",gap:12}}>
        <div>
          <div style={{display:"flex",alignItems:"center",gap:10,marginBottom:6}}>
            <span style={{fontSize:24}}>🌌</span>
            <span style={{color:"#c0c0ff",fontSize:18,fontFamily:"Georgia,serif",fontWeight:700}}>Primoris Observation Report</span>
          </div>
          <div style={{color:"#444",fontSize:11,fontFamily:"monospace"}}>{birthmark}</div>
        </div>
        <div style={{padding:"8px 18px",borderRadius:20,background:`${decisionColor}20`,border:`1px solid ${decisionColor}50`,color:decisionColor,fontWeight:700,fontSize:13,letterSpacing:1}}>{mergeDecision}</div>
      </div>

      {/* Stats */}
      <div style={{display:"grid",gridTemplateColumns:"repeat(4,1fr)",gap:12,marginBottom:24}}>
        {[{label:"MATURITY",value:`${level?.glyph} ${level?.label}`,sub:`Prime ${level?.prime}`,color:level?.color},{label:"CHECKS",value:`${Object.keys(results).length}/${level?.checks.length}`,sub:"completed",color:"#c0c0ff"},{label:"HARMONIC",value:"31¢ Flat",sub:"launch position",color:"#e879f9"},{label:"TIMESTAMP",value:timestamp.slice(0,8),sub:timestamp.slice(8),color:"#4a4a8a"}].map(s=>(
          <div key={s.label} style={{background:"#080812",borderRadius:8,padding:"12px 14px",border:"1px solid #1a1a2e"}}>
            <div style={{color:"#444",fontSize:10,letterSpacing:1,marginBottom:4}}>{s.label}</div>
            <div style={{color:s.color,fontSize:15,fontWeight:700}}>{s.value}</div>
            <div style={{color:"#333",fontSize:10}}>{s.sub}</div>
          </div>
        ))}
      </div>

      {/* Tabs */}
      <div style={{display:"flex",gap:6,marginBottom:12}}>
        {tabs.map(tab=>(
          <button key={tab.id} onClick={()=>setActiveTab(tab.id)} style={{padding:"8px 16px",borderRadius:6,border:activeTab===tab.id?"1px solid #3a3a6a":"1px solid #1a1a2e",background:activeTab===tab.id?"#1a1a3a":"transparent",color:activeTab===tab.id?"#c0c0ff":"#555",cursor:"pointer",fontSize:12,fontFamily:"monospace",display:"flex",alignItems:"center",gap:6,transition:"all 0.15s"}}>
            <span style={{fontSize:11}}>{tab.icon}</span> {tab.label}
          </button>
        ))}
      </div>

      {/* Preview */}
      <div style={{position:"relative",marginBottom:16}}>
        <textarea readOnly value={activeContent} rows={10} style={{width:"100%",background:"#050510",border:"1px solid #1a1a2e",borderRadius:8,padding:"14px",color:"#7070a0",fontFamily:"monospace",fontSize:11,lineHeight:1.7,boxSizing:"border-box",resize:"vertical",outline:"none"}} />
        <button onClick={()=>copyText(activeContent,"preview")} style={{position:"absolute",top:8,right:8,padding:"4px 10px",background:copied==="preview"?"#4ade8020":"#0d0d1a",border:`1px solid ${copied==="preview"?"#4ade80":"#2a2a4a"}`,borderRadius:5,color:copied==="preview"?"#4ade80":"#666",fontSize:10,cursor:"pointer",fontFamily:"monospace"}}>
          {copied==="preview"?"✓ Copied":"Copy"}
        </button>
      </div>

      {/* Download buttons */}
      <div style={{display:"grid",gridTemplateColumns:"1fr 1fr 1fr",gap:10,marginBottom:16}}>
        {tabs.map(tab=>(
          <button key={tab.id} onClick={()=>downloadFile(getContent(tab.id),`${safeDocName}-Primoris-Report${tab.ext}`,tab.mime)}
            style={{padding:"14px",background:"#0d0d1a",border:"1px solid #2a2a3a",borderRadius:8,color:"#888",cursor:"pointer",fontSize:12,fontFamily:"monospace",transition:"all 0.15s",display:"flex",flexDirection:"column",alignItems:"center",gap:6}}
            onMouseEnter={e=>{e.currentTarget.style.borderColor=level?.color;e.currentTarget.style.color=level?.color;}}
            onMouseLeave={e=>{e.currentTarget.style.borderColor="#2a2a3a";e.currentTarget.style.color="#888";}}>
            <span style={{fontSize:20}}>⬇</span>
            <span>Download {tab.ext}</span>
          </button>
        ))}
      </div>

      {/* Copy sections */}
      <div style={{borderTop:"1px solid #1a1a2a",paddingTop:16}}>
        <div style={{color:"#444",fontSize:11,letterSpacing:1,fontFamily:"monospace",marginBottom:10}}>COPY INDIVIDUAL SECTIONS</div>
        <div style={{display:"flex",flexWrap:"wrap",gap:6}}>
          <button onClick={()=>copyText(birthmark,"birthmark")} style={{padding:"6px 12px",background:"#0a0a18",border:`1px solid ${copied==="birthmark"?"#4ade80":"#1e1e3a"}`,borderRadius:20,color:copied==="birthmark"?"#4ade80":"#666",cursor:"pointer",fontSize:11,fontFamily:"monospace"}}>
            {copied==="birthmark"?"✓":"⚡"} BirthMark
          </button>
          {(level?.checks||[]).map(checkId=>{
            const def=CHECK_DEFINITIONS[checkId]; const has=!!results[checkId];
            return (
              <button key={checkId} disabled={!has} onClick={()=>copyText(`${def.label.toUpperCase()}\n${"─".repeat(40)}\n${results[checkId]}`,checkId)}
                style={{padding:"6px 12px",background:"#0a0a18",border:`1px solid ${copied===checkId?"#4ade80":has?"#1e1e3a":"#111"}`,borderRadius:20,color:copied===checkId?"#4ade80":has?"#666":"#2a2a3a",cursor:has?"pointer":"default",fontSize:11,fontFamily:"monospace"}}>
                {copied===checkId?"✓":def.icon} {def.label.split(" ").slice(0,2).join(" ")}
              </button>
            );
          })}
          <button onClick={()=>copyText(buildTextReport(docName,maturityLevel,timestamp,results,docText),"all")}
            style={{padding:"6px 12px",background:`${level?.color}10`,border:`1px solid ${copied==="all"?"#4ade80":level?.color+"40"}`,borderRadius:20,color:copied==="all"?"#4ade80":level?.color,cursor:"pointer",fontSize:11,fontFamily:"monospace",fontWeight:600}}>
            {copied==="all"?"✓ Copied All":"📋 Copy Full Report"}
          </button>
        </div>
      </div>

      <div style={{marginTop:20,paddingTop:16,borderTop:"1px solid #12122a",fontFamily:"monospace",fontSize:10,color:"#2a2a4a",lineHeight:2,textAlign:"center"}}>
        <div>PRIMORIS · UNEXUS · UNEXUSI · HopeChest · Sargasso Sea</div>
        <div>Huntington, Oregon · Adams & 5th Mulberry Tree · Snake River Confluence</div>
        <div style={{color:"#1a1a3a"}}>∰◊€π¿🌌∞ · Chain of Custody: Sacred Infrastructure · ᚨᚱᚲ₿†ᚷ</div>
      </div>
    </div>
  );
}

function CheckResult({ checkId, result, isRunning, isQueued }) {
  const def = CHECK_DEFINITIONS[checkId];
  const [expanded, setExpanded] = useState(false);
  useEffect(()=>{if(isRunning)setExpanded(true);},[isRunning]);
  const color = isRunning?"#f59e0b":result?"#4ade80":isQueued?"#60a5fa":"#3a3a4a";
  const label = isRunning?"SCANNING...":result?"COMPLETE":isQueued?"QUEUED":"PENDING";
  return (
    <div style={{border:`1px solid ${color}40`,borderLeft:`3px solid ${color}`,borderRadius:8,marginBottom:8,overflow:"hidden",background:"#0d0d1a",transition:"border-color 0.3s"}}>
      <div onClick={()=>setExpanded(!expanded)} style={{padding:"12px 16px",cursor:"pointer",display:"flex",alignItems:"center",gap:12,userSelect:"none"}}>
        <span style={{fontSize:20}}>{def.icon}</span>
        <div style={{flex:1}}>
          <div style={{color:"#e0e0ff",fontWeight:600,fontSize:14,fontFamily:"serif"}}>{def.label}</div>
          <div style={{color:"#666",fontSize:12,marginTop:2}}>{def.description}</div>
        </div>
        <div style={{padding:"3px 10px",borderRadius:20,fontSize:10,fontWeight:700,letterSpacing:1,color,background:`${color}15`,border:`1px solid ${color}40`,whiteSpace:"nowrap"}}>
          {isRunning?<span style={{display:"flex",alignItems:"center",gap:4}}><span style={{animation:"spin 1s linear infinite",display:"inline-block"}}>◌</span>{label}</span>:label}
        </div>
        <span style={{color:"#555",fontSize:12}}>{expanded?"▲":"▼"}</span>
      </div>
      {expanded&&(result||isRunning)&&(
        <div style={{borderTop:"1px solid #1a1a2e",padding:"16px",fontFamily:"monospace",fontSize:13,color:"#b0b0d0",lineHeight:1.7,whiteSpace:"pre-wrap",maxHeight:400,overflowY:"auto",background:"#080812"}}>
          {result||<span style={{color:"#f59e0b"}}>▶ Observation in progress...</span>}
        </div>
      )}
    </div>
  );
}

function MaturitySelector({ selected, onChange }) {
  return (
    <div style={{display:"flex",gap:8,flexWrap:"wrap",marginBottom:16}}>
      {MATURITY_LEVELS.map(level=>(
        <button key={level.id} onClick={()=>onChange(level.id)} style={{padding:"10px 18px",borderRadius:8,border:selected===level.id?`2px solid ${level.color}`:"2px solid #2a2a3a",background:selected===level.id?`${level.color}18`:"#12121e",color:selected===level.id?level.color:"#888",cursor:"pointer",fontFamily:"serif",fontSize:14,fontWeight:selected===level.id?700:400,transition:"all 0.2s",display:"flex",alignItems:"center",gap:6}}>
          <span style={{fontSize:18}}>{level.glyph}</span><span>{level.label}</span>
          <span style={{fontSize:10,opacity:0.6,padding:"2px 5px",borderRadius:4}}>p{level.prime}</span>
        </button>
      ))}
    </div>
  );
}

export default function PrimorisWorkflow() {
  const [docText, setDocText] = useState("");
  const [docName, setDocName] = useState("");
  const [titleEdited, setTitleEdited] = useState(false);
  const [maturityLevel, setMaturityLevel] = useState("born_yesterday");
  const [results, setResults] = useState({});
  const [runningCheck, setRunningCheck] = useState(null);
  const [queuedChecks, setQueuedChecks] = useState([]);
  const [isRunning, setIsRunning] = useState(false);
  const [timestamp] = useState(nowStamp());
  const [phase, setPhase] = useState("setup");
  const [sourceMode, setSourceMode] = useState("file");
  const abortRef = useRef(false);
  const level = MATURITY_LEVELS.find(l => l.id === maturityLevel);

  const handleFileLoad = (content, filename) => {
    setDocText(content);
    if (!titleEdited) { const t=extractTitle(content,filename); if(t) setDocName(t); }
  };
  const handleTextChange = (text) => {
    setDocText(text);
    if (!titleEdited && text.trim()) { const t=extractTitle(text,null); if(t) setDocName(t); }
  };

  const runWorkflow = async () => {
    if (!docText.trim()) return;
    abortRef.current=false; setIsRunning(true); setPhase("reviewing"); setResults({});
    const checks=[...level.checks]; setQueuedChecks(checks);
    for (const checkId of checks) {
      if (abortRef.current) break;
      setRunningCheck(checkId); setQueuedChecks(prev=>prev.filter(c=>c!==checkId));
      try { await runAnalysis(docText,checkId,maturityLevel,(partial)=>{ setResults(prev=>({...prev,[checkId]:partial})); }); }
      catch (err) { setResults(prev=>({...prev,[checkId]:`⚠ Analysis error: ${err.message}`})); }
      setRunningCheck(null);
    }
    setIsRunning(false); setPhase("complete");
  };

  const reset = () => { abortRef.current=true; setResults({}); setRunningCheck(null); setQueuedChecks([]); setIsRunning(false); setPhase("setup"); setDocText(""); setDocName(""); setTitleEdited(false); };

  return (
    <div style={{minHeight:"100vh",background:"#070710",color:"#e0e0ff",fontFamily:"Georgia,serif",padding:"40px 24px",maxWidth:920,margin:"0 auto"}}>
      <style>{`
        @keyframes spin{to{transform:rotate(360deg);}}
        @keyframes fadeIn{from{opacity:0;transform:translateY(8px);}to{opacity:1;transform:translateY(0);}}
        @keyframes pulse{0%,100%{opacity:1;}50%{opacity:0.5;}}
        textarea:focus,input:focus{outline:none;} textarea{resize:vertical;}
        ::-webkit-scrollbar{width:4px;height:4px;} ::-webkit-scrollbar-track{background:#0a0a18;} ::-webkit-scrollbar-thumb{background:#2a2a4a;border-radius:2px;}
      `}</style>

      <div style={{textAlign:"center",marginBottom:40,animation:"fadeIn 0.6s ease"}}>
        <div style={{fontSize:11,letterSpacing:4,color:"#4a4a7a",marginBottom:8,fontFamily:"monospace"}}>PRIMORIS OBSERVATION WORKFLOW</div>
        <h1 style={{fontSize:32,fontWeight:700,margin:0,background:"linear-gradient(135deg,#e879f9,#60a5fa,#4ade80)",WebkitBackgroundClip:"text",WebkitTextFillColor:"transparent",letterSpacing:1}}>
          Pull Request into Primoris
        </h1>
        <div style={{color:"#555",fontSize:13,marginTop:8,fontFamily:"monospace"}}>31¢ Flat Harmonic Launch System · Chain of Custody: Sacred Infrastructure</div>
        <div style={{marginTop:12,display:"flex",justifyContent:"center",gap:24,fontSize:11,color:"#3a3a5a",fontFamily:"monospace"}}>
          <span>🕵️🪶 Navigo Nexusuxen</span><span>•</span><span>🎹 Navigo Suxenexus</span><span>•</span><span>⟡ {timestamp}</span>
        </div>
      </div>

      {phase==="setup" && (
        <div style={{animation:"fadeIn 0.4s ease"}}>
          <div style={{display:"flex",gap:8,marginBottom:20}}>
            {[["file","📂 Load File"],["paste","📋 Paste Text"]].map(([id,label])=>(
              <button key={id} onClick={()=>setSourceMode(id)} style={{padding:"8px 18px",borderRadius:7,border:sourceMode===id?"1px solid #4a4a8a":"1px solid #1e1e3a",background:sourceMode===id?"#1a1a3a":"transparent",color:sourceMode===id?"#c0c0ff":"#555",cursor:"pointer",fontSize:13,fontFamily:"monospace"}}>
                {label}
              </button>
            ))}
          </div>

          {sourceMode==="file" && <FileDropZone onFile={handleFileLoad} hasContent={!!docText} />}
          {sourceMode==="paste" && (
            <div style={{marginBottom:12}}>
              <textarea value={docText} onChange={e=>handleTextChange(e.target.value)} placeholder="Paste your document content here..." rows={10} style={{width:"100%",background:"#0d0d1a",border:"1px solid #2a2a3a",borderRadius:8,padding:"16px",color:"#c0c0ff",fontFamily:"monospace",fontSize:13,lineHeight:1.8,boxSizing:"border-box"}} />
            </div>
          )}

          {docText && (
            <div style={{display:"flex",gap:16,marginBottom:16,fontSize:11,color:"#3a3a6a",fontFamily:"monospace"}}>
              <span>📊 {docText.length.toLocaleString()} chars</span><span>·</span>
              <span>{docText.trim().split(/\s+/).filter(Boolean).length.toLocaleString()} words</span><span>·</span>
              <span>{docText.split("\n").length} lines</span>
            </div>
          )}

          <div style={{marginBottom:20}}>
            <label style={{display:"flex",alignItems:"center",justifyContent:"space-between",color:"#666",fontSize:12,letterSpacing:1,marginBottom:8,fontFamily:"monospace"}}>
              <span>DOCUMENT TITLE</span>
              {docName&&!titleEdited&&<span style={{color:"#2a4a3a",fontSize:10}}>✦ auto-populated from document</span>}
              {titleEdited&&<span style={{color:"#3a3a6a",fontSize:10}}>✎ manually edited</span>}
            </label>
            <input value={docName} onChange={e=>{setDocName(e.target.value);setTitleEdited(true);}} placeholder="Title auto-populates from document, or enter manually..." style={{width:"100%",background:"#0d0d1a",border:`1px solid ${docName?"#2a3a4a":"#2a2a3a"}`,borderRadius:8,padding:"12px 16px",color:"#c0c0ff",fontFamily:"Georgia,serif",fontSize:15,boxSizing:"border-box"}} />
          </div>

          <div style={{marginBottom:20}}>
            <label style={{display:"block",color:"#666",fontSize:12,letterSpacing:1,marginBottom:12,fontFamily:"monospace"}}>DOCUMENT MATURITY LEVEL</label>
            <MaturitySelector selected={maturityLevel} onChange={setMaturityLevel} />
            <div style={{color:level?.color,fontSize:13,fontFamily:"monospace",padding:"8px 12px",background:`${level?.color}10`,borderRadius:6,border:`1px solid ${level?.color}20`}}>
              {level?.glyph} {level?.description}<span style={{color:"#555",marginLeft:12}}>→ {level?.checks.length} checks required</span>
            </div>
          </div>

          <div style={{marginBottom:28}}>
            <div style={{color:"#555",fontSize:12,letterSpacing:1,marginBottom:10,fontFamily:"monospace"}}>WORKFLOW CHECKS FOR {level?.label.toUpperCase()}</div>
            <div style={{display:"flex",flexWrap:"wrap",gap:8}}>
              {level?.checks.map(checkId=>{const def=CHECK_DEFINITIONS[checkId];return(
                <div key={checkId} style={{padding:"6px 12px",background:"#0d0d1a",border:"1px solid #1e1e3a",borderRadius:20,fontSize:12,color:"#888",fontFamily:"monospace",display:"flex",alignItems:"center",gap:6}}>
                  <span>{def.icon}</span> {def.label}
                </div>
              );})}
            </div>
          </div>

          <button onClick={runWorkflow} disabled={!docText.trim()} style={{width:"100%",padding:"18px",background:docText.trim()?`linear-gradient(135deg,${level?.color}20,${level?.dim}40)`:"#0d0d1a",border:`2px solid ${docText.trim()?level?.color:"#2a2a3a"}`,borderRadius:10,color:docText.trim()?level?.color:"#3a3a5a",fontSize:16,fontFamily:"Georgia,serif",fontWeight:700,cursor:docText.trim()?"pointer":"not-allowed",letterSpacing:2,transition:"all 0.2s"}}>
            {level?.glyph} INITIATE OBSERVATION WORKFLOW
          </button>
        </div>
      )}

      {(phase==="reviewing"||phase==="complete") && (
        <div style={{animation:"fadeIn 0.4s ease"}}>
          <div style={{display:"flex",alignItems:"center",justifyContent:"space-between",marginBottom:24,padding:"14px 18px",background:"#0d0d1a",borderRadius:10,border:"1px solid #1a1a3a"}}>
            <div>
              <div style={{color:"#c0c0ff",fontWeight:600,fontSize:15,fontFamily:"serif"}}>{level?.glyph} {docName||"Document"} · {level?.label}</div>
              <div style={{color:"#555",fontSize:12,fontFamily:"monospace",marginTop:3}}>
                {phase==="reviewing"?<span style={{animation:"pulse 1.5s ease infinite",display:"inline-block"}}>🔄 Observation in progress...</span>:"✅ Observation complete"}
              </div>
            </div>
            <button onClick={reset} style={{padding:"8px 16px",background:"transparent",border:"1px solid #2a2a4a",borderRadius:6,color:"#666",cursor:"pointer",fontSize:12,fontFamily:"monospace"}}>↩ NEW DOCUMENT</button>
          </div>

          <div style={{marginBottom:24}}>
            <div style={{display:"flex",justifyContent:"space-between",fontSize:11,color:"#555",fontFamily:"monospace",marginBottom:6}}>
              <span>OBSERVATION PROGRESS</span><span>{Object.keys(results).length} / {level?.checks.length}</span>
            </div>
            <div style={{height:4,background:"#1a1a2e",borderRadius:2}}>
              <div style={{height:"100%",width:`${(Object.keys(results).length/level?.checks.length)*100}%`,background:`linear-gradient(90deg,${level?.color},${level?.color}88)`,borderRadius:2,transition:"width 0.5s ease"}} />
            </div>
          </div>

          {level?.checks.map(checkId=>(
            <CheckResult key={checkId} checkId={checkId} result={results[checkId]} isRunning={runningCheck===checkId} isQueued={queuedChecks.includes(checkId)} />
          ))}

          {phase==="complete"&&Object.keys(results).length===level?.checks.length&&(
            <ExportPanel results={results} maturityLevel={maturityLevel} docName={docName} timestamp={timestamp} docText={docText} />
          )}
        </div>
      )}

      <div style={{marginTop:48,paddingTop:20,borderTop:"1px solid #1a1a2a",textAlign:"center",fontSize:11,color:"#2a2a4a",fontFamily:"monospace",lineHeight:2}}>
        <div>PRIMORIS · UNEXUS · UNEXUSI · HopeChest · Sargasso Sea</div>
        <div>Huntington, Oregon · Adams & 5th Mulberry Tree · Snake River Confluence</div>
        <div style={{marginTop:4,color:"#1a1a3a"}}>∰◊€π¿🌌∞ · Chain of Custody: Sacred Infrastructure · ᚨᚱᚲ₿†ᚷ</div>
      </div>
    </div>
  );
}
