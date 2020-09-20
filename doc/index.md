# General Usage

* ⚙ opens the settings. Set the base folder for your wiki here.
* 📁 opens or creates a file. On opening an existing file, it will tell you the file already exists. This is a bug.
* Doubleclicking (or two-finger tapping on Android) on a Markdown document starts editing. Clicking anywhere outside the text stops editing.
* Documents are autosaved every few seconds. Ctrl-Z might or might not work, so make backups.
* ▶ starts searching for what you entered into the search bar. As does pressing enter with the search bar focused.
* 📑 creates a new container that itself can contain an editor or further containers. This allows nested tiling and tabbing layouts.
* ✖ saves and closes the current document or container.

Links to other documents can be created using either `[linkname](<./linkdestination.md>)` or `[linkname](<#linkdestination.md>)`.
For `.md` files, the extension can be omitted.
The `<>` around the destination are only necessary when the [destination contains spaces](https://github.github.com/gfm/#link-destination).

# Metadata

I adapted this [method for Markdown metadata](https://stackoverflow.com/a/50783136) in the following way:
In the beginning of a document, metadata is stored as link references.
References are not visibly rendered, so the metadata does not clutter the final document.

Metadata tags have the following syntax:

	[_metadata_:tag]: <content of tag>

The `<>` allow [including spaces in the content](https://github.github.com/gfm/#link-destination).
The `_metadata_:` prefix makes it easy to recognize and easy to filter.
