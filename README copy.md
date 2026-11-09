# tidytools — Flutter MVP product and implementation brief

This document describes the behavior implemented by the current tidytools browser app and turns it into an implementation brief for a Flutter MVP. Treat the behavior below as the parity target; it records what the source currently does, not a promise that every advertised control is fully implemented.

## Product summary

tidytools is a small collection of private, on-device utilities. The current app is a single-page React application with seven tools:

1. Merge PDF files
2. Generate QR codes
3. Scan QR codes from images
4. Generate passwords
5. Convert images to PDF and PDF pages to PNG
6. Read barcodes from images
7. Generate barcodes

The existing implementation is a browser-only frontend. It has no application server, user accounts, database, network API, cloud file storage, or persistence layer. User-selected files and generated outputs are handled in the browser. The Flutter MVP should preserve this local-processing model and should not add upload behavior.

The repository currently contains the frontend source, not the original Python desktop programs mentioned by older project copy.

## Run and validate the existing app

Requirements: Node.js and npm.

```bash
cd frontend
npm install
npm run dev
```

Other project commands:

```bash
npm run lint
npm run build
npm run preview
```

`npm run dev` starts Vite's development server. `npm run build` creates the production web bundle in `frontend/dist`; `npm run preview` serves that bundle locally.

## Product behavior and navigation

### Home and app shell

- The home screen shows the tidytools brand, a workspace header, a privacy statement, a seven-tool count, cards for each tool, a simple activity/status panel, and a short privacy note.
- Selecting a tool card or sidebar item opens that tool. The tool's “Your tools” button returns to the home screen. Selecting the brand or Overview also returns home.
- Navigation is in-memory screen selection, not URL routing. Opening a tool does not create a shareable route or browser-history entry.
- A sidebar provides Overview and all seven tools. On small screens it becomes a slide-in menu; choosing a tool closes it.
- The layout is dark, with muted green and lilac accents. It adapts from three home-card columns to two and then one as the viewport narrows.
- The header's Help button and the QR preview's “More options” button are visible but have no action in the current code. Do not treat them as required working MVP features.
- The home activity panel is not a real history. It only changes its short status text when PDF files have been selected or a QR code has been generated; it does not retain, display, or reopen past jobs.

### State lifetime

- PDF merge and QR generator state are held above the individual tool screens. Their inputs/results generally remain when navigating away and back during the same app session.
- Image/PDF conversion, password generation, QR scanning, and barcode reading state live inside their screens and is lost when leaving that screen.
- Nothing is saved between app launches. There is no settings or job-history persistence.

## Tool specifications

### 1. Merge PDF

**Purpose:** Combine two or more PDFs into one PDF, with pages ordered by the user's file order.

**Flow and behavior**

1. Add PDFs through the system file picker or by dropping files into the drop area.
2. Accept files by a `.pdf` filename extension (case-insensitive); other selected/dropped items are skipped with a count and an explanation.
3. Append accepted files to the current list. A repeat selection is ignored when its filename, byte size, and last-modified timestamp match a file already in the list.
4. Display each file's name, approximate size, and one-based position.
5. Reorder files using the row's drag-and-drop interaction or the up/down controls. Remove individual files or add more.
6. Disable merge until at least two files are present. While merging, show progress based on the number of files processed.
7. Read each PDF, copy all its pages in original internal page order, and append those pages in file-list order.
8. Download the result as `merged-documents.pdf`.

**Validation and errors**

- Attempting to merge fewer than two files produces “Add at least two PDF files to get started.”
- Invalid, damaged, encrypted/locked, or unsupported PDFs can fail during parsing. Show a merge error rather than generating a success result.
- A successful result reports the number of PDFs merged.

**Parity details**

- The implementation merges every page; there is no page-range selector, rotation, compression, encryption, watermark, or output filename setting.
- The implementation checks filename extension, not PDF MIME type or file contents, before adding to the list.
- There is no explicit maximum number or size of files.

### 2. QR code generator

**Purpose:** Generate an on-device QR code for common shareable content, preview it, and download PNG or SVG.

**Supported content types and payloads**

