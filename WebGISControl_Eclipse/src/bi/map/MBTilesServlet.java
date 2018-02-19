/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package bi.map;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Administrator
 */
public class MBTilesServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet MBTilesServlet</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MBTilesServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //获取浏览器传递参数值
        String tile_column = request.getParameter("X");
        String tile_row = request.getParameter("Y");
        String zoom_level = request.getParameter("L");
        String mapname = request.getParameter("T");

        //判断sqlite连接引擎是否存在
        try {
            Class.forName("org.sqlite.JDBC");
        } catch (ClassNotFoundException e) {
            // TODO Auto-generated catch block  
            // e.printStackTrace();  
            System.out.println("数据库驱动未找到!");
        }

        Connection conn;        
        try {
            //conurl：获取mbtiles文件地址
            String conurl = "jdbc:sqlite:E:\\SqliteMaps\\" + mapname + "\\" + zoom_level + ".mbtiles";
            conn = DriverManager.getConnection(conurl, null, null);
            // 设置自动提交为false  
            conn.setAutoCommit(false);  
            Statement stmt = conn.createStatement(); 
            //判断表是否存在  
            ResultSet rsTables = conn.getMetaData().getTables(null, null, "tiles", null);  
            if(!rsTables.next()){  
                System.out.println("表不存在");  
            }
            // 得到结果集  
            String sql = "SELECT * FROM tiles WHERE zoom_level = "+zoom_level+  
                    " AND tile_column = "+tile_column+  
                    " AND tile_row = "+tile_row;  
            ResultSet rs = stmt.executeQuery(sql);
            if(rs.next()) {
                byte[] imgByte = (byte[]) rs.getObject("tile_data");  
                InputStream is = new ByteArrayInputStream(imgByte);  
                OutputStream os = response.getOutputStream();  
                try {  
                    int count = 0;  
                    byte[] buffer = new byte[256 * 256];  
                    while ((count = is.read(buffer)) != -1) {  
                        os.write(buffer, 0, count);  
                    }  
                    os.flush();  
                } catch (IOException e) {  
                    e.printStackTrace();  
                } finally {  
                    os.close();  
                    is.close();  
                }  
            }  
            else{  
                System.out.println(sql);  
                System.out.println("未找到图片！");  
            }  
            rs.close();  
            conn.close();  
        } catch (SQLException ex) {
            System.out.println("SQL异常!");
            Logger.getLogger(MBTilesServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
