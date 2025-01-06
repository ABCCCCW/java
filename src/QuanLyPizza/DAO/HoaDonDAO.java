package QuanLyPizza.DAO;

import QuanLyPizza.DTO.HoaDon;
import java.sql.*;
import java.util.ArrayList;

public class HoaDonDAO {

    public ArrayList<HoaDon> getListHoaDon() {
        ArrayList<HoaDon> dshd = new ArrayList<>();
        try {
            String sql = "SELECT hd.*, CONCAT(kh.Ho, ' ', kh.Ten) AS HoTenKH, CONCAT(nv.Ho, ' ', nv.Ten) AS HoTenNV " +
                         "FROM hoadon hd " +
                         "JOIN KhachHang kh ON hd.MaKH = kh.MaKH " +
                         "JOIN NhanVien nv ON hd.MaNV = nv.MaNV";
            Statement stmt = MyConnect.conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                HoaDon hd = new HoaDon();
                hd.setMaHD(rs.getInt("MaHD"));
                hd.setMaKH(rs.getInt("MaKH"));
                hd.setMaNV(rs.getInt("MaNV"));
                hd.setNgayLap(rs.getDate("NgayLap"));
                hd.setTongTien(rs.getInt("TongTien"));
                hd.setGhiChu(rs.getString("GhiChu"));
                hd.setTenKhachHang(rs.getString("HoTenKH"));
                hd.setTenNhanVien(rs.getString("HoTenNV"));
                dshd.add(hd);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
            return null;
        }
        return dshd;
    }

    public String getTenKhachHang(int maKH) {
        try {
            String sql = "SELECT CONCAT(Ho, ' ', Ten) AS HoTen FROM KhachHang WHERE MaKH = ?";
            PreparedStatement prep = MyConnect.conn.prepareStatement(sql);
            prep.setInt(1, maKH);
            ResultSet rs = prep.executeQuery();
            if (rs.next()) {
                return rs.getString("HoTen");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public String getTenNhanVien(int maNV) {
        try {
            String sql = "SELECT CONCAT(Ho, ' ', Ten) AS HoTen FROM NhanVien WHERE MaNV = ?";
            PreparedStatement prep = MyConnect.conn.prepareStatement(sql);
            prep.setInt(1, maNV);
            ResultSet rs = prep.executeQuery();
            if (rs.next()) {
                return rs.getString("HoTen");
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public boolean addHoaDon(HoaDon hd) {
        boolean result = false;
        try {
            String sql1 = "UPDATE KhachHang SET TongChiTieu=TongChiTieu+" + hd.getTongTien() + " WHERE MaKH=" + hd.getMaKH();
            Statement st = MyConnect.conn.createStatement();
            st.executeUpdate(sql1);
            String sql = "INSERT INTO hoadon(MaKH, MaNV, NgayLap, TongTien, GhiChu) VALUES(?, ?, ?, ?, ?)";
            PreparedStatement prep = MyConnect.conn.prepareStatement(sql);
            prep.setInt(1, hd.getMaKH());
            prep.setInt(2, hd.getMaNV());
            prep.setTimestamp(3, new java.sql.Timestamp(new java.util.Date().getTime()));
            prep.setInt(4, hd.getTongTien());
            prep.setString(5, hd.getGhiChu());
            result = prep.executeUpdate() > 0;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }
        return result;
    }

    public int getMaHoaDonMoiNhat() {
        try {
            String sql = "SELECT MAX(maHD) FROM hoadon";
            Statement st = MyConnect.conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            if (rs.next())
                return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public ArrayList<HoaDon> getListHoaDon(Date dateMin, Date dateMax) {
        try {
            String sql = "SELECT hd.*, CONCAT(kh.Ho, ' ', kh.Ten) AS HoTenKH, CONCAT(nv.Ho, ' ', nv.Ten) AS HoTenNV " +
                         "FROM hoadon hd " +
                         "JOIN KhachHang kh ON hd.MaKH = kh.MaKH " +
                         "JOIN NhanVien nv ON hd.MaNV = nv.MaNV " +
                         "WHERE NgayLap BETWEEN CAST(? AS DATE) AND CAST(? AS DATE)";
            PreparedStatement pre = MyConnect.conn.prepareStatement(sql);
            pre.setDate(1, dateMin);
            pre.setDate(2, dateMax);
            ResultSet rs = pre.executeQuery();

            ArrayList<HoaDon> dshd = new ArrayList<>();

            while (rs.next()) {
                HoaDon hd = new HoaDon();
                hd.setMaHD(rs.getInt("MaHD"));
                hd.setMaKH(rs.getInt("MaKH"));
                hd.setMaNV(rs.getInt("MaNV"));
                hd.setNgayLap(rs.getDate("NgayLap"));
                hd.setTongTien(rs.getInt("TongTien"));
                hd.setGhiChu(rs.getString("GhiChu"));
                hd.setTenKhachHang(rs.getString("HoTenKH"));
                hd.setTenNhanVien(rs.getString("HoTenNV"));
                dshd.add(hd);
            }
            return dshd;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
