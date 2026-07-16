// Step (behaviour + registration — no drawing happens here)
if (!noEyes)
{
    lPupil.movePupil();
    rPupil.movePupil();
    lEye.moveEye();
    rEye.moveEye();
    lEyeLid.moveEye();
    rEyeLid.moveEye();
}


draw_text(x,y,glow)
draw_text(x,y+20,redGlow)