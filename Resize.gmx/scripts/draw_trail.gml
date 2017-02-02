///draw_trail(length,width,color,sprite,slim,alpha)
//Ex. draw_trail(32,32,c_white,-1,1,1)
var Length,Width,Color,Sprite,Slim,Alpha,AlphaT,Texture,Dir,Min,Height;

//Preparing variables
Length = argument0; //How many previous coordinates will use the trail
Width = argument1; //How wide will the trail be
Color = argument2; //Which color will be used to tint the trail
Sprite = argument3; //Which sprite's texture must be used for the trail. Must have "Used for 3D" marked. -1 for no sprite 
Slim = argument4; //Whether the trail will slim down at the end
Alpha = argument5; //The alpha to draw the trail with (0-1), optional

ArrayTrailx[0] = x;
ArrayTraily[0] = y;
ArrayTrail2[0] = 0;
Height = array_length_1d(ArrayTrailx);

//Getting distance between current and past coordinates
if (Height > 1) ArrayTrail2[0] = point_distance(ArrayTrailx[0],ArrayTraily[0],ArrayTrailx[1],ArrayTraily[1]) + ArrayTrail2[1];
else ArrayTrail2[0] = 0;

//Setting the texture
if (Sprite >= 0) Texture = sprite_get_texture(Sprite,0);
else Texture = -1;
texture_set_repeat(1);

//Drawing the primitive
draw_primitive_begin_texture(pr_trianglestrip,Texture);
AlphaT = 1;
Dir = 0;
Min = min(Height - 1,Length);

for(var i = 0; i < Min; i++){
  if (ArrayTrailx[i] != ArrayTrailx[i+1] || ArrayTraily[i] != ArrayTraily[i+1])
    Dir = point_direction(ArrayTrailx[i],ArrayTraily[i],ArrayTrailx[i+1],ArrayTraily[i+1]);
  var Len = Width / 2 - ((i + 1) / Min * Width / 2) * Slim;
  var XX = lengthdir_x(Len,Dir + 90); 
  var YY = lengthdir_y(Len,Dir + 90);
  AlphaT = (Min - i) / (Min / 2) * Alpha;

    draw_vertex_texture_color(ArrayTrailx[i] + XX,ArrayTraily[i] + YY,ArrayTrail2[i] / Width,0,Color,AlphaT);
  draw_vertex_texture_color(ArrayTrailx[i] - XX,ArrayTraily[i] - YY,ArrayTrail2[i] / Width,1,Color,AlphaT);
}
draw_primitive_end();

//Replacing the coordinates positions within the array
Min = min(Height,Length);
for (var i = Min; i > 0; i--){
  ArrayTrailx[i] = ArrayTrailx[i - 1];
  ArrayTraily[i] = ArrayTraily[i - 1];
  ArrayTrail2[i] = ArrayTrail2[i - 1];
}
