function movePupil() {
    x = originX + owner.x;
    y = originY + owner.y;
    depth = owner.depth - 6;

    var target = noone;
    if (instance_exists(unit.tmpTarget) && unit.tmpTarget != noone) {
        target = unit.tmpTarget;
    } else if (instance_exists(unit.target) && unit.target != noone) {
        target = unit.target;
    }

    if (target != noone) {
        var dist = point_distance(unit.x, unit.y, target.x, target.y);
        var dir = point_direction(unit.x, unit.y, target.x, target.y);
        var offset = clamp(dist / unit.range, 0, 1) * 14 * image_xscale;
        x += lengthdir_x(offset, dir);
        y += lengthdir_y(offset, dir);
    }
}