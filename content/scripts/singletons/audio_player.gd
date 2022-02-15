extends Node
# cache nodes
onready var music_ending = $music_ending
onready var music_full = $music_full
onready var music_middle = $music_middle
onready var music_intro = $music_intro
onready var sfx = $sfx
# song names, use them for play_song function
enum Songs {
	Hill = 0,
	NotExistingSong = 1
}
var _song_indexes = {
	"0": "hill"
}
var _sfx_indexes = {
	"0": "jump"
}
#sfx names, use them for play_sfx function
enum Sfx {
	NonExistingSfx = 0
}
var _current_song_queue = [] #queue for what to play. Possible values could be: ["intro", "middle"], ["ending", "middle"] etc.
var _middle_loop = true #describes if middle part should be looped infinite times, then you can use play_song_ending function
#let's make some noise ~Benjamin, BTD6
func play_song(song_idx:int, play_intro:bool=true, play_ending:bool=true, loop_middle:bool=true)-> void:
	_middle_loop = loop_middle
	var song_name = _song_indexes[str(song_idx)]
	var _intro_file_path = ""
	var _ending_file_path = ""
	var _middle_file_path = ""
	var _song_data = _get_song_data(song_name)
	_current_song_queue.append("middle")
	#middle will be used always, there is no option to disable that
	if play_intro:
		_current_song_queue.append("intro")
		_intro_file_path = _random_file(Array(_song_data['song_intros']))
		music_intro.stream = load(_intro_file_path)
	if play_ending:
		_current_song_queue.append("ending")
		_ending_file_path = _random_file(Array(_song_data['song_endings']))
		music_ending.stream = load(_ending_file_path)
	_middle_file_path = _get_song_data(song_name)['song_middle']
	music_middle.stream = load(_random_file(Array(_middle_file_path)))
	
	#start playing by queue, for now we only chceck if music was marked to play with intro or not and play intro if it is needed.
	if _current_song_queue.has("intro"):
		music_intro.play()
	else:
		music_middle.play()
# getting all information about song files and sfx
func _get_song_data(song_name:String) -> Dictionary:
	var _song_data = {}
	var _s = load("res://content/audio/%s/init.gd" % song_name).new()
	_song_data['song_intros'] = _s.song_intros
	_song_data['song_middle'] = _s.song_middle
	_song_data['song_endings'] = _s.song_endings
	_song_data['song_full'] = _s.song_full
	return _song_data

func _get_sfx_data(song_name:String) -> Dictionary:
	var _sfx_data = {}
	var _s = load("res://content/audio/%s/init.gd" % song_name).new()
	_sfx_data['sfx_file'] = _s.sfx_file
	return _sfx_data
#randomize file for intros and endings
func _random_file(file_array:Array) -> String:
	randomize()
	var _file = file_array[randi() % file_array.size()]
	return _file

func _on_music_intro_finished() -> void:
	print("Intro finished")
	_current_song_queue.remove(_current_song_queue.find("intro")) #removing "intro"
	music_intro.stop()
	music_middle.play() #everything was preloaded previously, so for now we only call play method


func _on_music_middle_finished() -> void:
	if _middle_loop:
		music_middle.play()
	else:
		_current_song_queue.remove(_current_song_queue.find("middle")) #removing "intro"
		# for now we check if we have to play ending, if so, ending will be played
		if _current_song_queue.has("ending"):
			music_ending.play()
		else:
			_current_song_queue = [] #clear the song queue


func _on_music_ending_finished() -> void:
	_current_song_queue = [] #clear the song queue
	music_ending.stop() # just make sure ending won't loop

#if we want to play full song from full file
func play_full_song(song_idx:int) -> void:
	var song_name = _song_indexes[str(song_idx)]
	var _song_data = _get_song_data(song_name)
	var _full_song_file = _random_file(Array(_song_data['song_full']))
	music_full.stream = load(_full_song_file)
	var _ending_file_path = _random_file(Array(_song_data['song_endings']))
	music_ending.stream = load(_ending_file_path)
	music_full.play()


func _on_music_full_finished() -> void:
	pass # Replace with function body.

func stop_song() -> void:
	music_middle.stop()
	music_intro.stop()
	music_ending.stop()
	music_full.stop()

func pause_song(paused:bool=true) -> void:
	music_middle.stream_paused = paused
	music_intro.stream_paused = paused
	music_ending.stream_paused = paused
	music_full.stream_paused = paused

func stop_sfx() -> void:
	sfx.stop()

func pause_sfx(paused:bool=true) -> void:
	sfx.stream_paused = paused
func play_sfx(sfx_idx:int) -> void:
	var sfx_name = _sfx_indexes[str(sfx_idx)]
	var _sfx_data = _get_sfx_data(sfx_name)
	sfx.stream = load(_random_file(_sfx_data['sfx_file']))
	sfx.play()
#forces to play song ending
func play_song_ending() -> void:
	music_full.stop()
	_on_music_middle_finished()


func _on_sfx_finished():
	pass # Replace with function body.
