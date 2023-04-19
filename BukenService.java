/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package FudosanService;

import FudosanBean.BukenBean;
import static com.sun.org.apache.xalan.internal.lib.ExsltDatetime.date;
import java.util.List;
//import java.awt.List;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author hangt
 */
public class BukenService {
//物件一覧を取得

    public List<BukenBean> listInfo() {
        JdbcConn jc = new JdbcConn();
        List<BukenBean> list = new ArrayList<BukenBean>();

        try {
            jc.getDbcom();

            String sql = "SELECT * FROM Property";

            try {
                ResultSet resultSet = jc.tt(sql);
                while (resultSet.next()) {
                    BukenBean bukenBeanlist = new BukenBean();
                    bukenBeanlist.setPropertyId(resultSet.getInt("property_id"));
                    bukenBeanlist.setPropertyName(resultSet.getString("property_name"));
                    bukenBeanlist.setAddress(resultSet.getString("address"));
                    bukenBeanlist.setPropertyType(resultSet.getString("property_type"));
                    bukenBeanlist.setPrice(resultSet.getString("price"));
                    list.add(bukenBeanlist);
                }
                jc.closeDbcom();
            } catch (SQLException ex) {
                Logger.getLogger(BukenService.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(BukenService.class.getName()).log(Level.SEVERE, null, ex);
        }

        return list;
    }

    //ユーザー新規
    public void usersInsert(String id, String password) throws SQLException {
        LocalDateTime date = LocalDateTime.now();
        JdbcConn jc = new JdbcConn();

        try {
            jc.getDbcom();

            //int bukenid = select();
            String sql = "insert into Users( id , password ) "
                    + "values('" + id + "','" + password + "')";

            jc.cud(sql);
            
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(BukenService.class.getName()).log(Level.SEVERE, null, ex);
        }

    }

    //物件新規

    public void bukenInsert(String propertyId, String propertyName, String address, String propertyType, String price) throws SQLException {
        LocalDateTime date = LocalDateTime.now();
        JdbcConn jc = new JdbcConn();

        try {
            jc.getDbcom();

            //int bukenid = select();
            String sql = "insert into Property( property_id , property_name , address , property_type , price) "
                    + "values('" + propertyId + "','" + propertyName + "','" + address + "','" + propertyType + "','" + price + "')";

            jc.cud(sql);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(BukenService.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    //物件削除
    public void bukenDelete(BukenBean bb) throws SQLException {
        JdbcConn jc = new JdbcConn();
        try {
            jc.getDbcom();
            StringBuffer sb = new StringBuffer();
            sb.append("delete from Property ");
            sb.append(" where ");
            sb.append(" property_id = '" + bb.getPropertyId() + "'");
            sb.append(";");
            System.out.println(sb);
            System.out.println(sb.toString());
            jc.cud(sb.toString());

        } catch (ClassNotFoundException ex) {
            Logger.getLogger(BukenService.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public void bukenUpdate(BukenBean bb) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }

}
