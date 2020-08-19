# Metadata

I adapted this [method for Markdown metadata](https://stackoverflow.com/a/50783136) in the following way:
In the beginning of a document, metadata is stored as link references.
References are not visibly rendered, so the metadata does not clutter the final document.

Metadata tags have the following syntax:

	[_metadata_:tag]: <content of tag>

The `<>` allow [including spaces in the content](https://github.github.com/gfm/#link-destination).
The `_metadata_:` prefix makes it easy to recognize and easy to filter.
