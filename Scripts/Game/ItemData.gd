class_name ItemData extends Resource

enum CatColor{ WARM, COOL, NEUTRAL }

enum CatShape{ ORGANIC, GEOMETRIC }

enum CatMaterial{ WOOD, FABRIC, PLASTIC, METAL }

@export var name: String

@export var icon: Texture

@export var description: String

@export var color: CatColor

@export var shape: CatShape

@export var material: CatMaterial