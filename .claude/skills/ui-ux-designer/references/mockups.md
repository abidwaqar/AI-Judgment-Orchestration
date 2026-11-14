<!-- Adapted from the orchestration behind Gryter (gryter.com), an AI fitness coach built by one engineer. -->
# Mockups: how they're built and rendered

This is for the `ui-ux-designer` subagent, which writes requirement mockups as HTML, and for the lead, which renders and checks them. Both read it before any mockup work. What gets drawn is in the skill's §6.

## The page

- **Tokens.** Copy the colour and type values from the project's theme into CSS variables. A class that swaps the variables (`.light`, `.dark`) gives each other theme. Use no colour or size the theme doesn't have.
  <!-- ADAPT:design-tokens — where the theme's colour and type values, the font files and the image assets live, so the designer copies real values. Example: "Colours in src/theme/colors.ts, type in src/theme/typography.ts, Inter from public/fonts/InterVariable.woff2, icons in src/assets/icons/, the logo in assets/brand/logo.svg." -->
- **The font** comes from the project's own font file, loaded with `@font-face`, so lines wrap where they will in the product.
- **Match how the product renders text.** Some UI toolkits add letter spacing or line height that the browser doesn't. Compare one line of text in the product with the same line in the mockup and match them, or a line that wraps in the product fits in the mockup.
- **Real assets.** Use the product's own icons, images and logo, never stand-ins that change a layout.
- **Frames.** <!-- ADAPT:app-type — the frame sizes and how frames sit on a sheet. Example for a phone app: "Phones 390 × 820 at 1×, three to a sheet 1338 px wide." For a website: "Each state twice, in a 390-wide phone frame and a 1280-wide desktop frame, one state per sheet." -->
  - Every card sits whole inside its frame: split edge cases across frames rather than stacking them. A card cut off by the frame counts as undrawn.
  - A `?only=N` query shows frame N alone, for an attachment rendered at device scale 2.
- **Comparing variants,** such as direction sketches: give every variant the same list length and scroll position.
- **Scripts.** Don't name a global `top`, `name`, `status` or `parent`. They clash with the browser's own, and the page renders blank.
- **Measure in the page, not by eye.** Where a width or height decides whether something fits, have a script write it out after `document.fonts.ready`.

## Rendering

The designer has no shell, so the lead renders each sheet with headless Chrome:

```bash
"$CHROME" --headless=new --hide-scrollbars \
  --allow-file-access-from-files --force-device-scale-factor=1 --window-size=1338,<height> \
  --screenshot="<sheet>.png" "file:///<page>.html"
```

`$CHROME` is the browser's path: for example `/c/Program Files/Google/Chrome/Application/chrome.exe` in Git Bash on Windows, `/Applications/Google Chrome.app/Contents/MacOS/Google Chrome` on macOS, or `google-chrome` on Linux. Set the window width to the sheet's width.

- **Check the console before reading a render.**
  - Render the page once with `--enable-logging=stderr --v=0 --dump-dom`, and look for `CONSOLE` lines.
  - A PNG of a few KB is a blank render.
- **Read only shrunk copies.** The Read tool can overwrite an image whose longest side is over 1,500 px. Make a copy under 1,500 px on its longest side, read that, and never read the original.
- **Write any build script to a file** and run it by path. Long heredocs break in some shells, Git Bash among them.
