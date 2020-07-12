extends RichTextLabel


var Timer 

var sentence1 = "\n\nDr. Nasrin Sinha had it all. And as the world's leading bioengineer, she were well on their way to a noble peace prize."
var sentence2= "\n\nHer accomplishment? Creating sentience in a rare lichen strain."
var sentence3="\n\nThe Board was coming to review the results. This was it. Her moment."
var sentence4="\n\n'Just a few more millimeters...' Nasrin thought, as she applied the growth hormone."


var sentencearray =  [sentence1, sentence2,sentence3,sentence4]


#func _ready():
	#text += sentence1   # same as: text = text + text_to_add
signal timeout

const TIME_PERIOD = 1.5 # 500ms

var time = 0
var num=0

func _process(delta):
	time += delta

	if time > TIME_PERIOD && num < 4 :
		text += sentencearray[num]
		# Reset timer
		num+=1
		time = 0
		