| Type | Input and current payload behavior |
|---|---|
| URL | A non-empty value is required. If it does not begin with `http://` or `https://` (case-insensitive), prefix `https://`. Parse it as a URL and require a hostname. |
| Text | Non-empty text, up to 1,800 characters in the UI, is encoded unchanged after trimming leading/trailing whitespace. |
| Email | Require a basic `local@domain.tld` shape; encode as `mailto:<address>`. |
| Phone | Require at least one digit; encode as `tel:` followed by the input with everything except digits and `+` removed. |
| SMS | Require non-empty input. If it starts with lowercase `sms:`, use it as-is; otherwise prefix `sms:`. No phone-number validation is performed. |
| WiFi | Require a network name. Encode the Wi-Fi standard payload `WIFI:T:<security>;S:<escaped-SSID>;P:<escaped-password>;;`. Escape backslash, semicolon, comma, colon, and quote in SSID/password. Security is WPA by default, selectable as WPA, WEP, or no password. Without a password, the payload uses `nopass` and omits `P`. An uppercase preformatted `WIFI:` payload can be passed through. |
| vCard | Build a vCard 3.0 payload from optional name, phone, email, and organization fields; at least one detail is required. The generated body uses `BEGIN:VCARD`, `VERSION:3.0`, populated `FN`/`N`/`TEL`/`EMAIL`/`ORG` lines, and `END:VCARD`. A raw value beginning with uppercase `BEGIN:VCARD` is passed through. |

**Appearance, preview, and export**

- Error-correction options: Low (`L`), Medium (`M`), Quartile (`Q`), and High (`H`). Default is Medium.
- The user can choose the dark module color; the background remains white. Default module color is `#15231f`.
- A generated preview is 320 pixels wide with a two-module margin. Show the normalized payload under the preview.
- PNG is the default download format and is named `my-qr-code.png`. SVG export is named `my-qr-code.svg`.
- Changing type, content, color, correction level, or format does not automatically regenerate an existing image. The user presses Generate QR code to make a new preview. SVG export is generated from the current payload and current correction/color settings at download time; PNG downloads the generated preview.
- “Start fresh” clears the content fields, generated image/payload, and error, then focuses the active content field. It does not reset the selected type, correction level, color, or output format.

**Batch generation**

- The user can select a `.txt` file. Trim each line and ignore blank lines; each remaining line is one entry interpreted using the currently selected QR content type.
- Use the selected output format, correction level, and module color for all entries. Save successful QR files as `qr_0001.png` / `.svg`, incrementing the number by input line position, and bundle them into `qr_codes.zip`.
- Continue after an invalid line. Report the number downloaded and number skipped. If every line fails, show an error (including up to the first two line errors).
- Batch mode uses each line as the selected type's direct value; it does not use the separate Wi-Fi or vCard form fields.

### 3. QR scanner

**Purpose:** Decode one QR code from an uploaded image; this is not a live camera scanner.

**Flow and behavior**

1. Choose one browser-supported image file.
2. Clear the previous decoded result/error and display a local preview of the selected image.
3. Decode QR format only. Show a busy state while scanning.
4. On success, display the decoded content and a Copy result action.
5. If the decoded value is an `http:` or `https:` URL, display it as a link opening in a new tab; otherwise display it as plain text.
6. Show a specific “No QR code was found” message when decoding finds no QR code; show a separate error for other scan failures.
7. Revoke the temporary preview URL when the screen/image changes or is removed.

Clipboard access may be unavailable; show an error and leave the result visible for manual selection/copying.

### 4. Password generator

**Purpose:** Generate a cryptographically random password on the device.

- Default length: 16. Selectable length: 8–64, via slider or number input.
- Character categories are independently selectable and enabled by default:
  - Uppercase: `A-Z`
  - Lowercase: `a-z`
  - Numbers: `0-9`
  - Symbols: `!@#$%^&*()-_=+[]{};:,.?`
- Each generated password includes at least one character from every selected category. Remaining characters are selected from the combined enabled character pool.
- Random values come from the platform cryptographic random source. Selection uses rejection sampling to avoid modulo bias and shuffles the result with Fisher–Yates.
- Copy is available after generation. On clipboard failure, keep the password visible and ask the user to copy it manually.
- Changing length or selected categories clears the displayed password and copied status. The user must press Generate password again.
- Show an error if no categories are enabled or if the length cannot fit one character per enabled category.
- There is no password strength score, history, save action, or server-side generation.

