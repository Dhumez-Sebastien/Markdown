Markdown
========

This is an experimental Markdown processor.  It aims to process
Markdown efficiently and in the most forgiving possible way.
(It is about seven times faster than pandoc---about the same
as the C library peg-markdown---and uses a fifth the memory.)

There is no such thing as an invalid Markdown document. Any
string of characters is valid Markdown.  So the processor should
finish efficiently no matter what input it gets. Garbage in
should not cause an error or exponential slowdowns.  (All the
"error" statements in the code below are things that "should not
happen" on any input and indicate programming errors if they
are triggered.)

Extensions
----------

This processor adds the following Markdown extensions:

* All absolute URLs are automatically made into hyperlinks, where
  inside `<>` or not.

* Fenced code blocks with attributes are allowed.  These begin with
  a line of three or more backticks or tildes, followed by an
  optional language name and possibly other metadata.  They end
  with a line of backticks or tildes (the same character as started
  the code block) of at least the length of the starting line.

* A hard line break can be indicated with a backslash before a
  newline. The standard method of two spaces before a newline also
  works, but this gives a more "visible" alternative.

Revisions
---------

In departs from the markdown syntax document in the following ways:

* Underscores cannot be used for word-internal emphasis. This
  prevents common mistakes with filenames, usernames, and indentifiers.
  Asterisks can still be used if word in*ter*nal emphasis is needed.

* The starting number of an ordered list is now significant.
  Other numbers are ignored, so you can still use `1.` for each
  list item.

* In addition to the `1.` form, you can use `1)` or `(1)` in
  your ordered lists.  A new list starts if you change the
  form of the delimiter. So, the following is two lists:

      1. one
      2. two
      1) one
      2) two

* A new bullet lists starts if you change the bullet marker.
  So, the following is two consecutive bullet lists:

      + one
      + two
      - one
      - two

* A new list starts if you change from tight spacing to loose.
  So, the following is parsed as a tight list followed by a loose
  list:

      - one
      - two

      - one

      - two

* Two blank lines breaks out of a list.  This allows you to
  have consecutive lists:

      - one

      - two


      - one (new list)

* Block elements inside list items need not be indented four
  spaces.  If they are indented beyond the bullet or numerical
  list marker, they will be considered additional blocks inside
  the list item.  So, the following is a list item with two paragraphs:

      - one

       two

  This implies that code blocks inside list items must be indented
  five spaces past the first column after the bullet or numerical
  list marker.

* All symbols and punctuation marks can be backslash-escaped,
  not just those with a use in Markdown.

* A blank line is not required before a list.  Note that this
  does open risk of unexpected results, when a line begins with
  something like '88.'

It resolves the following issues left vague in the markdown syntaxx
document:

* HTML blocks may not contain blank lines.  (This is partly a
  concession to parsing efficiency, as it avoids expensive lookaheads
  when there is no closing tag.)

* A list is considered "tight" if (a) it has only one item or
  (b) there is no blank space between any two consecutive items.
  If a list is "tight," then list items consisting of a single
  paragraph or a paragraph followed by a sublist will be rendered
  without `<p>` tags.

* Sublists work like other block elements inside list items;
  they  must be indented past the bullet or numerical list marker
  (but no more than three spaces past, or they will be interpreted
  as indented code).

* ATX headers must have a space after the initial `###`s.

* A blank line will end a blockquote. So, the following is a single
  blockquote:

       > hi
       >
       > there

  But this is two blockquotes:

       > hi

       > there

* Blank lines are not required before horizontal rules, blockquotes,
  lists, code blocks, or headers.  They are not required after, either,
  though in many cases "laziness" will effectively require a blank
  line after.  For example, in

       Hello there.
       > A quote.
       Still a quote.

  the "Still a quote." is part of the block quote, because of laziness
  (the ability to leave off the > from the beginning of subsequent
  lines).  Laziness also affects lists. However, we can have a code
  block, ATX header, or horizontal rule between two paragraphs without any
  blank lines.

* Raw HTML blocks work a bit differently than in Markdown.pl.
  A raw HTML block starts with a block-level HTML tag (opening or
  closing), or a comment start `<!--` or end `-->`, and goes until
  the next blank line.  The whole block is included as raw HTML.
  No attempt is made to parse balanced tags.  This means that
  in the following, the asterisks are literal asterisks:

      <div>
      *hello*
      </div>

  while in the following, the asterisks are interpreted as markdown
  emphasis:

     <div>

     *hello*

     </div>

  In the first example, we have a single raw HTML block; in the second,
  we have two raw HTML blocks with an intervening paragraph.  This system
  provides flexibility to authors to use enclose markdown sections
  in html block-level tags if they wish, while also allowing them
  to include verbatim HTML blocks (taking care that the don't include
  any blank lines).

Installing
----------

To build, get the Haskell Platform, then:

    cabal update && cabal install

'make test' will run some tests.

License
-------

Copyright &copy; 2012--3 John MacFarlane.

The library is released under the BSD license; see LICENSE for terms.

Some of the test cases are borrowed from Michel Fortin's mdtest suite
and John Gruber's original markdown test suite.
