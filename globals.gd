extends Node

const font_dir = "res://fonts/Cloude_Regular_Bold_1.02.ttf"
const english_color = Color("#fae26d")
const math_color = Color("#428dfe")
const history_color = Color("#ff5c89")
const science_color = Color("#80fc6f")
const relax_color = Color("#eba5fb")

# volatile (resets on reopen)
var difficulty = "hard"
var minigame_score = 0
var minigame = null
var minigame_color = null
var savefile_read = false

# non-volatile
var happiness = 20
var english_preparedness = 20
var english_score = [null, 0]  # in the form [average, number of assignments]
var math_preparedness = 20
var math_score = [null, 0]
var science_preparedness = 20
var science_score = [null, 0]
var history_preparedness = 20
var history_score = [null, 0]
var day = 0


