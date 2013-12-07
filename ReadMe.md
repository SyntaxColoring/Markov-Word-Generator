
Why?
====
1. [CoffeeScript](https://github.com/jashkenas/coffee-script) is cool.
2. [Twitter Bootstrap](https://github.com/twbs/bootstrap) is cool.
3. [Markov chains](http://en.wikipedia.org/wiki/Markov_chain) are cool.

There are plenty of sites that use Markov chains to semi-legible *paragraphs*, but not a whole lot that use them to generate semi-legible *words.*

Markov.coffee
=============
Markov.coffee is a small CoffeeScript module for creating and using Markov chains.
It was created for this project, but it's generic enough for you to use for your
purposes, too.  Documentation comments are in the source.

Markov.coffee-specific terminology
----------------------------------
- **element:** In Markov.coffee, an "element" is a basic, indivisible building block of the
material that we are working with.  For example, if the end goal is to generate
random sentences, then the elements are the individual words.
- **sequence:** A "sequence" is simply a list of elements.  Markov.coffee can accept sequences
both as arrays and as strings.  (If you pass a string as a sequence, then the
individual characters are the elements.)

