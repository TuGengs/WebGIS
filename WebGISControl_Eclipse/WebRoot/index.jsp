<%-- 
    Document   : index
    Created on : 2016-1-4, 10:48:16
    Author     : surface
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>WebGis二次开发包实例</title>

        <style>            
            .ol-zoom .ol-zoom-out {
                margin-top: 204px;
                z-index: 100;
                position: absolute;
            }
            .ol-zoomslider {
                background-color: transparent;
                top: 2.3em;
            }

            .ol-touch .ol-zoom .ol-zoom-out {
                margin-top: 212px;
            }
            .ol-touch .ol-zoomslider {
                top: 2.75em;
            }

            .ol-zoom-in.ol-has-tooltip:hover [role=tooltip],
            .ol-zoom-in.ol-has-tooltip:focus [role=tooltip] {
                top: 3px;
            }

            .ol-zoom-out.ol-has-tooltip:hover [role=tooltip],
            .ol-zoom-out.ol-has-tooltip:focus [role=tooltip] {
                top: 232px;
            }
        </style>

        <!--引入jquery框架-->
        <script type="text/javascript" src="js/jquery-easyui-1.4.2/jquery.min.js"></script>

        <!--引入easyui前端开发包-->
        <script type="text/javascript" src="js/jquery-easyui-1.4.2/jquery.easyui.min.js"></script>
        <script type='text/javascript' src='js/jquery-easyui-1.4.2/locale/easyui-lang-zh_CN.js'></script>
        <link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.4.2/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.4.2/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="js/jquery-easyui-1.4.2/themes/color.css">

        <!--引入Openlayers地理信息系统开发包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/ol.js"></script>
        <link rel="stylesheet" type="text/css" href="js/Openlayers3.16.0/ol.css">

        <!--引入地图列表扩展包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/maplist.js"></script>

        <!--引入测量控件扩展包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/measure.js"></script>
        <link rel="stylesheet" type="text/css" href="js/Openlayers3.16.0/plugins/measure.css">

        <!--引入点对象包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/pointobject.js"></script>

        <!--引入popup提示样式-->
        <link rel="stylesheet" type="text/css" href="js/Openlayers3.16.0/plugins/popup.css">

        <!--引入折线对象包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/lineobject.js"></script>

        <!--引入贝塞尔曲线包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/beziercurve.js"></script>

        <!--引入箭头线包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/arrowline.js"></script>

        <!--引入多边形包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/polygonobject.js"></script>
        
        <!--引入位置变换或拖动包-->
        <script type="text/javascript" src="js/Openlayers3.16.0/plugins/drag.js"></script>



        <script>
            /******************定义地图全局变量***************/
            var map;  //定义地图对象
            var proj = 'EPSG:4326';   //定义wgs84地图坐标系
            var proj_m = 'EPSG:3857';   //定义墨卡托地图坐标系
            var mapLayer, mapLayerlabel;  //定义图层对象
            var source_measure, vector_measure;  //定义全局测量控件源和层
            var source_point, vector_point;    //定义全局点对象源和层
            var popup;  //定义全局变量popup
            var source_zx, vector_zx;    //定义全局折线对象源和层
            var l;  //定义一根全局折线
            var source_bezier, vector_bezier;    //定义全局贝塞尔曲线对象源和层
            var source_arrow, vector_arrow;    //定义全局箭头线对象源和层
            var source_polygon, vector_polygon;    //定义全局多边形对象源和层
            var source_circle, vector_circle;    //定义全局多边形对象源和层
            var source_region, vector_region;    //定义全局多边形对象源和层
            var source_draw, vector_draw;    //定义全局鼠标绘制对象源和层
            var mapDragInteraction;       //定义拖动交互功能

            /******************地图初始化函数***************/
            function initMap() {
                mapDragInteraction = new app.Drag();

                //初始化map对象
                map = new ol.Map({
                    target: 'map',
                    projection: proj,
                    interactions: ol.interaction.defaults().extend([mapDragInteraction]),
                    view: new ol.View({
                        center: ol.proj.transform([101.46912, 36.24274], proj, proj_m),
                        zoom: 5
                    })
                });

                //初始化地图图层
                mapLayer = new ol.layer.Tile({
                    source: source_google,
                    projection: proj
                });
                //初始化标签图层
                mapLayerlabel = new ol.layer.Tile({
                    source: null,
                    projection: proj
                });

                //将图层加载到地图对象
                map.addLayer(mapLayer);
                map.addLayer(mapLayerlabel);

                //导航控件
                map.addControl(new ol.control.ZoomSlider());
                //鼠标位置控件
                map.addControl(new ol.control.MousePosition({
                    projection: proj,
                    coordinateFormat: function (coordinate) {
                        var zoom = map.getView().getZoom();
                        return '地图级别:' + zoom + ",  " + ol.coordinate.format(coordinate, '经度:{x}°,  纬度: {y}°', 10);
                    }
                }));

                //比例尺控件
                map.addControl(new ol.control.ScaleLine());

                //全屏显示控件
                map.addControl(new ol.control.FullScreen());

                //鹰眼图控件
                map.addControl(new ol.control.OverviewMap({
                    tipLabel: "鹰眼图"
                }));

                /*******************在地图初始化函数中初始化测量控件层************************/
                source_measure = new ol.source.Vector();
                vector_measure = new ol.layer.Vector({
                    source: source_measure,
                    style: new ol.style.Style({
                        fill: new ol.style.Fill({
                            color: 'rgba(255, 0, 0, 0.1)'
                        }),
                        stroke: new ol.style.Stroke({
                            color: '#ff8080',
                            width: 2
                        })
                    })
                });

                map.addLayer(vector_measure);


                /*******************在地图初始化函数中初始化点对象标注层************************/
                source_point = new ol.source.Vector();

                vector_point = new ol.layer.Vector({
                    source: source_point
                });

                map.addLayer(vector_point);

                /*******************在地图初始化函数中初始化折线对象标注层************************/
                source_zx = new ol.source.Vector();

                vector_zx = new ol.layer.Vector({
                    source: source_zx
                });

                map.addLayer(vector_zx);

                /*******************在地图初始化函数中初始化贝塞尔曲线标注层************************/
                source_bezier = new ol.source.Vector();

                vector_bezier = new ol.layer.Vector({
                    source: source_bezier
                });

                map.addLayer(vector_bezier);

                /*******************在地图初始化函数中初始化箭头线标注层************************/
                source_arrow = new ol.source.Vector();

                vector_arrow = new ol.layer.Vector({
                    source: source_arrow
                });

                map.addLayer(vector_arrow);

                /*******************在地图初始化函数中初始化多边形面标注层************************/
                source_polygon = new ol.source.Vector();

                vector_polygon = new ol.layer.Vector({
                    source: source_polygon
                });

                map.addLayer(vector_polygon);


                /*******************在地图初始化函数中初始化圆标注层************************/
                source_circle = new ol.source.Vector();

                vector_circle = new ol.layer.Vector({
                    source: source_circle
                });

                map.addLayer(vector_circle);


                /*******************在地图初始化函数中初始化多边形面标注层************************/
                source_region = new ol.source.Vector();

                vector_region = new ol.layer.Vector({
                    source: source_region
                });

                map.addLayer(vector_region);
                
                /*******************在地图初始化函数中初始化鼠标绘制标注层************************/
                source_draw = new ol.source.Vector();

                vector_draw = new ol.layer.Vector({
                    source: source_draw
                });

                map.addLayer(vector_draw);


                /************************在地图初始化时添加popup标记******************************/
                var container = document.getElementById('popup');
                var content = document.getElementById('popup-content');
                var closer = document.getElementById('popup-closer');

                popup = new ol.Overlay(/** @type {olx.OverlayOptions} */ ({
                    element: container,
                    autoPan: true,
                    autoPanAnimation: {
                        duration: 250
                    },
                    offset: [0, -32]
                }));
                map.addOverlay(popup);

                //为popup上的close按钮添加关闭事件
                closer.onclick = function () {
                    popup.setPosition(undefined);
                    closer.blur();
                    return false;
                }

                /*******************在图中监听pointermove事件************************/
                map.on('pointermove', pointerMoveHandler);  //在measure.js中实现pointerMoveHandler函数  
                map.on('pointermove', function (e) {
                    if (e.dragging) {
                        popup.setPosition(undefined);
                        closer.blur();
                        return;
                    }
                });

                //添加地图单击事件
                map.on('singleclick', function (evt) {
                    var feature = map.forEachFeatureAtPixel(evt.pixel, function (f) {
                        return f;
                    });
                    if (feature && feature.get("id") != null && feature.get("lx") == "Point") {
                        popup.setPosition(feature.getGeometry().getCoordinates());
                        var strHtml = '<div style="width: 420px;height: 260px;">';
                        strHtml += '<div style="width: 100%;height: 50px;font-family:幼圆;font-size: 24pt;line-height: 50px">' + feature.getStyle().getText().getText() + '</div>';
                        strHtml += '<div style="width: 100%;height: 150px;"> ';
                        strHtml += '<div style="width: 150px;height: 150px;float: left;"><img src="images/nodata.png" style="width: 100%;height: 100%;" /></div>';
                        strHtml += '<div style="float: left;width: 230px;height: 110px;padding: 20px;font-size:12pt;">简述：这是一个点对象的测试示例，你可以根据需要定制出更多的弹出框版式。</div>';
                        strHtml += '</div>';
                        var jwd = ol.proj.transform([feature.get("lon"), feature.get("lat")], 'EPSG:3857', 'EPSG:4326');
                        strHtml += '<div style="width: 100%;height: 60px; padding: 10px;color: gray;font-size: 11pt;font-family:幼圆;line-height: 25px;">';
                        strHtml += '<div style="float: left;width: 48%;border-bottom: 1px gray dotted;"><div style="float: left;width: 80px;text-align: left">经度：</div><div style="float: right;width: 120px;text-align: right">' + parseInt(jwd[0] * 100000000) / 100000000 + '°</div></div>';
                        strHtml += '<div style="float: right;width: 48%;border-bottom: 1px gray dotted;"><div style="float: left;width: 80px;text-align: left">纬度：</div><div style="float: right;width: 120px;text-align: right">' + parseInt(jwd[1] * 100000000) / 100000000 + '°</div></div>';
                        strHtml += '<div style="float: left;width: 48%;border-bottom: 1px gray dotted;"><div style="float: left;width: 80px;text-align: left">地理位置：</div><div style="float: right;width: 120px;text-align: right">测试位置</div></div>';
                        strHtml += '<div style="float: right;width: 48%;border-bottom: 1px gray dotted;"><div style="float: left;width: 80px;text-align: left">联系电话：</div><div style="float: right;width: 120px;text-align: right">185********</div></div>';
                        strHtml += '</div>';
                        strHtml += '</div>';
                        content.innerHTML = strHtml;
                        setPointPropertygrid(feature);
                    } else {
                        popup.setPosition(undefined);
                        closer.blur();
                    }
                });

            }

            /******************地图切换方法***************/
            function changeBaseMap(sourcelist) {
                var cnt = sourcelist.length;
                if (1 == cnt) {
                    mapLayer.setSource(sourcelist[0]);
                    mapLayerlabel.setSource(null);
                } else if (2 == cnt) {
                    mapLayer.setSource(sourcelist[0]);
                    mapLayerlabel.setSource(sourcelist[1]);
                }
            }

            /******************测量控件切换方法***************/
            function startControl(control, self) {
                if (self.attr("class").indexOf("l-btn-plain-selected") >= 0) {
                    $(".easyui-linkbutton").linkbutton("unselect");
                    self.linkbutton("select");
                    removeMeasure(source_measure);
                    if ("line" == control || "area" == control) {
                        addMeasure(control, source_measure);
                    }else if ("rectSelect" == control) {
                        addDrawOnMap("Box");
                        drawonmap.on('drawend', function (evt) {
                            var extent = evt.feature.getGeometry().getExtent()    //得到选中的区域
                            var leftdownPoint = ol.proj.transform([extent[0], extent[1]], proj_m, proj);
                            var rightupPoint = ol.proj.transform([extent[2], extent[3]], proj_m, proj);
                            alert("左下坐标：" + leftdownPoint + "\n" + "右上坐标：" + rightupPoint);
                        });
                    } else if ("circleSelect" == control) {
                        addDrawOnMap("Circle");
                        drawonmap.on('drawend', function (evt) {
                            var center = ol.proj.transform(evt.feature.getGeometry().getCenter(), proj_m, proj);
                            var radius = evt.feature.getGeometry().getRadius();
                            alert("圆心坐标：" + center + "\n" + "半径：" + radius);
                        });
                    }
                } else {
                    self.linkbutton("unselect");
                    removeMeasure(source_measure);
                    clearDrawOnMap();
                }
            }
            
            /*************************计算两点间的距离，p1,p2坐标为wgs84坐标******************************/
            function getDistance(p1, p2) {
                var wgs84Sphere = new ol.Sphere(6378137);
                return wgs84Sphere.haversineDistance(p1, p2);
            }

            /******************在地图上标记一个点对象***************/
            //随机生成当前范围内的一个经纬度坐标，用于在地图上标点
            function randomPointJWD() {
                var topleftPoint = map.getCoordinateFromPixel([10, 10]);
                var centerPoint = map.getView().getCenter();
                var bottomrightPoint = [centerPoint[0] + (centerPoint[0] - topleftPoint[0]), centerPoint[1] + (centerPoint[1] - topleftPoint[1])];
                var jd = topleftPoint[0] + (bottomrightPoint[0] - topleftPoint[0]) * Math.random();
                var wd = bottomrightPoint[1] + (topleftPoint[1] - bottomrightPoint[1]) * Math.random();
                return [jd, wd];
            }

            //设置点对象属性值
            function setPointPropertygrid(point) {
                var d = $('#pg_point').propertygrid("getData");
                d.rows[0].value = point.get('id');
                d.rows[1].value = point.get('lx');
                var p = ol.proj.transform([point.get('lon'), point.get('lat')], proj_m, proj);
                d.rows[2].value = Math.floor(p[0] * 100000000) / 100000000;
                d.rows[3].value = Math.floor(p[1] * 100000000) / 100000000;
                d.rows[4].value = point.getStyle().getImage().getOpacity();
                d.rows[5].value = point.getStyle().getImage().getScale();
                d.rows[6].value = point.getStyle().getImage().getRotateWithView();
                d.rows[7].value = point.getStyle().getImage().getRotation();
                d.rows[8].value = point.getStyle().getImage().getSrc();
                d.rows[9].value = point.getStyle().getText().getTextAlign();
                d.rows[10].value = point.getStyle().getText().getTextBaseline();
                d.rows[11].value = point.getStyle().getText().getFont();
                d.rows[12].value = point.getStyle().getText().getText();
                d.rows[13].value = point.getStyle().getText().getFill().getColor();
                for (var i = 0; i < d.total; i++) {
                    $('#pg_point').propertygrid("refreshRow", i);
                }
            }

            //添加一个点
            var point_sl = 0;
            //layer:{ol.source.Vector}:需要添加点对象的图层
            //label:{string}:点对象名称
            //iconname:{string}:点对象的图标名称
            function addPoint(layer, label, iconname) {
                var p = randomPointJWD();
                var style = createStyle(1, 1, false, 0, "images/imgpoints/" + iconname, 'center', 'bottom', 'bold 12px 幼圆', label + point_sl, '#aa3300');
                var p = createPoint("point" + point_sl, "Point", p[0], p[1], style);
                layer.addFeature(p);
                setPointPropertygrid(p);
                point_sl++;
            }

            //更新点对象属性值
            //layer:{ol.source.Vector}:需要更新点对象的图层
            function updatePoint(layer) {
                var d = $('#pg_point').propertygrid("getData");
                var f = layer.getFeatureById(d.rows[0].value);      //通过id在点图层上找到相应的Feature对象          
                var style = createStyle(d.rows[4].value, d.rows[5].value, d.rows[6].value, d.rows[7].value, d.rows[8].value, d.rows[9].value, d.rows[10].value, d.rows[11].value, d.rows[12].value, d.rows[13].value);
                var jd = parseInt(d.rows[2].value * 100000000) / 100000000;
                var wd = parseInt(d.rows[3].value * 100000000) / 100000000;
                var jwd = ol.proj.transform([jd, wd], proj, proj_m);
                var p = createPoint(f.get("id"), f.get("lx"), jwd[0], jwd[1], style);  //根据新的属性重新构造一个点对象
                layer.removeFeature(f);  //删除老的点对象
                layer.addFeature(p);     //在图层上添加点对象
            }

            /******************在地图上标记一个折线对象***************/
            var timer_zx;
            var zx_sl = 1;
            function startDrawLine() {
                if (null == l) {
                    var style = createLineStyle("black", 2, 'round', 'round');
                    l = createLine("zxtest", "zx", [], style);
                    source_zx.addFeature(l);
                }
                var coord;
                timer_zx = window.setInterval(function () {
                    coord = randomPointJWD();
                    l.getGeometry().appendCoordinate(coord);
                    $("#zx_croodinates").html($("#zx_croodinates").html() + zx_sl++ + "." + ol.proj.transform(coord, proj_m, proj) + "<br>");
                }, 1000);
            }

            function stopDrawLine() {
                window.clearInterval(timer_zx);
            }

            function clearDrawLine() {
                stopDrawLine();
                source_zx.removeFeature(l);
                l = null;
                $("#zx_croodinates").html("");
                zx_sl = 1;
            }

            /**************************绘制贝塞尔曲线*****************************/
            function drawBezierCurve(n) {
                var arrPoints = [];
                for (var i = 0; i <= n; i++) {
                    arrPoints.push(randomPointJWD());
                }
                var arrbline = createBezierCurvePoints(n, arrPoints);
                var style = createLineStyle("#ff0080", 2, 'round', 'round');
                var f = createLine("bezier_nj" + Math.random(), "bezier", arrbline, style);
                source_bezier.addFeature(f);
            }

            function clearBezierCurve() {
                source_bezier.clear();
            }

            /**************************绘制箭头线*****************************/
            var arrow_sl = 0;
            function drawArrowLine() {
                var arrarrow = createArrowPoints(map.getCoordinateFromPixel([300 + arrow_sl * 10, 350 + arrow_sl * 10]), map.getCoordinateFromPixel([500 + arrow_sl * 10, 500 + arrow_sl * 10]), map.getCoordinateFromPixel([700 + arrow_sl * 10, 300 + arrow_sl * 10]));
                var style = createLineStyle("#ff8000", 2, 'round', 'round');
                var f = createLine("arrow" + Math.random(), "arrow", arrarrow, style);
                source_arrow.addFeature(f);
                arrow_sl++;
            }

            function clearArrowLine() {
                source_arrow.clear();
            }

            /**************************绘制多边形区域*****************************/
            function randomScreenPixel(r) {
                var centerSceenPixel = map.getPixelFromCoordinate(map.getView().getCenter()); //获取地图中心点的屏幕坐标
                var screenX = Math.floor(r + (centerSceenPixel[0] * 2 - 2 * r) * Math.random());
                var screenY = Math.floor(r + (centerSceenPixel[1] * 2 - 2 * r) * Math.random());
                return [screenX, screenY];
            }

            function drawRegularPolygon(n) {
                var r = 100;   //定义正多边形外接圆的半径，单位是像素
                var centerScreenPolygon = randomScreenPixel(r);  //随机生成多边形外接圆圆心点像素坐标
                var arrPoints = new Array();
                //得到正多边形各个端点的像素坐标
                var cpx, cpy;
                for (var i = 0; i < n; i++) {
                    cpx = Math.floor(r * Math.cos(i * 2 * Math.PI / n)) + centerScreenPolygon[0];
                    cpy = Math.floor(r * Math.sin(i * 2 * Math.PI / n)) + centerScreenPolygon[1];
                    arrPoints.push(map.getCoordinateFromPixel([cpx, cpy]));
                }
                arrPoints.push(arrPoints[0]);

                var style = createPolygonStyle("#ff0080", 2, 'rgba(0, 255, 0, 0.2)');
                var f = createPolygon("polygon" + Math.random(), "polygon", [arrPoints], style);
                source_polygon.addFeature(f);
            }

            function clearRegularPolygon() {
                source_polygon.clear();
            }

            /**************************绘制圆形区域*****************************/
            function drawCircle() {
                var center = randomPointJWD();
                var style = createPolygonStyle("#000080", 2, 'rgba(0, 0, 255, 0.2)');
                var f = createCircle("circle" + Math.random(), "circle", center, parseInt($("#txt_radius").textbox("getText")), style);
                source_circle.addFeature(f);
            }

            function clearCircle() {
                source_circle.clear();
            }
            
            /**************************在屏幕中间绘制集结地域*****************************/
            var region_sl=0;
            function drawRegion() {
                var p1 = map.getCoordinateFromPixel([500+region_sl*10, 300+region_sl*10]);
                var p2 = map.getCoordinateFromPixel([660+region_sl*10, 250+region_sl*10]);
                var p3 = map.getCoordinateFromPixel([700+region_sl*10, 400+region_sl*10]);
                var style = createPolygonStyle("#800080", 2, 'rgba(200, 0, 255, 0.1)');
                var arrPoints = createRegionPoints(p1, p2, p3);
                var f = createPolygon("region" + Math.random(), "region", [arrPoints], style);
                source_region.addFeature(f);
                region_sl++;
            }

            function clearRegion() {
                source_region.clear();
            }
            
            /**************************用鼠标绘制各种图形*****************************/
            var drawonmap; // global so we can remove it later
            function addDrawOnMap(type) {   //The geometry type. One of 'Point', 'LineString', 'LinearRing', 'Polygon', 'MultiPoint', 'MultiLineString', 'MultiPolygon', 'GeometryCollection', 'Circle'.
                if (drawonmap) {
                    map.removeInteraction(drawonmap);
                }
                if (type !== 'None') {
                    var geometryFunction, maxPoints;
                    if (type === 'Square') {
                        type = 'Circle';
                        geometryFunction = ol.interaction.Draw.createRegularPolygon(4);
                    } else if (type === 'Box') {
                        type = 'LineString';
                        maxPoints = 2;
                        geometryFunction = function (coordinates, geometry) {
                            if (!geometry) {
                                geometry = new ol.geom.Polygon(null);
                            }
                            var start = coordinates[0];
                            var end = coordinates[1];
                            geometry.setCoordinates([
                                [start, [start[0], end[1]], end, [end[0], start[1]], start]
                            ]);
                            return geometry;
                        };
                    }

                    var style = createPolygonStyle("#808080", 2, 'rgba(200, 0, 255, 0.1)');
                    drawonmap = new ol.interaction.Draw({
                        source: source_draw,
                        style: style,
                        type: /** @type {ol.geom.GeometryType} */ (type),
                        geometryFunction: geometryFunction,
                        maxPoints: maxPoints
                    });
                    map.addInteraction(drawonmap);
                }
            }

            function clearDrawOnMap() {
                source_draw.clear();
                addDrawOnMap("None");
            }
            
            /*****************************开启或关闭图上feature的拖动函数*******************************/
            function dragChange(flag) {
                if (flag) {
                    map.addInteraction(mapDragInteraction);
                } else {
                    map.removeInteraction(mapDragInteraction);
                }
            }


        </script>
    </head>
    <body onload="initMap()" class="easyui-layout" style="margin: 0;padding: 0;">
        <div data-options="region:'north'" style="height:100px;overflow: hidden;background-image: url('images/bg_title.png');">
            <img src="images/toptitle.png" style="width:1050px;height: 80px;margin-top: 10px;margin-left: 30px;" />
        </div>
        <div data-options="region:'center'" class="easyui-layout" style="border: none" >
            <div data-options="region:'north'" style="height:35px;overflow: hidden;background-color: lightyellow">
                <div style="float:left;padding-top:3px;padding-left: 10px;border:none;font-size: 10pt;">
                    <a id="btn_cljl" href="javascript:startControl('line',$('#btn_cljl'))" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cj',toggle:true">测量距离</a>
                    <a id="btn_clmj" href="javascript:startControl('area',$('#btn_clmj'))" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-cmj',toggle:true">测量面积</a>|
                    <a id="btn_jxxz" href="javascript:startControl('rectSelect',$('#btn_jxxz'))" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-jxxz',toggle:true">矩形选择</a>
                    <a id="btn_yxxz" href="javascript:startControl('circleSelect',$('#btn_yxxz'))" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-yxxz',toggle:true">圆形选择</a>|
                    <input id="chk_point_drag" name="chk_point_drag" type="checkbox" checked="true" onchange="dragChange(this.checked)">可拖动&nbsp;|
                    <a href="#" class="easyui-menubutton" data-options="plain:true,iconCls:'icon-dzdt',menu:'#menu_maplist'">在线地图</a>     
                    <a href="#" class="easyui-menubutton" data-options="plain:true,iconCls:'icon-wxdt',menu:'#menu_maplist_offline'">离线地图</a>
                    <a id="export-png" href="#" download="map.png" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-print'">地图导出</a>|
                    <a href="javascript:closeWindow();" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-no'">关闭</a>
                </div>
                <div id="div_measureoutput" style="float:right;padding-right: 10px;border:none ;font-size: 12pt;line-height: 35px;text-align: right;width: 230px;height: 35px;"></div>
            </div>
            <div data-options="region:'center'" class="easyui-layout">
                <div data-options="region:'west',collapsible:true" title="标图面板" style="width:270px;overflow: hidden;">
                    <div class="easyui-accordion" style="width:100%;height:100%;">
                        <div title="点对象" data-options="iconCls:'icon-addpoint'" style="padding:10px;">
                            <div style="height:35px;width: 100%;    ">
                                <a class="easyui-menubutton c8" data-options="menu:'#menu_pointlist',iconCls:'icon-addpoint'">新增点对象</a>&nbsp;&nbsp;&nbsp;&nbsp; 
                                <a class="easyui-linkbutton" href="javascript:updatePoint(source_point, 'pg_point')" data-options="iconCls:'icon-reload'">刷新当前点</a>
                            </div>
                            <div style="width:100%;">
                                <table id="pg_point" class="easyui-propertygrid" data-options="
                                       data: {'total':14,'rows':[
                                       {'name':'ID','value':'','group':'图形'},
                                       {'name':'类型','value':'Point','group':'图形'},
                                       {'name':'经度','value':'','group':'图形','editor':{type:'numberbox',options:{precision:8}}},
                                       {'name':'纬度','value':'','group':'图形','editor':{type:'numberbox',options:{precision:8}}},
                                       {'name':'透明度','value':'1','group':'图形','editor':{type:'numberbox',options:{precision:2}}},
                                       {'name':'缩放比例','value':'1','group':'图形','editor':{type:'numberbox',options:{precision:2}}},
                                       {'name':'跟随地图旋转','value':'false','group':'图形','editor':{type:'combobox',options:{valueField:'id',textField:'text',editable:false,panelHeight:'auto',data:[{'id':'true','text':'true'},{'id':'false','text':'false'}]}}},
                                       {'name':'旋转角度','value':'0','group':'图形','editor':{type:'numberbox',options:{precision:2}}},
                                       {'name':'图片地址','value':'','group':'图形','editor':'text'},                                       
                                       {'name':'水平位置','value':'left','group':'文字','editor':{type:'combobox',options:{valueField:'id',textField:'text',editable:false,panelHeight:'auto',data:[{'id':'left','text':'left'},{'id':'right','text':'right'},{'id':'center','text':'center'},{'id':'end','text':'end'},{'id':'start','text':'start'}]}}},
                                       {'name':'垂直位置','value':'bottom','group':'文字','editor':{type:'combobox',options:{valueField:'id',textField:'text',editable:false,panelHeight:'auto',data:[{'id':'bottom','text':'bottom'},{'id':'top','text':'top'},{'id':'middle','text':'middle'},{'id':'alphabetic','text':'alphabetic'},{'id':'hanging','text':'hanging'},{'id':'ideographic','text':'ideographic'}]}}},
                                       {'name':'字体','value':'bold 12px 幼圆','group':'文字','editor':'text'},
                                       {'name':'内容','value':'','group':'文字','editor':'text'},
                                       {'name':'颜色','value':'#ff0000','group':'文字','editor':'text'}
                                       ]},
                                       method: 'get',
                                       showGroup: true,
                                       scrollbarSize: 0,
                                       showHeader:false,
                                       columns: [[
                                       {field:'name',title:'MyName',sortable:false},
                                       {field:'value',title:'MyValue',width:170,resizable:false,formatter:function(value){
                                       var s='<div>';
                                       s += '<div style=\'float:right;width:18px;height:18px;background:'+value+'\'>&nbsp;</div>';
                                       s += value;
                                       s += '<div style=\'clear:both\'</div>';
                                       s += '</div>';
                                       return s;
                                       } }
                                       ]]
                                       ">
                                </table>
                            </div>
                        </div>
                        <div title="折线" data-options="iconCls:'icon-line_zx'" style="padding:10px;">
                            <div style="height:30px;width: 100%;font-family: 幼圆;font-size: 12pt;text-align: center">
                                画连续折线
                            </div>
                            <div style="height:30px; width:100%;text-align: center">
                                <a class="easyui-linkbutton" href="javascript:startDrawLine()" data-options="iconCls:'icon-playstart'">开始</a>&nbsp;&nbsp;
                                <a class="easyui-linkbutton" href="javascript:stopDrawLine()" data-options="iconCls:'icon-playstop'">停止</a>&nbsp;&nbsp;
                                <a class="easyui-linkbutton" href="javascript:clearDrawLine()" data-options="iconCls:'icon-playrefresh'">清除</a>&nbsp;&nbsp;
                            </div>
                            <div id="zx_croodinates" style="height:80%;width: 100%;font-family: 幼圆;font-size: 12pt;text-align: center">

                            </div>
                        </div>
                        <div title="贝塞尔曲线" data-options="iconCls:'icon-line_bezier'" style="padding:10px;">
                            <div style="height: 30px; width:100%;text-align: center">
                                <a id="bsl1" class="easyui-linkbutton" href="javascript:drawBezierCurve(2)">随机画二阶曲线</a>                                
                            </div>
                            <div style="height: 140px; width:100%;text-align: center">
                                <img src="images/bezier/2jbezier.gif" /><br>
                                B(t)=(1-t)<sup>2</sup>P<sub>0</sub>+2t(1-t)P<sub>1</sub>+t<sup>2</sup>P<sub>2</sub>,t∈[0,1]
                            </div>
                            <div style="height: 30px; width:100%;text-align: center">                                
                                <a id="bsl2" class="easyui-linkbutton" href="javascript:drawBezierCurve(3)">随机画三阶曲线</a>
                            </div>
                            <div style="height: 150px; width:100%;text-align: center">
                                <img src="images/bezier/3jbezier.gif"/><br>
                                B(t)=(1-t)<sup>3</sup>P<sub>0</sub>+3t(1-t)<sup>2</sup>P<sub>1</sub>+3t<sup>2</sup>(1-t)P<sub>2</sub>+t<sup>3</sup>P<sub>3</sub>,t∈[0,1]
                            </div>
                            <div style="height: 30px; width:100%;text-align: center">
                                <a class="easyui-linkbutton" href="javascript:clearBezierCurve()" data-options="iconCls:'icon-playrefresh'">清除</a>
                            </div>
                            <div style="height: 150px; width:100%;text-align: center">
                                <img src="images/bezier/njform.png" style="width:250px;height:181px"/><br>
                            </div>
                        </div>
                        <div title="在屏幕中央画一个矢量箭头" data-options="iconCls:'icon-line_arrow'" style="padding:10px;text-align: center">
                            <div style="height: 30px; width:100%;text-align: center">
                                <a class="easyui-linkbutton" href="javascript:drawArrowLine()">画箭头线</a>
                                <a class="easyui-linkbutton" href="javascript:clearArrowLine()" data-options="iconCls:'icon-playrefresh'">清除</a>
                            </div>
                            <div style="height: 150px; width:100%;text-align: center">
                                <img src="images/arrow/arrow.png" style="width:250px;height:181px"/><br>
                            </div>
                        </div>
                        <div title="多边形" data-options="iconCls:'icon-line_zx'" style="padding:10px;">
                            <div style="height:30px;width: 100%;font-family: 幼圆;font-size: 12pt;text-align: center">
                                随机生成点画多边形
                            </div>
                            <div style="height:30px; width:100%;text-align: center">
                                <select id="cc_polygon" class="easyui-combobox" data-options="valueField:'id',textField:'text',editable:false,panelHeight:'auto',data:[{'id':3,'text':'三边形','selected':true},{'id':4,'text':'四边形'},{'id':5,'text':'五边形'},{'id':6,'text':'六边形'},{'id':7,'text':'七边形'},{'id':8,'text':'八边形'},{'id':9,'text':'九边形'},{'id':10,'text':'十边形'}]" style="width:70px;"></select>
                                <a class="easyui-linkbutton" href="javascript:drawRegularPolygon($('#cc_polygon').combobox('getValue'))" data-options="iconCls:'icon-playstart'">随机画一个</a>&nbsp;&nbsp;
                                <a class="easyui-linkbutton" href="javascript:clearRegularPolygon()" data-options="iconCls:'icon-playrefresh'">清除</a>
                            </div>
                        </div>
                        <div title="圆" data-options="iconCls:'icon-line_qyx'" style="padding:10px;">
                            <div style="height:30px;width: 100%;font-family: 幼圆;font-size: 12pt;text-align: center">
                                随机画一个圆
                            </div>
                            <div style="height:30px;width: 100%;font-family: 幼圆;font-size: 12pt;text-align: center">
                                半径：<input id="txt_radius" class="easyui-textbox" style="width:100px">
                            </div>
                            <div style="height: 30px; width:100%;text-align: center">
                                <a class="easyui-linkbutton" href="javascript:drawCircle()" data-options="iconCls:'icon-playstart'">画一个圆</a>&nbsp;&nbsp;
                                <a class="easyui-linkbutton" href="javascript:clearCircle()" data-options="iconCls:'icon-playrefresh'">清除</a>
                            </div>
                        </div>
                        <div title="在屏幕中央画一个集结地域" data-options="iconCls:'icon-line_qyx'" style="padding:10px;">
                            <div style="height: 30px; width:100%;text-align: center">
                                <a class="easyui-linkbutton" href="javascript:drawRegion()" data-options="iconCls:'icon-playstart'">画集结地域</a>&nbsp;&nbsp;
                                <a class="easyui-linkbutton" href="javascript:clearRegion()" data-options="iconCls:'icon-playrefresh'">清除</a>
                            </div>
                            <div style="height: 150px; width:100%;text-align: center">
                                <img src="images/region/region.png" style="width:250px;height:181px"/><br>
                            </div>
                        </div>
                        <div title="用鼠标绘制图形" data-options="iconCls:'icon-line_qyx'" style="padding:10px;">
                            <div style="height: 30px; width:100%;text-align: center">
                                <a class="easyui-linkbutton" href="javascript:addDrawOnMap('Point')">画点</a>
                                <a class="easyui-linkbutton" href="javascript:addDrawOnMap('LineString')">画折线</a>
                                <a class="easyui-linkbutton" href="javascript:addDrawOnMap('Polygon')">画多边形</a>
                                <a class="easyui-linkbutton" href="javascript:addDrawOnMap('Circle')">画圆形</a>
                                <a class="easyui-linkbutton" href="javascript:addDrawOnMap('Square')">画正方形</a>
                                <a class="easyui-linkbutton" href="javascript:addDrawOnMap('Box')">画矩形</a>
                                <a class="easyui-linkbutton" href="javascript:clearDrawOnMap()" data-options="iconCls:'icon-playrefresh'">清除</a>
                            </div>                            
                        </div>
                    </div>
                </div>
                <div data-options="region:'center'">
                    <div style= "overflow: hidden;width:100%;height: 100%;" id="map">
                        <div id="popup" class="ol-popup">
                            <a href="#" id="popup-closer" class="ol-popup-closer"></a>
                            <div id="popup-content"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>  
        <div id="menu_pointlist" style="width:150px;">
            <div data-options="iconCls:'icon-point_jc'" onclick="addPoint(source_point, '机场', 'jc.png')">机场</div>
            <div data-options="iconCls:'icon-point_gk'" onclick="addPoint(source_point, '港口', 'gk.png')">港口</div>
            <div data-options="iconCls:'icon-point_ck'" onclick="addPoint(source_point, '仓库', 'ck.png')">仓库</div>
            <div data-options="iconCls:'icon-point_yz'" onclick="addPoint(source_point, '加油站', 'yz.png')">加油站</div>
            <div class="menu-sep"></div>
            <div data-options="iconCls:'icon-point_zlsc'" onclick="addPoint(source_point, '自来水厂', 'zlsc.png')">自来水厂</div>
            <div data-options="iconCls:'icon-point_qy'" onclick="addPoint(source_point, '企业', 'qy.png')">企业</div>
            <div data-options="iconCls:'icon-point_cl'" onclick="addPoint(source_point, '车辆', 'cl.png')">车辆</div>            
            <div class="menu-sep"></div>
            <div data-options="iconCls:'icon-point_bg'" onclick="addPoint(source_point, '宾馆', 'bg.png')">宾馆</div>
            <div data-options="iconCls:'icon-point_cy'" onclick="addPoint(source_point, '餐饮', 'cy.png')">餐饮</div>
            <div data-options="iconCls:'icon-point_tcc'" onclick="addPoint(source_point, '高速收费站', 'tcc.png')">高速收费站</div>
            <div data-options="iconCls:'icon-point_jyz'" onclick="addPoint(source_point, '加油站', 'jyz.png')">加油站</div>
            <div data-options="iconCls:'icon-point_jtd'" onclick="addPoint(source_point, '交通灯', 'jtd.png')">交通灯</div>
            <div data-options="iconCls:'icon-point_yh'" onclick="addPoint(source_point, '银行', 'yh.png')">银行</div>
            <div data-options="iconCls:'icon-point_yy'" onclick="addPoint(source_point, '医院', 'yy.png')">医院</div>
            <div data-options="iconCls:'icon-point_poi'" onclick="addPoint(source_point, '兴趣点', 'poi.png')">兴趣点</div>
        </div>
        <div id="menu_maplist" style="width:150px;">
            <div  onclick="changeBaseMap([source_google])">Google电子地图</div>
            <div  onclick="changeBaseMap([source_googledx])">Google地形图</div>
            <div  onclick="changeBaseMap([source_googlesat])">Google卫星地图</div>
            <div class="menu-sep"></div>
            <div  onclick="changeBaseMap([source_qq])">腾讯soso电子地图</div>
            <div  onclick="changeBaseMap([source_qqdx, source_qqdxlabel])">腾讯soso地形图</div>
            <div  onclick="changeBaseMap([source_qqsat, source_qqsatlabel])">腾讯soso卫星地图</div>
            <div class="menu-sep"></div>
            <div  onclick="changeBaseMap([source_baidu])">百度电子地图</div>
            <div  onclick="changeBaseMap([source_baidusat, source_baidusatlabel])">百度卫星地图</div>
            <div class="menu-sep"></div>
            <div  onclick="changeBaseMap([source_gaode])">高德电子地图</div>
            <div  onclick="changeBaseMap([source_gaodesat, source_gaodesatlabel])">高德卫星地图</div>
            <div class="menu-sep"></div>
            <div  onclick="changeBaseMap([source_tiandi, source_tiandilabel])">天地电子地图</div>
            <div  onclick="changeBaseMap([source_tiandisat, source_tiandilabel])">天地卫星地图</div>
        </div>
        <div id="menu_maplist_offline" style="width:150px;">
            <div  onclick="changeBaseMap([source_arcgis_offline])">arcgis瓦片电子地图</div>
            <div  onclick="changeBaseMap([source_arcgissat_offline])">arcgis瓦片卫星地图</div>
            <div class="menu-sep"></div>
            <div  onclick="changeBaseMap([source_sqlite_offline])">Sqlite数据库电子地图</div>
            <div  onclick="changeBaseMap([source_sqlitesat_offline])">Sqlite数据库卫星地图 </div>
        </div>
        <div id="win_tip" class="easyui-window" title="提示" style="width:700px;height:400px;overflow: hidden" data-options="iconCls:'icon-info',modal:true,collapsible:false,minimizable:false,maximizable:false,resizable:false,closed:true">
            <div style="width: 100%;height: 30px;text-align: center;line-height: 30px;color: red;font-size: 12pt">当前浏览器可能不支持地图的导出功能，各类浏览器支持情况请看下图所示。</div>
            <img src="images/browser.jpg" style="width:100%;height: 330px" />
        </div>
    </body>
</html>