### 5. Image ↔ PDF

The tool has two mutually exclusive modes. Switching mode clears the selected files, progress, and message.

#### Images to PDF

- Select one or more PNG, JPEG, or WebP images. Unsupported image types are skipped and reported.
- Each image becomes one page in selection order.
- Decode and draw each source image into a PNG, then embed it in a new PDF. Preserve aspect ratio and size the page so its longest dimension is 842 PDF points.
- Download one file named `images.pdf`.
- Report how many images were converted. Show progress per image.

#### PDF to images

- Select one or more PDF files. Accept the PDF MIME type or `.pdf` extension; unsupported items are skipped.
- Render every page of each PDF as a PNG. The rendering scale is at most 2 and is reduced as needed so the longest output dimension is no more than 1,600 pixels.
- Bundle images into `pdf-pages.zip`. Each source PDF has a folder named from its filename stem plus a one-based file number (for example `report-1`); each page is named `page-001.png`, `page-002.png`, etc.
- Show overall progress across all pages and report the total exported page count.
- Release page/document rendering resources after use.

In either mode, files remain local. The user can remove selected files before conversion. There is no reordering UI, image editing, custom page size, or compression control.

### 6. Barcode reader

**Purpose:** Read a barcode from a selected image, not from a live camera stream.

- Accept one image file and display its preview locally.
- Decode a barcode using the reader library's default supported formats (the UI describes common 1D and 2D formats).
- Show decoded text and the detected format, plus a Copy result action.
- Distinguish “no barcode found” from other read failures.
- Revoke the temporary preview URL when replaced/removed. Clipboard failures are reported and the result remains visible.

### 7. Barcode generator

**Purpose:** Generate and download an SVG barcode.

- Enter a non-empty value and choose one format:
  - Code 128 (default)
  - EAN-13
  - UPC-A
  - Code 39
  - ITF
  - Codabar
- Press Generate barcode or Enter. Clear the previous generated state before attempting a new generation.
- Generate a black-on-white barcode with width 2, height 100, human-readable value, 12-pixel margin, and monospace 16-pixel text.
- Format-specific invalid values produce an error and no successful preview.
- Download the generated SVG as `barcode-<format>.svg`.
- Copy barcode value copies the trimmed input text, not the SVG/image data.
- Editing the value or changing format invalidates the preview and copied status. The user must generate again.

## Flutter MVP implementation plan

### Screens and navigation

Build a home/dashboard screen and one screen per tool. A persistent navigation drawer/sidebar should expose Overview and the seven tools; use a compact menu on narrow layouts. Each tool screen should have a clear back-to-tools action.

Suggested organization (adapt to the chosen Flutter architecture):

```text
lib/
  app/
    app.dart
    navigation.dart
    theme.dart
  features/
    home/
    pdf_merge/
    qr_generate/
    qr_scan/
    password/
    image_pdf/
    barcode_read/
    barcode_generate/
  shared/
    file_models.dart
    local_file_service.dart
    widgets/
```

Keep tool logic out of widget build methods. A feature controller/notifier should own each tool's inputs, busy state, progress, validation/errors, and result. Model selected files and conversion results explicitly. Do not persist selected files, generated passwords, or job history in the MVP.

### Platform capabilities and parity

Choose Flutter packages/platform APIs by capability, then verify supported target platforms and licensing before adoption:

- File picking and local file reads for PDFs, images, and text batch input.
- PDF parsing/page copying and PDF creation.
- PDF page rasterization and image encoding.
- ZIP archive creation.
- QR encoding with payload, correction-level, color, PNG, and SVG support.
- QR/barcode decoding from an image file. Live camera scanning is not part of current parity.
- Barcode generation as SVG.
- Cryptographically secure random bytes, clipboard, and platform-appropriate save/share/export.

Web and mobile have different save and file-picker UX. Preserve the same filenames and outputs where the platform permits; use a save/share sheet on mobile and a browser download on web. Do not upload files to make conversion work. Explain any unavoidable platform-specific limits to the user.

