/**
 * Currently drawn feature of point.
 */


/**
 * create a style for Point, include image and text properities.
 * @param imgOpacity {double}
 * @param imgScale {double}
 * @param imgRotateWithView {boolean}
 * @param imgRotation {double}
 * @param imgSrc {string}
 * @param txtTextAlign {string}
 * @param txtBaseline {string}
 * @param txtFont {string}
 * @param txtText {string}
 * @param txtColor {string}
 * @return {ol.style.Style}
 */
function createStyle(imgOpacity,imgScale,imgRotateWithView,imgRotation,imgSrc,txtTextAlign,txtBaseline,txtFont,txtText,txtColor) {
    return new ol.style.Style({
        image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
            anchor: [16, 48],  //锚点
            anchorXUnits: 'pixels',  //锚点X单位
            anchorYUnits: 'pixels',  //锚点Y单位
            opacity: imgOpacity,  //透明度
            scale: imgScale,  //缩放比例
            rotateWithView: imgRotateWithView,  //是否跟随视图旋转
            rotation: imgRotation,  //旋转角度
            src: imgSrc  //图片地址
        })),
        text:new ol.style.Text({
            textAlign: txtTextAlign,  //水平位置： 'left', 'right', 'center', 'end' or 'start'
            textBaseline: txtBaseline,  //垂直位置： 'bottom', 'top', 'middle', 'alphabetic', 'hanging', 'ideographic'
            font: txtFont,  //字体格式：'weight size family'
            text: txtText,  //文字内容
            fill: new ol.style.Fill({
                color: txtColor
            }),  //填充设置
            stroke: new ol.style.Stroke({
                color: '#ffffff', 
                width: 2
            }) //边框设置
        })
    });
}

/**
 * create a Point.
 * @param pid {String}
 * @param lx {string}
 * @param lon {double}
 * @param lat {double}
 * @param iconStyle {ol.style.Style}
 * @return {ol.Feature}
 */
function createPoint(pid, lx, lon, lat, iconStyle){
    var f = new ol.Feature({
        geometry: new ol.geom.Point([lon,lat]),
        id: pid,           //点的唯一标识
        lx: lx,            //类型，区别于其它Features
        lon: lon,           //平面经度，ESPG:3857
        lat: lat           //平面纬度，ESPG:3857
    });
    f.setId(pid);  //不能删除
    f.setStyle(iconStyle);
    return f;
}