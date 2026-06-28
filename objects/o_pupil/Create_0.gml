function movePupil() {
    x = originX + owner.x;
    y = originY + owner.y;
    depth = owner.depth - 300;

    var target = noone;
    if (instance_exists(owner.tmpTarget) && owner.tmpTarget != noone) {
        target = owner.tmpTarget;
    } else if (instance_exists(owner.target) && owner.target != noone) {
        target = owner.target;
    }

    if (target != noone) {
        var dist = point_distance(owner.x, owner.y, target.x, target.y);
        var dir = point_direction(owner.x, owner.y, target.x, target.y);
        var offset = clamp(dist / owner.range, 0, 1) * 20;
        x += lengthdir_x(offset, dir);
        y += lengthdir_y(offset, dir);
    }
}