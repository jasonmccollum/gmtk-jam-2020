extends RichTextLabel


var Timer 

var sentence1 = "\n\nIt was a mistake"
var sentence2= "\n\nThe nauseating SPORES made her lose control of her own mind."
var sentence3="\n\nThe LIGHT made the spores uncomfortable."
var sentence4="\n\nBut only FIRE can keep the angry fungus and her MIND at bay."



var sentencearray =  [sentence1, sentence2,sentence3,sentence4]


#func _ready():
	#text += sentence1   # same as: text = text + text_to_add
signal timeout

const TIME_PERIOD = 1.5 # 500ms

var time = 0
var num=0

func _process(delta):
	time += delta

	if time > TIME_PERIOD && num < 4:
		text += sentencearray[num]
		# Reset timer
		num+=1
		time = 0
		
