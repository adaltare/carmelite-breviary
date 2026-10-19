# Carmelite Breviary

## MVP

_Initial Promt Sent To Claude:_

> Your mission is to retypeset an old breviary scan using the Typst document engine. The reproduction needs to be a pixel perfect match of the original. At the same time we are creating a reusable library of composable blocks that commonly occur in this breviary to aid us in retypesetting more of it in the future. You are designing a core system of how to break the formatting into meaningful chunks that can be recombined into complex patterns. Each chunk or block your design should be extracted into a typst function and placed into the mvp/templates/1938.typ file. Most everything should be built up using these blocks. See /templates/1938.typ (root folder of project) for inspiration, but do not copy it too closely. Use EB Garamond as the main text of the document, with Cloister for fancy headings. Let me know if you find a closer match to the original. The text for the document is labeled mvp/llamaparse_ocr.md , use it, do not re-ocr the images. You may however reference the images of the original document to match the styling. They are located in mvp/raw​. Is all of this clear? Please ask me plenty of questions as they arise.
