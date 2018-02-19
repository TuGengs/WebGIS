/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/*
 * 绘制箭头线
 * 需要三个控制点p1、p2、p3
 */
function createArrowPoints(p1,p2,p3){
    var arrLine = new Array();
    var xp1=p1[0];
    var xp2=p2[0];
    var xp4=p3[0];
    var yp1=p1[1];
    var yp2=p2[1];
    var yp4=p3[1];
    
    var l = Math.sqrt(((xp1/2 + xp2/2 - xp4)*(xp1/2 + xp2/2 - xp4) + (yp1/2 + yp2/2 - yp4)*(yp1/2 + yp2/2 - yp4)));
    
    var k=3.3333;
    var angle = 20;
    var m=Math.tan(angle*Math.PI/180);
    var xp12 = (xp1+xp2)/2;
    var yp12 = (yp1+yp2)/2;
    var xp3 = (xp4 - 1.0*xp12 + xp12*k)/k;
    var yp3 = (yp4 - 1.0*yp12 + yp12*k)/k;
    var a=(yp1/2 + yp2/2 - yp4)/(xp1/2 + xp2/2 - xp4);
    var a1 = (a - m)/(a*m + 1);
    var b1 = (yp4 - xp4*a + xp4*m + yp4*a*m)/(a*m + 1);
    var a2 = -(a + m)/(a*m - 1);
    var b2 = (xp4*a - yp4 + xp4*m + yp4*a*m)/(a*m - 1);
    var n = Math.tan(angle*Math.PI/360);
    var a3 = (a - n)/(a*n + 1);
    var b3 = (yp4 - xp4*a + xp4*n + yp4*a*n)/(a*n + 1);
    var a4 = -(a + n)/(a*n - 1);
    var b4 = (xp4*a - yp4 + xp4*n + yp4*a*n)/(a*n - 1);
    var xpp3;
    var ypp3;
    var xpp4;
    var ypp4;
    var xpp5;
    var ypp5;
    var xpp6;
    var ypp6;
    if(xp4 > xp1){
        xpp3 = -(1.0*(b1 - (1.0*(2.0*b1 + 2.0*xp4*a1 + 2.0*yp4*a1*a1 - 1.0*a1*Math.sqrt(0.64*l*l*a1*a1 + 0.64*l*l - 4.0*xp4*xp4*a1*a1 + 8.0*xp4*yp4*a1 - 8.0*xp4*a1*b1 - 4.0*yp4*yp4 + 8.0*yp4*b1 - 4.0*b1*b1)))/(2.0*a1*a1 + 2.0)))/a1;
        ypp3 = (2.0*b1 + 2.0*xp4*a1 + 2.0*yp4*a1*a1 - 1.0*a1*Math.sqrt(0.64*l*l*a1*a1 + 0.64*l*l - 4.0*xp4*xp4*a1*a1 + 8.0*xp4*yp4*a1 - 8.0*xp4*a1*b1 - 4.0*yp4*yp4 + 8.0*yp4*b1 - 4.0*b1*b1))/(2.0*a1*a1 + 2.0);
        xpp4 = -(1.0*(b2 - (1.0*(2.0*b2 + 2.0*xp4*a2 + 2.0*yp4*a2*a2 - 1.0*a2*Math.sqrt(0.64*l*l*a2*a2 + 0.64*l*l - 4.0*xp4*xp4*a2*a2 + 8.0*xp4*yp4*a2 - 8.0*xp4*a2*b2 - 4.0*yp4*yp4 + 8.0*yp4*b2 - 4.0*b2*b2)))/(2.0*a2*a2 + 2.0)))/a2;
        ypp4 = (2.0*b2 + 2.0*xp4*a2 + 2.0*yp4*a2*a2 - 1.0*a2*Math.sqrt(0.64*l*l*a2*a2 + 0.64*l*l - 4.0*xp4*xp4*a2*a2 + 8.0*xp4*yp4*a2 - 8.0*xp4*a2*b2 - 4.0*yp4*yp4 + 8.0*yp4*b2 - 4.0*b2*b2))/(2.0*a2*a2 + 2.0);
        xpp5 = -(1.0*(b3 - (1.0*(2.0*b3 + 2.0*xp4*a3 + 2.0*yp4*a3*a3 - 1.0*a3*Math.sqrt(0.36*l*l*a3*a3 + 0.36*l*l - 4.0*xp4*xp4*a3*a3 + 8.0*xp4*yp4*a3 - 8.0*xp4*a3*b3 - 4.0*yp4*yp4 + 8.0*yp4*b3 - 4.0*b3*b3)))/(2.0*a3*a3 + 2.0)))/a3;
        ypp5 =  (2.0*b3 + 2.0*xp4*a3 + 2.0*yp4*a3*a3 - 1.0*a3*Math.sqrt(0.36*l*l*a3*a3 + 0.36*l*l - 4.0*xp4*xp4*a3*a3 + 8.0*xp4*yp4*a3 - 8.0*xp4*a3*b3 - 4.0*yp4*yp4 + 8.0*yp4*b3 - 4.0*b3*b3))/(2.0*a3*a3 + 2.0);
        xpp6 = -(1.0*(b4 - (1.0*(2.0*b4 + 2.0*xp4*a4 + 2.0*yp4*a4*a4 - a4*Math.sqrt(0.36*l*l*a4*a4 + 0.36*l*l - 4.0*xp4*xp4*a4*a4 + 8.0*xp4*yp4*a4 - 8.0*xp4*a4*b4 - 4.0*yp4*yp4 + 8.0*yp4*b4 - 4.0*b4*b4)))/(2.0*a4*a4 + 2.0)))/a4;
        ypp6 = (2.0*b4 + 2.0*xp4*a4 + 2.0*yp4*a4*a4 - 1.0*a4*Math.sqrt(0.36*l*l*a4*a4 + 0.36*l*l - 4.0*xp4*xp4*a4*a4 + 8.0*xp4*yp4*a4 - 8.0*xp4*a4*b4 - 4.0*yp4*yp4 + 8.0*yp4*b4 - 4.0*b4*b4))/(2.0*a4*a4 + 2.0)
    } else{
        xpp4 = -(1.0*(b1 - (1.0*(2.0*b1 + 2.0*xp4*a1 + 2.0*yp4*a1*a1 + a1*Math.sqrt(0.64*l*l*a1*a1 + 0.64*l*l - 4.0*xp4*xp4*a1*a1 + 8.0*xp4*yp4*a1 - 8.0*xp4*a1*b1 - 4.0*yp4*yp4 + 8.0*yp4*b1 - 4.0*b1*b1)))/(2.0*a1*a1 + 2.0)))/a1;
        ypp4 = (2.0*b1 + 2.0*xp4*a1 + 2.0*yp4*a1*a1 + a1*Math.sqrt(0.64*l*l*a1*a1 + 0.64*l*l - 4.0*xp4*xp4*a1*a1 + 8.0*xp4*yp4*a1 - 8.0*xp4*a1*b1 - 4.0*yp4*yp4 + 8.0*yp4*b1 - 4.0*b1*b1))/(2.0*a1*a1 + 2.0);
        xpp3 = -(1.0*(b2 - (1.0*(2.0*b2 + 2.0*xp4*a2 + 2.0*yp4*a2*a2 + a2*Math.sqrt(0.64*l*l*a2*a2 + 0.64*l*l - 4.0*xp4*xp4*a2*a2 + 8.0*xp4*yp4*a2 - 8.0*xp4*a2*b2 - 4.0*yp4*yp4 + 8.0*yp4*b2 - 4.0*b2*b2)))/(2.0*a2*a2 + 2.0)))/a2;
        ypp3 = (2.0*b2 + 2.0*xp4*a2 + 2.0*yp4*a2*a2 + a2*Math.sqrt(0.64*l*l*a2*a2 + 0.64*l*l - 4.0*xp4*xp4*a2*a2 + 8.0*xp4*yp4*a2 - 8.0*xp4*a2*b2 - 4.0*yp4*yp4 + 8.0*yp4*b2 - 4.0*b2*b2))/(2.0*a2*a2 + 2.0);
        xpp6 = -(1.0*(b3 - (1.0*(2.0*b3 + 2.0*xp4*a3 + 2.0*yp4*a3*a3 + a3*Math.sqrt(0.36*l*l*a3*a3 + 0.36*l*l - 4.0*xp4*xp4*a3*a3 + 8.0*xp4*yp4*a3 - 8.0*xp4*a3*b3 - 4.0*yp4*yp4 + 8.0*yp4*b3 - 4.0*b3*b3)))/(2.0*a3*a3 + 2.0)))/a3;
        ypp6 = (2.0*b3 + 2.0*xp4*a3 + 2.0*yp4*a3*a3 + a3*Math.sqrt(0.36*l*l*a3*a3 + 0.36*l*l - 4.0*xp4*xp4*a3*a3 + 8.0*xp4*yp4*a3 - 8.0*xp4*a3*b3 - 4.0*yp4*yp4 + 8.0*yp4*b3 - 4.0*b3*b3))/(2.0*a3*a3 + 2.0);
        xpp5 = -(1.0*(b4 - (1.0*(2.0*b4 + 2.0*xp4*a4 + 2.0*yp4*a4*a4 + a4*Math.sqrt(0.36*l*l*a4*a4 + 0.36*l*l - 4.0*xp4*xp4*a4*a4 + 8.0*xp4*yp4*a4 - 8.0*xp4*a4*b4 - 4.0*yp4*yp4 + 8.0*yp4*b4 - 4.0*b4*b4)))/(2.0*a4*a4 + 2.0)))/a4;
        ypp5 = (2.0*b4 + 2.0*xp4*a4 + 2.0*yp4*a4*a4 + a4*Math.sqrt(0.36*l*l*a4*a4 + 0.36*l*l - 4.0*xp4*xp4*a4*a4 + 8.0*xp4*yp4*a4 - 8.0*xp4*a4*b4 - 4.0*yp4*yp4 + 8.0*yp4*b4 - 4.0*b4*b4))/(2.0*a4*a4 + 2.0);
    }
    var x=0;
    var y=0;
    var t=0;
    var j=0;
    for(var i=0;i<=50;i++){
        t=i/50;
        x=(1-t)*(1-t)*xp1+2*t*(1-t)*xp3+t*t*xpp5;
        y=(1-t)*(1-t)*yp1+2*t*(1-t)*yp3+t*t*ypp5;
        arrLine[j++] = [x,y];
    }
    
    arrLine[j++] = [xpp3,ypp3];
    arrLine[j++] = [xp4,yp4];
    arrLine[j++] = [xpp4,ypp4];
    arrLine[j++] = [xpp6,ypp6];
    
    for(var i=0;i<=50;i++){
        t=i/50;
        x=(1-t)*(1-t)*xpp6+2*t*(1-t)*xp3+t*t*xp2;
        y=(1-t)*(1-t)*ypp6+2*t*(1-t)*yp3+t*t*yp2;
        arrLine[j++] = [x,y];
    }
    
    return arrLine;
}
