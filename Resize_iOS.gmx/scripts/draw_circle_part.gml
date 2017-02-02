//draw_circle_part(x,y,radius,start,end,outline,number_of_iterations)

var xx,yy,rr,oo,ii;
xx = argument0; //x coordinate
yy = argument1; //y coordinate
rr = argument2; //radius
s1 = argument3 * pi / 180; //start angle in degrees
s2 = argument4 * pi / 180; //end angle in degrees
oo = argument5; //outline (should be 0 or 1)
ii = argument6; //number of iterations. The object will be more circular for the larger iterations

if ( !( is_real(xx) && is_real(yy) && is_real(rr) && is_real(oo) && is_real(ii) && is_real(s1) && is_real(s2)) )
return 0;

var angle, dangle, i;
angle = (s2 - s1) / ii;

if (oo == 0)
{
draw_primitive_begin(pr_trianglefan);
draw_vertex(xx,yy);
}
else
draw_primitive_begin(pr_linestrip);
for (i=0;i<=ii;i+=1)
{
draw_vertex(xx + rr * cos(angle * i + s1), yy - rr * sin(angle * i + s1));
}
draw_primitive_end();