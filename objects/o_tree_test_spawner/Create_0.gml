var start_x = x;
var start_y = y;
var spacing = 100;

for (var xx = 0; xx < 10; xx++)
{
    for (var yy = 0; yy < 10; yy++)
    {
        instance_create_layer(
            start_x + xx * spacing,
            start_y + yy * spacing,
            "Instances_1",
            o_tree1_4
        );
    }
}