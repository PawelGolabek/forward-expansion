
message = "";
chars_per_line = 40;
life_time = 180;

padding = 12;
line_spacing = 4;

text_lines = [];
text_line_count = 0;
life = life_time;


function message_set(_text, _chars, _time)
{
    message = _text;
    chars_per_line = _chars;
    life = _time;
	life_time = _time;
    text_lines = [];
    text_line_count = 0;

    var text_length = string_length(message);

    for (var i = 1; i <= text_length; i += chars_per_line)
    {
        var line_length = min(chars_per_line, text_length - i + 1);

        text_lines[text_line_count] =
            string_copy(message, i, line_length);

        text_line_count++;
    }
}