// CREATE EVENT
deck = [

    instance_create_layer(0, 0, "Cards", o_inferna_spawner),
    instance_create_layer(0, 0, "Cards", o_inferna_spawner),
    instance_create_layer(0, 0, "Cards", o_inferna_spawner),
    instance_create_layer(0, 0, "Cards", o_inferna_spawner),
    instance_create_layer(0, 0, "Cards", o_inferna_spawner),
    instance_create_layer(0, 0, "Cards", o_archer_spawner),
    instance_create_layer(0, 0, "Cards", o_archer_spawner),
    instance_create_layer(0, 0, "Cards", o_archer_spawner),
    instance_create_layer(0, 0, "Cards", o_archer_spawner),
    instance_create_layer(0, 0, "Cards", o_archer_spawner),
    instance_create_layer(0, 0, "Cards", o_archer_spawner),
    instance_create_layer(0, 0, "Cards", o_archer_spawner),
    instance_create_layer(0, 0, "Cards", o_cavalry_spawner),
    instance_create_layer(0, 0, "Cards", o_cavalry_spawner),
    instance_create_layer(0, 0, "Cards", o_cavalry_spawner),
    instance_create_layer(0, 0, "Cards", o_cavalry_spawner),
    instance_create_layer(0, 0, "Cards", o_cavalry_spawner),
    instance_create_layer(0, 0, "Cards", o_cavalry_spawner),
    instance_create_layer(0, 0, "Cards", o_cavalry_spawner),
];

discard = []

function deck_draw()
{
	shuffle_deck();
    if (array_length(deck) == 0) return;

    var card = array_pop(deck);
    card.visible = true;
	card.layer = layer_get_id("UILayer_1");

    array_push(hand, card);
    organize_hand();
}

function deck_return(card)
{
    var index = hand_index(card);

    if (index == -1) return;

    array_delete(hand, index, 1);
    array_push(deck, card.object_index);

    instance_destroy(card);

    array_shuffle(deck);

    organize_hand();
}

function organize_hand()
{
    var count = array_length(hand);
    if (count == 0) return;
    var spacing = 140;
    var newY = display_get_gui_height() - 120;
    var start = display_get_gui_width() * 0.5 - ((count - 1) * spacing * 0.5);

    for (var i = 0; i < count; i++)
    {
        hand[i].x = start + i * spacing;
        hand[i].y = newY;
		hand[i].image_xscale = 0.5;
		hand[i].image_yscale = 0.5;
    }
}

function shuffle_deck()
{
    var count = array_length(deck);

    for (var i = count - 1; i > 0; i--)
    {
        var j = irandom(i);

        var temp = deck[i];
        deck[i] = deck[j];
        deck[j] = temp;
    }
}

function hand_index(card)
{
    for (var i = 0; i < array_length(hand); i++)
    {
        if (hand[i].id == card.id)
            return i;
    }
    return -1;
}

function discard_card(card)
{
    var index = hand_index(card);

    if (index == -1){
		show_debug_message("nie znaleziono karty");
	 return;
	}

    array_delete(hand, index, 1);
    array_push(discard, card.object_index);

    instance_destroy(card);
	
	deck_draw();

    organize_hand();
}

function return_to_deck(card)
{
    var index = hand_index(card);

    if (index == -1) return;

    array_delete(hand, index, 1);
    array_push(deck, card.object_index);

    instance_destroy(card);

    array_shuffle(deck);

    organize_hand();
}

array_shuffle(deck);

hand = [];

repeat (3)
{
    deck_draw();
}


