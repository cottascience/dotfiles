// --- Octarine Doclinks ----------------------------------------------------
// Octarine stores pasted images in ./.attachments/ but links them with its
// own [[file.png]] wikilink syntax, which standard Markdown (marked) ignores.
// This extension rewrites [[...]] so md-to-pdf renders the images, letting you
// keep editing naturally in Octarine without hand-fixing every link.
const ATTACHMENTS_DIR = ".attachments";
const IMAGE_RE = /\.(png|jpe?g|gif|svg|webp|avif|bmp)$/i;

const octarineDoclinks = {
  extensions: [
    {
      name: "doclink",
      level: "inline",
      start(src) {
        return src.indexOf("[[");
      },
      tokenizer(src) {
        const match = /^\[\[([^\]]+?)\]\]/.exec(src);
        if (!match) return;
        // Support an optional display alias: [[target|alias]]
        const [target, alias] = match[1].split("|").map((s) => s.trim());
        return { type: "doclink", raw: match[0], target, alias: alias || target };
      },
      renderer(token) {
        if (IMAGE_RE.test(token.target)) {
          const src = `${ATTACHMENTS_DIR}/${encodeURIComponent(token.target)}`;
          const alt = token.alias.replace(/"/g, "&quot;");
          return `<img src="${src}" alt="${alt}">`;
        }
        // A link to another note has no PDF target — render the label as text.
        return token.alias;
      },
    },
  ],
};

// Octarine handling is on by default; `md-to-pdf --raw` (the ~/.zshrc wrapper
// sets MD_TO_PDF_RAW=1) skips it so plain Markdown compiles with [[...]] left
// untouched and no .attachments/ lookup.
const rawMode = process.env.MD_TO_PDF_RAW === "1";

