Markov Word Generator
=====================
It's trivial for a computer program to generate random words.  The tricky part is creating
words that humans perceive as legible and pronounceable instead of
mangled and cryptic.  This web app solves the problem by applying a
[Markov chain](https://en.wikipedia.org/wiki/Markov_chain).

View the live site [here](http://SyntaxColoring.github.io/Markov-Word-Generator).

Why?
====
Because Markov chains are cool!

I originally wanted a program to help me generate science fiction names.
There were plenty of websites out there that used Markov chains to generate
random *paragraphs,* but I couldn't find any good ones to generate random *words.*

I probably got a little carried away with
[CoffeeScript](https://github.com/jashkenas/coffee-script) and
and [Bootstrap](https://github.com/twbs/bootstrap).

Contributions
=============
Please contribute.  I'm so lonely.

[Markov.coffee](Markov.coffee)
==============================
The back-end logic for managing the Markov chain is available as a standalone
CoffeeScript module.  It's flexible enough for you to use in your own project,
if you want to.  Like the rest of this project, it's distributed under the
permissive MIT license.

Below is a light introduction to the module.  For more detailed documentation,
see the documentation comments in the [source](Markov.coffee).

Markov.coffee-specific terminology
----------------------------------
- **element:** In Markov.coffee, an "element" is a basic, indivisible building block of the
material that we are working with.  For example, if the end goal is to generate
random sentences, then the individual words are the elements.
- **sequence:** A "sequence" is simply a list of elements.  Markov.coffee can accept sequences
both as arrays and as strings.  (If you pass a string as a sequence, then the
individual characters are the elements.)

Although not strictly necessary, some familiarity with
[Markov chains](https://en.wikipedia.org/wiki/Markov_chain) and
[n-grams](https://en.wikipedia.org/wiki/N-gram) is also helpful here.

Setup
-----
After including the script, `Markov` objects can be constructed like this:

    markov = new window.Markov ["sassafras", "mississippi"], 1
	
	# Or, on CommonJS:
	# markov = new Markov.Markov ["sassafras", "mississippi"], 1

The first parameter to the constructor is an array of sequences.  The sequences
are combined together to form the corpus.  The generator takes care not to link
elements across sequence boundaries.  In the example above, the last S in *sassafras*
is not associated with the M in *mississippi.*  If you really *do* want that to happen,
here's how to do it:

	markov = new window.Markov["sassafrasmississippi"], 1

The second parameter to the constructor is *n,* the *Markov order* - basically, how
many previous elements the next element depends on.  Low values make the Markov chain more random, while high values make it stick closer to the corpus.

If left unspecified, the array of sequences defaults to `[]` and the Markov order defaults to `2`.

You can directly modify these properties later in your code, if you need to.  They're not private variables.

	markov.sequences.push "foo"
	markov.n = 3

Generation
----------
Make the Markov chain do something useful with `.generate()`  Note that it returns
an array, so if you want a string you'll have to use `.join("")`.

	markov = new window.Markov ["sassafras", "mississippi"]
	alert markov.generate().join("") # Alerted "rassippi".
	alert markov.generate().join("") # Alerted "frassissafrassippi".

`.generate()` takes an optional maximum length parameter, e.g. `markov.generate(10)` to
limit generated words to 10 characters long.  If unspecified, it defaults to 20 elements.
There always needs to be a maximum length, because otherwise, things like this
could result in infinite loops:

	markov = new window.Markov ["abba"], 1
	alert markov.generate().join("") # "bbababbabbbbababababbbabababababbabbbbabbbabababab..."

Other Stuff
-----------
The `Markov` class supports other methods, too.  I won't describe them all in
detail here, but you can read about how they work in [the source](Markov.coffee)
if you're interested.

- `.ngrams()` gives you the raw list of [n-grams]( used to build the chain.
- `.tree()` gives you a probability tree representing the n-grams.
- `.continue(sequence)` gives you a single next element to continue `sequence`.
