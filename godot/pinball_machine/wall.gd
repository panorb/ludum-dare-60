extends CollisionPolygon2D

func _ready() -> void:
	polygon = $Polygon2D.polygon
	$ExclusionZone/CollisionPolygon2D.polygon = $Polygon2D.polygon
