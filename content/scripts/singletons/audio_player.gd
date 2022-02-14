extends Node

# song names, use them for play_song function
enum Songs {
	Hill = 0,
	NotExistingSong = 1
}
var _song_indexes = {
	"0": "hill"
}
#sfx names, use them for play_sfx function
enum Sfx {
	NonExistingSfx = 0
}
var _current_song_queue = [] #queue for what to play. Possible values could be: ["intro", "middle"], ["ending", "middle"] etc.

#let's make some noise ~Benjamin, BTD6
func play_song(song_idx:int, play_intro:bool=true, play_ending:bool=true) -> void:
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
		$music_intro.stream = load(_intro_file_path)
	if play_ending:
		_current_song_queue.append("ending")
		_ending_file_path = _random_file(Array(_song_data['song_endings']))
		$music_ending.stream = load(_ending_file_path)
	#start playing by queue, for now we only chceck if music was marked to play with intro or not and play intro if it is needed.
	if _current_song_queue.has("intro"):
		$music_intro.play()
	else:
		$music_middle.play()
# getting all information about song files
func _get_song_data(song_name:String) -> Dictionary:
	var _song_data = {}
	var _s = load("res://content/audio/%s/init.gd" % song_name).new()
	_song_data['song_intros'] = _s.song_intros
	_song_data['song_middle'] = _s.song_middle
	_song_data['song_endings'] = _s.song_endings
	_song_data['song_full'] = _s.song_full
	return _song_data

#randomize file for intros and endings
func _random_file(file_array:Array) -> String:
	randomize()
	var _file = file_array[randi() % file_array.size()]
	return _file

func _on_music_intro_finished() -> void:
	_current_song_queue.remove(_current_song_queue.find("intro")) #removing "intro"
	$music_middle.play() #everything was preloaded previously, so for now we only call play method


func _on_music_middle_finished() -> void:
	_current_song_queue.remove(_current_song_queue.find("middle")) #removing "intro"
	# for now we check if we have to play ending, if so, ending will be played
	if _current_song_queue.has("ending"):
		$music_ending.play()
	else:
		_current_song_queue = [] #clear the song queue


func _on_music_ending_finished() -> void:
	_current_song_queue = [] #clear the song queue
	$music_ending.stop() # just make sure ending won't loop

#if we want to play full song from full file
func play_full_song(song_idx:int) -> void:
	var song_name = _song_indexes[str(song_idx)]
	var _song_data = _get_song_data(song_name)
	var _full_song_file = _song_data['song_full']
	$music_full.stream = load(_full_song_file)
	$music_full.play()


func _on_music_full_finished() -> void:
	pass # Replace with function body.

func stop_song() -> void:
	pass

func stop_sfx() -> void:
	pass

func play_sfx(sfx_name:String) -> void:
	pass
