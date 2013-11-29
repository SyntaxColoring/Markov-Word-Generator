### Corpus Presets: ###
		
# For conciseness, the corpus presets are defined as a flat array
# containing name/content pairs.  The last element is always treated as
# the "custom" user-input corpus.
corpora = [
	"Astronomy"
	"Sun mercury venus earth mars jupiter saturn uranus neptune pluto sun ceres pallas vesta hygiea interamnia europa davida sylvia cybele eunomia juno euphrosyne hektor thisbe bamberga patientia herculina doris ursula camilla eugenia iris amphitrite"
	
	"Shakespeare"
	"Two households, both alike in dignity,\nIn fair Verona, where we lay our scene,\nFrom ancient grudge break to new mutiny,\nWhere civil blood makes civil hands unclean.\nFrom forth the fatal loins of these two foes\nA pair of star-cross'd lovers take their life;\nWhose misadventured piteous overthrows\nDo with their death bury their parents' strife.\nThe fearful passage of their death-mark'd love,\nAnd the continuance of their parents' rage,\nWhich, but their children's end, nought could remove,\nIs now the two hours' traffic of our stage;\nThe which if you with patient ears attend,\nWhat here shall miss, our toil shall strive to mend."
	
	"Lorem ipsum"
	"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec tristique a massa in feugiat. Donec rhoncus ante at lectus sollicitudin fermentum. Donec non massa arcu. Vestibulum sodales eros quis lacus cursus, egestas varius felis tincidunt. Donec pulvinar erat risus. Sed eu odio sit amet velit accumsan gravida. Ut eu tempor justo, in dignissim elit. Nam sollicitudin, sapien id tincidunt bibendum, purus elit feugiat mauris, vitae congue nibh massa ac ligula. Vestibulum auctor ultricies nunc non fermentum. Ut ultrices, magna et interdum varius, elit nisi dignissim augue, nec rutrum erat tortor eu nisl. In sed convallis sapien. Morbi adipiscing erat sed imperdiet feugiat. Ut ac interdum justo. Vestibulum in mauris in nulla viverra consequat. Nullam ultricies malesuada nulla, eu sollicitudin purus scelerisque bibendum."
	
	"Wikipedia"
	'A Markov chain (discrete-time Markov chain or DTMC) named after Andrey Markov, is a mathematical system that undergoes transitions from one state to another, among a finite or countable number of possible states. It is a random process usually characterized as memoryless: the next state depends only on the current state and not on the sequence of events that preceded it. This specific kind of "memorylessness" is called the Markov property. Markov chains have many applications as statistical models of real-world processes.'
	
	"(Custom)"
	""
]

# This flat array is an annoying format to work with later on, though,
# so it is "unflattened" here into an array of {name, content} objects.
# Note that although this could be avoided by defining the corpora as
# properties of a corpus object, doing it that way would lose their ordering.
corpora = ({ name: x, content: corpora[i+1] } for x, i in corpora by 2)


### Logic: ###

	# Returns an array of sequences (i.e. words) derived from a raw
	# input string.
sequences = (rawInput) ->
	rawInput.toLowerCase().replace(/[^a-z\s]/g, "").split(/\s/g)
	
	# Returns a flat array of all the n-grams in sequences.  N-grams do
	# not cross sequence boundaries.  For example:
	# ngrams 3, "abcde", "fghi" is ["abc", "bcd", "cde", "fgh", "ghi"]
ngrams = (n, sequences...) ->
	result = []
	for sequence in sequences when sequence.length >= n
		for i in [0..sequence.length-n]
			result.push sequence[i..i+n-1]
	result

	# Returns a probability tree derived from the supplied n-grams.
model = (ngrams...) ->
	root = { children: {}, count: ngrams.length}
	for ngram in ngrams
		base = root
		for element in ngram
			if not base.children[element]?
				# If we need to create a new node, do so.
				base.children[element] = { children: {}, count: 0 }
			base = base.children[element]
			base.count++
	
		# Recursively adds a "frequency" property to all children.
	normalize = (parent) ->
		hasChildren = false
		for childName, child of parent.children
				hasChildren = true
				child.frequency = child.count / parent.count
				normalize child
		parent.children = null unless hasChildren
	
	normalize root
	
	root

# Generates a pseudorandom sequence (word) using the given model.
generate = (maxLength, model, n=3) ->
	console.log "The generate() function was passed this model:"
	console.log model
	randomChildName = (parent) ->
		target = Math.random()
		sum = 0.0
		for childName, child of parent.children
			sum += child.frequency
			if sum >= target then return childName
	
	getParent = (history) ->
		parent = model
		for element in history
			if parent.children[element]
				parent = parent.children[element]
			else
				return null
		parent
	
	parent = model
	result = ""
	
	until result.length >= maxLength or parent is null
		result += randomChildName parent
		parent = getParent result[Math.max(0, result.length-n+1)..result.length-1]
	
	result
	
### UI and Initialization: ###

$ ->
	$word = $("#word")
	$button = $("#button")
	$corpusName = $("#corpusName")
	$corpora = $("#corpora")
	$corpusInput = $("#corpusInput")

	selectCorpus = (index) ->
		$corpusName.text(corpora[index].name)
		$corpusInput.val(corpora[index].content)
		calculatedSequences = sequences corpora[index].content
		calculatedNgrams = ngrams 3, calculatedSequences...
		calculatedModel = model calculatedNgrams...
		console.log "Calculated new model:"
		console.log calculatedModel
		$button.unbind("click").click ->
			$word.text(generate 8, calculatedModel)

	selectCorpus 0

	# Populate the dropdown list of presets.
	for corpus, index in corpora
		do (corpus, index) ->
			if index is corpora.length - 1
				$corpora.append('<li class = "divider">')
			newLink = $("<a>#{corpus.name}</a>")
			newLink.click(-> selectCorpus index)
			$("<li>").append(newLink).appendTo($corpora)

	# If the user types in the <textarea>, copy the updates into the custom
	# corpus and select that as the active corpus.
	$corpusInput.on "input propertychange", ->
		text = $corpusInput.val();
		corpora[corpora.length-1].content = $corpusInput.val();
		selectCorpus corpora.length-1;