### UI and accessibility

- Preserve the calm, dark green/lilac visual identity and straightforward tool-first dashboard.
- Make the layout responsive without forcing horizontal overflow on small phones. The existing web app targets a 360-pixel minimum viewport and switches layout around 640, 850, and 1,080 pixels.
- Use semantic labels, keyboard/focus visibility, meaningful button labels, and accessible status/error announcements. Keep progress visible and prevent duplicate actions while a job is running.
- Keep input/result content readable and copyable. Provide clear empty, loading, success, validation-error, and processing-error states.
- Do not imply that an operation succeeded until the output has been created and made available for saving.

## MVP acceptance checklist

### General

- [ ] Home screen lists all seven tools and navigation can open each one and return home.
- [ ] Tool navigation works at phone and tablet widths; there is no accidental file upload or account requirement.
- [ ] Errors are visible, operation state is clear, and selected files/results are not persisted after app restart.

### PDF merge

- [ ] Pick/drop PDFs, skip non-PDF names, ignore duplicates, reorder, remove, and add more.
- [ ] Merge is disabled until two files are selected.
- [ ] Output page order matches file order and source page order; output name is `merged-documents.pdf`.
- [ ] Invalid/locked input reports an error and does not show a false success.

### QR generation

- [ ] Generate and verify URL, Text, Email, Phone, SMS, Wi-Fi, and vCard codes with the payload rules above.
- [ ] Error-correction, color, PNG/SVG export, and output filenames work.
- [ ] Batch text input ignores blank lines, skips invalid entries, and downloads a ZIP with correctly named files.
- [ ] Start fresh clears form content/result while retaining selected QR type and display settings.

### Scanning and generation tools

- [ ] QR scanner and barcode reader each accept image files, show preview/result, distinguish not-found from failure, and support copying.
- [ ] Password output respects length/categories and uses a cryptographically secure random source; clipboard failure is recoverable.
- [ ] Barcode generator supports the six listed formats, validates through the encoder, downloads SVG, and copies the input value.

### Image/PDF conversion

- [ ] PNG/JPEG/WebP inputs produce one PDF page each in selection order and download as `images.pdf`.
- [ ] One or more PDFs produce a ZIP of page-numbered PNGs grouped by source PDF, with bounded render size and progress.
- [ ] Invalid inputs report conversion failure; temporary rendering resources are released.

## Current-code observations for the Flutter port

These are important parity details and implementation opportunities, not additional product requirements:

- The Help and More options buttons are currently visual-only.
- The home “activity” card is a status message, not a job log.
- The current UI says files stay on the device; the Flutter implementation must uphold that statement for every tool and any third-party library it chooses.
- There is no automated test suite in the current frontend manifest; lint and production build are the available validation commands.
- The current app has no camera-based QR/barcode scanning, account system, cloud sync, settings persistence, saved-output list, or file history.
- Some QR form values are kept when changing QR types. The visible fields change, but switching type does not reset all previously entered content.
- Conversion and scan screens release temporary browser resources; use Flutter's corresponding cleanup/disposal practices for file handles, image buffers, renderers, and controllers.

## Existing frontend structure

- `src/App.jsx`: dashboard, sidebar/header, in-memory page selection, and top-level merge/QR state.
- `src/components/tools/`: individual tool screens and shared `ToolPageFrame`.
- `src/hooks/usePdfMerge.js`: PDF selection, duplicate filtering, ordering, merge operation, progress, and output download.
- `src/hooks/useQrGenerator.js`: QR payload construction, individual/batch generation, export, and reset behavior.
- `src/main.jsx`: React entry point.
- `src/index.css`, `tailwind.config.js`: Tailwind setup and base theme.

## Dependencies used by the current browser app

The implementation uses React and Vite for the UI/build, Tailwind CSS for styling, `pdf-lib` for PDF creation/merging, PDF.js for PDF rendering, `qrcode` for QR generation, `jszip` for ZIP output, ZXing for image scanning, `jsbarcode` for barcode SVG generation, and Lucide icons. The Flutter app should reproduce capabilities and output behavior rather than reuse these JavaScript libraries.
