// scripts/generate-barrel.js
const fs = require("fs");
const path = require("path");

const tsDir = path.resolve(__dirname, "../app/javascript/core");
const outFile = path.join(tsDir, "index.ts");

const files = fs
  .readdirSync(tsDir)
  .filter((f) => f.endsWith(".ts") && f !== "index.ts");

const lines = files.map((f) => {
  const name = path.basename(f, ".ts");
  return `export * from "./${name}";`;
});

const content =
  "// This file is auto-generated — DO NOT edit manually.\n" +
  lines.join("\n") +
  "\n";

fs.writeFileSync(outFile, content);
console.log(`✅ Generated ${outFile} with ${files.length} exports`);
