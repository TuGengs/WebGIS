/**
 * Currently drawn feature of polygon.
 */


/**
 * create a style for Point, include image and text properities.
 * @param color {string}
 * @param width {number}
 * @return {ol.style.Style}
 */
function createPolygonStyle(strokecolor, strokewidth, fillcolor) {
    return new ol.style.Style({
        stroke: new ol.style.Stroke(({
            color: strokecolor,  //颜色
            width: strokewidth  //宽度
        })),
        fill: new ol.style.Fill({
            color: fillcolor   //like 'rgba(0, 255, 0, 0.2)'
        })
    });
}

/**
 * create a Polygon.
 * @param lid {String}
 * @param lx {string}
 * @param arrCoordinate {Array.<ol.Coordinate>}
 * @param iconStyle {ol.style.Style}
 * @return {ol.Feature}
 */
function createPolygon(lid, lx, arrCoordinate, style){
    var f = new ol.Feature({
        geometry: new ol.geom.Polygon(arrCoordinate),
        id: lid,           //多边形的唯一标识
        lx: lx            //类型，区别于其它Features
    }); 
    f.setId(lid);  //不能删除
    f.setStyle(style);
    return f;
}

/**
 * create a Circle.
 * @param lid {String}
 * @param lx {string}
 * @param arrCoordinate {Array.<ol.Coordinate>}
 * @param iconStyle {ol.style.Style}
 * @return {ol.Feature}
 */
function createCircle(lid, lx, center, radius, style){
    var f = new ol.Feature({
        geometry: new ol.geom.Circle(center, radius),
        id: lid,           //多边形的唯一标识
        lx: lx            //类型，区别于其它Features
    }); 
    f.setId(lid);  //不能删除
    f.setStyle(style);
    return f;
}

//在图上标注保障区域
//需要三个点p1、p2、p3
function createRegionPoints(p1, p2, p3){
    var arrPoints = [];
    var a1 = p1[0];
    var b1 = p1[1];
    var a2 = p2[0];
    var b2 = p2[1];
    var a3 = p3[0];
    var b3 = p3[1];
    var k1 = 0.3;
    var k2 = 0.3;
    var x=0;
    var y=0;
                
    var x01=a1 + a2*k1 - a3*k1;
    var y01=b1 + b2*k1 - b3*k1;                
    var x02 =a2 + a1*k1 - a3*k1;
    var y02 =b2 + b1*k1 - b3*k1;                
    for(var t=0;t<=1;t=t+0.02){
        x=(1-t)*(1-t)*(1-t)*a1+3*t*(1-t)*(1-t)*x01+3*t*t*(1-t)*x02+t*t*t*a2;
        y=(1-t)*(1-t)*(1-t)*b1+3*t*(1-t)*(1-t)*y01+3*t*t*(1-t)*y02+t*t*t*b2;
        arrPoints.push([x, y]);
    }
                
    var x03 = a2 - a1*k1 + a3*k1;
    var y03 = b2 - b1*k1 + b3*k1; 
    var x04 = a3 - a1*k1 + a2*k1;
    var y04 = b3 - b1*k1 + b2*k1;                
    for(var t=0;t<1;t=t+0.02){
        x=(1-t)*(1-t)*(1-t)*a2+3*t*(1-t)*(1-t)*x03+3*t*t*(1-t)*x04+t*t*t*a3;
        y=(1-t)*(1-t)*(1-t)*b2+3*t*(1-t)*(1-t)*y03+3*t*t*(1-t)*y04+t*t*t*b3;
        arrPoints.push([x, y]);
    }
                
    var x05 = a3 + a1*k1 - a2*k1;
    var y05 = b3 + b1*k1 - b2*k1;
    var x06 = a1/2 + a3/2 - a1*k2 + a3*k2;
    var y06 = b1/2 + b3/2 - b1*k2 + b3*k2;
    var x07 = (a1+a3)/2;
    var y07 = (b1+b3)/2;
    for(var t=0;t<1;t=t+0.02){
        x=(1-t)*(1-t)*(1-t)*a3+3*t*(1-t)*(1-t)*x05+3*t*t*(1-t)*x06+t*t*t*x07;
        y=(1-t)*(1-t)*(1-t)*b3+3*t*(1-t)*(1-t)*y05+3*t*t*(1-t)*y06+t*t*t*y07;
        arrPoints.push([x, y]);
    }
                
    var x08= a1/2 + a3/2 + a1*k2 - a3*k2;
    var y08= b1/2 + b3/2 + b1*k2 - b3*k2;
    var x09=  a1 - a2*k1 + a3*k1;
    var y09= b1 - b2*k1 + b3*k1;
    for(var t=0;t<1;t=t+0.02){
        x=(1-t)*(1-t)*(1-t)*x07+3*t*(1-t)*(1-t)*x08+3*t*t*(1-t)*x09+t*t*t*a1;
        y=(1-t)*(1-t)*(1-t)*y07+3*t*(1-t)*(1-t)*y08+3*t*t*(1-t)*y09+t*t*t*b1;
        arrPoints.push([x, y]);
    }
    arrPoints.push(arrPoints[0]);
    return arrPoints;
}