module.exports = {
  ...(rawMode ? {} : { marked_extensions: [octarineDoclinks] }),

  // --- MathJax (unchanged) -------------------------------------------------
  script: [
    { content: "window.MathJax = { tex: { inlineMath: [['$', '$']] } };" },
    { url: "https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js" },
  ],

  // GitHub-Light syntax tokens, matching the site's Rouge theme.
  highlight_style: "github",

  // --- Web fonts: the cottascience.github.io palette -----------------------
  // Fraunces (variable, optical-size axis) for display headings, Lora for the
  // serif body, JetBrains Mono for every label / caption / code run.
  stylesheet: [
    "https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,400;0,9..144,500;0,9..144,600;1,9..144,300;1,9..144,400&family=Lora:ital,wght@0,400;0,500;0,600;1,400&family=JetBrains+Mono:wght@400;500&display=swap",
  ],

  // --- The look (ported from assets/main.scss) -----------------------------
  css: `
    :root {
      --text:        #2A2620;   /* warm dark-brown ink */
      --muted:       #5A5F7A;   /* slate-blue, for captions & asides */
      --accent:      #B5563A;   /* the brick-red, on links & rules */
      --rule:        rgba(42, 38, 32, 0.30);
      --rule-soft:   rgba(42, 38, 32, 0.15);
      --bg:          #ffffff;   /* plain white page — warmth lives only in the boxes */
      --box:         #FBF0E8;   /* warm cream, only on boxed elements */
      --box-strong:  #F7E2D6;   /* a touch more saturated, for emphasis */
      --box-border:  rgba(181, 86, 58, 0.22);
      --code-text:   #1f2328;
    }

    /* Plain white sheet. Margins live in @page (not Puppeteer's pdf margin)
       so the page background fills uniformly and the text measure comes from
       the margins — no max-width to overflow them. */
    @page { margin: 18mm 22mm; }
    html { background-color: var(--bg); }

    body {
      font-family: 'Lora', Georgia, "Times New Roman", serif;
      font-size: 15px;
      line-height: 1.62;
      color: var(--text);
      background: transparent;
      margin: 0;            /* the @page margin defines the measure — no max-width to overflow it */
      -webkit-font-smoothing: antialiased;
      text-rendering: optimizeLegibility;
    }

    /* Fraunces display serif. Hierarchy comes from optical size + weight + air,
       not sheer scale. Optical-size axis tracks the size, the way the site does. */
    h1, h2, h3, h4, h5, h6 {
      font-family: 'Fraunces', 'Merriweather', Georgia, serif;
      font-weight: 500;
      color: var(--text);
      line-height: 1.18;
      letter-spacing: -0.005em;
      font-variation-settings: "opsz" 96;
      margin: 1.5em 0 0.5em;
    }
    h1 { font-size: 2.1rem;  margin-top: 0; font-variation-settings: "opsz" 144; }
    h2 { font-size: 1.55rem; font-variation-settings: "opsz" 120; }
    h3 { font-size: 1.2rem;  font-variation-settings: "opsz" 96; }

    /* The site leans on JetBrains-Mono uppercase micro-labels everywhere
       (nav, post-meta, callout titles) — h4 adopts that voice. */
    h4 {
      font-family: 'JetBrains Mono', "SFMono-Regular", Menlo, monospace;
      font-size: 0.78rem;
      font-weight: 500;
      color: var(--muted);
      text-transform: uppercase;
      letter-spacing: 0.08em;
    }
    h5, h6 { font-size: 1rem; }

    .thin { font-weight: 300; font-style: italic; }

    /* Don't let a heading float away from the text it introduces */
    h1, h2, h3, h4 { break-after: avoid; }

    p { margin: 0 0 0.85em; }

    /* No hover in print, so links carry a faint resting underline. */
    a {
      color: var(--accent);
      text-decoration: none;
      border-bottom: 1px solid rgba(181, 86, 58, 0.35);
    }
    strong { font-weight: 600; }

    /* Inline + block code: warm cream box, GitHub-Light tokens on top */
    code {
      font-family: 'JetBrains Mono', "SFMono-Regular", Menlo, Consolas, monospace;
      font-size: 0.86em;
      background: var(--box);
      color: var(--code-text);
      border: 1px solid var(--box-border);
      border-radius: 4px;
      padding: 0.1em 0.4em;
    }
    pre {
      background: var(--box);
      border: 1px solid var(--box-border);
      border-radius: 4px;
      padding: 12px 16px;
      margin: 1em 0;
      overflow-x: auto;
      font-size: 0.85em;
      line-height: 1.5;
    }
    pre code { background: none; border: 0; padding: 0; font-size: inherit; }
    /* let our <pre> fill show through the github highlight.js theme */
    .hljs { background: transparent !important; }

    /* Warm-cream aside box */
    blockquote {
      margin: 1em 0;
      padding: 0.55em 1em;
      border-left: 3px solid var(--accent);
      border-radius: 0 4px 4px 0;
      background: var(--box);
      color: var(--muted);
      font-style: italic;
    }
    blockquote > :first-child { margin-top: 0; }
    blockquote > :last-child  { margin-bottom: 0; }

    /* Booktabs tables: horizontal rules only, no grid */
    table { border-collapse: collapse; width: 100%; margin: 1.1em 0; font-size: 0.92em; }
    th, td { padding: 0.35em 0.7em; text-align: left; }
    thead th { border-bottom: 2px solid var(--text); }
    tbody tr { border-bottom: 1px solid var(--rule-soft); }

    hr  { border: none; border-top: 1px solid var(--rule); margin: 1.6em 0; }

    /* Framed content images, the way the site borders them.
       border-box so max-width includes the frame — otherwise a full-width image
       overflows the measure by the border width and the right stroke clips. */
    img {
      box-sizing: border-box;
      max-width: 100%;
      display: block;
      margin: 1em auto;
      border: 1px solid var(--text);
      border-radius: 3px;
    }

    /* Em-dash list markers in mono, lifted from the site.
       Injected via ::before — string list-style-type isn't reliable in print. */
    ol { padding-left: 1.4em; margin: 0 0 0.85em; }
    ul { list-style: none; padding-left: 0; margin: 0 0 0.85em; }
    li { margin: 0.3em 0; }
    li > ul, li > ol { margin-bottom: 0; }
    ul > li { position: relative; padding-left: 1.5em; }
    ul > li::before {
      content: "—";
      position: absolute;
      left: 0;
      color: rgba(42, 38, 32, 0.5);
      font-family: 'JetBrains Mono', monospace;
    }

    /* Italic figure captions */
    figure { margin: 1.6em auto; text-align: center; }
    figcaption {
      font-family: 'Lora', Georgia, serif;
      font-style: italic;
      font-size: 0.92em;
      color: var(--muted);
      margin-top: 0.6em;
      line-height: 1.5;
    }

    /* Callouts — write as <blockquote class="note|tip|warn|aside"> ... .
       Left bar + a mono uppercase label, mirroring the site's _includes. */
    blockquote.note, blockquote.tip, blockquote.warn, blockquote.aside {
      border: 0;
      border-left: 3px solid rgba(42, 38, 32, 0.4);
      border-radius: 0 4px 4px 0;
      background: var(--box);
      padding: 0.7em 1em;
      margin: 1.6em 0;
      font-size: 0.92em;
      font-style: normal;
      color: var(--text);
    }
    blockquote.note::before, blockquote.tip::before,
    blockquote.warn::before, blockquote.aside::before {
      display: block;
      margin-bottom: 0.35em;
      font-family: 'JetBrains Mono', monospace;
      font-size: 0.7em;
      font-weight: 500;
      text-transform: uppercase;
      letter-spacing: 0.16em;
    }
    blockquote.note  { border-left-color: #8B4A62; }
    blockquote.note::before  { content: "note";  color: #8B4A62; }
    blockquote.tip   { border-left-color: #5C8B7E; }
    blockquote.tip::before   { content: "tip";   color: #5C8B7E; }
    blockquote.warn  { border-left-color: #B5563A; background: var(--box-strong); }
    blockquote.warn::before  { content: "warn";  color: #B5563A; }
    blockquote.aside { border-left-color: rgba(42, 38, 32, 0.4); font-style: italic; }
    blockquote.aside::before { content: "aside"; color: var(--text); }

    /* A little air around display equations */
    mjx-container[display="true"] { margin: 0.9em 0 !important; }
  `,

  // --- Page setup ----------------------------------------------------------
  pdf_options: {
    format: "A4",
    margin: "0", // margins come from @page so the off-white fills edge-to-edge (no white seam)
    printBackground: true, // REQUIRED so the off-white sheet + box fills render
  },
};
