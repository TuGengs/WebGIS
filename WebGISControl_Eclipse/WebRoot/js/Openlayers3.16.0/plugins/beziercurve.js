/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

//阶乘
function factorial(num) {
    if (num <= 1) {
        return 1;
    } else {
        return num * factorial(num - 1);
    }
}

/*
 * 生成贝塞尔曲线插值点
 * @para n {number} 控制点数量
 * @para arrPoints {array} 控制点坐标集合
 */
function createBezierCurvePoints(n, arrPoints) {
    var Ptx = 0;
    var Pty = 0;

    var arrbline = [];
    for (var t = 0; t < 1; t = t + 0.01) {
        Ptx = 0;
        Pty = 0;
        for (var i = 0; i <= n; i++) {
            Ptx += (factorial(n) / (factorial(i) * factorial(n - i))) * Math.pow((1 - t), n - i) * Math.pow(t, i) * arrPoints[i][0];
            Pty += (factorial(n) / (factorial(i) * factorial(n - i))) * Math.pow((1 - t), n - i) * Math.pow(t, i) * arrPoints[i][1];
        }
        arrbline.push([Ptx, Pty]);
    }
    return arrbline;
}
