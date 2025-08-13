
print("[Variables]")
// Variables explicitas
var numbah: Int = 4
var numbahDots: Double = 4.21
var yesnt: Bool = true
var oneL: Character = "Z"
var manyL: String = "Azrael"

// Variables implicitas
var startup = 13
var launchHeight = 1.82
var isGroundHit = false
var damage = [15, 10]
var moveName = "Stinger"

print("Type of 'startup': \(type(of: startup))")
print("Type of 'launchHeight': \(type(of: launchHeight))")
print("Type of 'isGroundHit': \(type(of: isGroundHit))")
print("Type of 'damage': \(type(of: damage))")
print("Type of 'moveName': \(type(of: moveName))")

print("/////////////////////////////////////////////")
print("[Constantes]")
// Constantes explicitas
let alwaysNumbah: Int = 44
let alwaysDots: Float = 1.24
let alwaysYesnt: Bool = false
let alwaysOneL: Character = "A"
let alwaysManyL: String = "Angel"

// Constantes implicitas
let recovery = 24
let distance = 4.55
let isTracking = true
let frameTotal = [13, 3, 24]
let state = "Jumping"

print("Type of 'recovery': \(type(of: recovery))")
print("Type of 'distance': \(type(of: distance))")
print("Type of 'isTracking': \(type(of: isTracking))")
print("Type of 'frameTotal': \(type(of: frameTotal))")
print("Type of 'state': \(type(of: state))")
