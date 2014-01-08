### Corpus Presets: ###
		
# For conciseness, the corpus presets are defined as a flat array
# containing name/content pairs.  The last element is always treated as
# the "custom" user-input corpus.
corpora = [
	"Astronomy"
	"Sun Mercury Venus Earth Mars Jupiter Saturn Uranus Neptune Pluto Ceres Pallas Vesta Hygiea Interamnia Europa Davida Sylvia Cybele Eunomia Juno Euphrosyne Hektor Thisbe Bamberga Patientia Herculina Doris Ursula Camilla Eugenia Iris Amphitrite"
	
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


### UI And Initialization: ###
$ ->
	$word = $("#word")
	$button = $("#button")
	$corpusName = $("#corpusName")
	$corpora = $("#corpora")
	$corpusInput = $("#corpusInput")
	$order = $("#order")
	$maxLength = $("#maxLength")
	
	parseWords = (rawInput) ->
		rawInput.toLowerCase().replace(/[^a-z\s]/g, "").split(/\s/g)
	
	capitalize = (string) ->
		if string.length > 0 then string[0].toUpperCase() + string.slice(1)
		else ""
	
	selectCorpus = (index) ->
		$corpusName.text(corpora[index].name)
		$corpusInput.val(corpora[index].content)
		markovChain.sequences = parseWords corpora[index].content
	
	populatePresetDropdown = ->
		for corpus, index in corpora
			do (corpus, index) ->
				if index is corpora.length - 1
					$corpora.append('<li class = "divider">')
				newLink = $("<a href = \"#\">#{corpus.name}</a>")
				newLink.click((event) -> event.preventDefault(); selectCorpus index)
				$("<li>").append(newLink).appendTo($corpora)
	
	generateAndShow = ->
		$word.text capitalize markovChain.generate().join("")
	
	# If the user types in the <textarea>, copy the updates into the custom
	# corpus and select that as the active corpus.
	$corpusInput.on "input propertychange", ->
		text = $corpusInput.val();
		corpora[corpora.length-1].content = $corpusInput.val();
		selectCorpus corpora.length-1;
	
	$order.change ->
		markovChain.n = +@value
		@value = markovChain.n
	
	$maxLength.change ->
		markovChain.maxLength = Math.max +@value , 1
		@value = markovChain.maxLength
	
	$button.click generateAndShow
	
	markovChain = new Markov
	populatePresetDropdown();
	selectCorpus 0
	$order.change()
	$maxLength.change()
	generateAndShow()
