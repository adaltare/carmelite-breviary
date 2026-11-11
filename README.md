# Carmelite Breviary

## Sunday Matins and Lauds (MVP)

**Todo:**

- [x] Create a format that AI can generate easily
- [ ] Insert corections from typeset version
- [ ] Code Levinstien distance calculator
- [x] Install SurrealDB
- [ ] Build an interface for viewing changes
- [ ] Write docs / style guide
- [ ] Read and understand the whole style file that Claude generated
- [ ] Hone in on the exact fonts\
Confimred that Plantin is the base font
- [ ] Research better diffing algorithms

**Initial Promt Sent To Claude:**

_Your mission is to retypeset an old breviary scan using the Typst document engine. The reproduction needs to be a pixel perfect match of the original. At the same time we are creating a reusable library of composable blocks that commonly occur in this breviary to aid us in retypesetting more of it in the future. You are designing a core system of how to break the formatting into meaningful chunks that can be recombined into complex patterns. Each chunk or block your design should be extracted into a typst function and placed into the mvp/templates/1938.typ file. Most everything should be built up using these blocks. See /templates/1938.typ (root folder of project) for inspiration, but do not copy it too closely. Use EB Garamond as the main text of the document, with Cloister for fancy headings. Let me know if you find a closer match to the original. The text for the document is labeled mvp/llamaparse_ocr.md , use it, do not re-ocr the images. You may however reference the images of the original document to match the styling. They are located in mvp/raw. Is all of this clear? Please ask me plenty of questions as they arise._

## Inserts for 1938 reprint

### Office of Our Lady of Guadalupe

- [x] Extract the header image from the common of Our Lady \[161\]
- [ ] Align the crop marks to the orginal marks
- [ ] Extract the Versicle and Response marks into a custom font
- [ ] Match the asterisks to the original
- [ ] Align the page breaks to match the 1938 reprint
- [ ] Balanced the columns at the end of the office
- [ ] Add a stylized motif line at the end of the office
- [ ] Extract the original decorative inital lombaric capitals into a custom font
- [ ] Experiment with stack based fractional spacing

## Tooling

- [ ] Allow draging in the viewer to change the offsets
- [x] Setup Git LFS
