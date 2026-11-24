// Stravenford Academy: starts MCP for Blender from %USERPROFILE%\.blender-mcp-py311,
// passes stdin/stdout through, and writes errors to %USERPROFILE%\.blender-mcp-py311\launcher_log.txt
const { spawn } = require("child_process");
const path = require("path"), os = require("os"), fs = require("fs");
const home = path.join(os.homedir(), ".blender-mcp-py311");
const exe = path.join(home, "Scripts", "mcp-for-blender.exe");
let log = null;
try { log = fs.createWriteStream(path.join(home, "launcher_log.txt"), { flags: "a" }); } catch (e) {}
const w = (s) => { try { log && log.write(new Date().toISOString() + " " + s + "\n"); } catch (e) {} };
w("launcher start, node " + process.version + ", connector found: " + fs.existsSync(exe));
if (!fs.existsSync(exe)) { w("connector missing: run 1_Install_Blender_for_Claude.bat first"); process.exit(1); }
const child = spawn(exe, [], {
  stdio: ["pipe", "pipe", "pipe"], windowsHide: true,
  env: { ...process.env, DISABLE_TELEMETRY: "1", BLENDER_MCP_DISABLE_TELEMETRY: "1", MCP_DISABLE_TELEMETRY: "1", PYTHONUNBUFFERED: "1" },
});
process.stdin.on("data", (d) => child.stdin.write(d));
process.stdin.on("end", () => { w("stdin end"); child.stdin.end(); });
child.stdout.on("data", (d) => process.stdout.write(d));
child.stderr.on("data", (d) => { const t = d.toString(); if (/error|traceback|exception/i.test(t)) w("ERR " + t.slice(0, 2000)); process.stderr.write(d); });
child.on("error", (e) => { w("spawn error " + e.message); process.exit(1); });
child.on("exit", (code, sig) => { w("child exit " + code + " " + sig); process.exit(code ?? 0); });
for (const s of ["SIGINT", "SIGTERM"]) process.on(s, () => { w("signal " + s); child.kill(); });
