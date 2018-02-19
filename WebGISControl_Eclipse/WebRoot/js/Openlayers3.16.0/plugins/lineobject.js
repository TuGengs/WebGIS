/**
 * Currently drawn feature of line.
 */


/**
 * create a style for Point, include image and text properities.
 * @param color {string}
 * @param width {number}
 * @param linecap {string}
 * @param linejoin {string}
 * @return {ol.style.Style}
 */
function createLineStyle(color, width, linecap, linejoin) {
    return new ol.style.Style({
        stroke: new ol.style.Stroke(({
            color: color,  //颜色
            width: width,  //宽度
            lineCap: linecap,  //Line cap style: butt, round, or square. Default is round.
            lineJoin: linejoin  //Line join style: bevel, round, or miter. Default is round.
        }))
    });
}

/**
 * create a Point.
 * @param lid {String}
 * @param lx {string}
 * @param arrCoordinate {Array.<ol.Coordinate>}
 * @param iconStyle {ol.style.Style}
 * @return {ol.Feature}
 */
function createLine(lid, lx, arrCoordinate, style){
    var f = new ol.Feature({
        geometry: new ol.geom.LineString(arrCoordinate),
        id: lid,           //线的唯一标识
        lx: lx            //类型，区别于其它Features
    }); 
    f.setId(lid);  //不能删除
    f.setStyle(style);
    return f;
}