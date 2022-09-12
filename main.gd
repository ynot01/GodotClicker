extends Control

var amt = Big.new(0)
var clickpwr = Big.new(1)
var autoclickrate = Big.new(0)

func _ready():
	amt.setPostfixSeparator(" ")
	amt.setDecimalSeparator(".")
	clickpwr.setPostfixSeparator(" ")
	clickpwr.setDecimalSeparator(".")
	autoclickrate.setPostfixSeparator(" ")
	autoclickrate.setDecimalSeparator(".")

func _on_godot_pressed():
	$Godot/GodotAnim.stop(true)
	$Godot/GodotAnim.play("Clicked")
	add()

func add() -> void:
	amt.plus(clickpwr)

func _process(delta):
	$Amount.text = amt.toAmericanName()
	$ClickPwr.text = "Points per click: " + clickpwr.toAmericanName()
	$Autorate.text = "Clicks per second: " + autoclickrate.toAmericanName()
	var str_rate = autoclickrate.toString()
	var temp_rate = Big.new(get_mantissa_from_string(str_rate), get_exponent_from_string(str_rate))
	amt.plus(temp_rate.multiply(delta).multiply(clickpwr))

func _on_up_click_pressed():
	var stri = strip_non_nums($UpClick/Mult.text)
	if stri == "": return
	var big_num = Big.new(get_mantissa_from_string(stri), get_exponent_from_string(stri)).multiply(10)
	if amt.isLargerThanOrEqualTo(big_num):
		amt.minus(big_num)
		clickpwr.plus(Big.new(big_num).divide(10).multiply(0.5))

func _on_up_auto_pressed():
	var stri = strip_non_nums($UpClick/UpAuto/Mult.text)
	if stri == "": return
	var big_num = Big.new(get_mantissa_from_string(stri), get_exponent_from_string(stri)).multiply(10)
	if amt.isLargerThanOrEqualTo(big_num):
		amt.minus(big_num)
		autoclickrate.plus(Big.new(big_num).divide(10).multiply(0.1))

func strip_non_nums(stri : String) -> String:
	var regex = RegEx.new()
	regex.compile("(\\d)+")
	var matches = regex.search_all(stri)
	var return_string : String = ""
	for result in matches:
		return_string += result.get_string()
	return return_string

func get_mantissa_from_string(in_str : String) -> float:
	var stri = in_str.left(7)
	return stri.to_float() / pow(10.0, stri.length()-1)

func get_exponent_from_string(in_str : String) -> int:
	return in_str.length()-1
