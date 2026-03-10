package QuanLyPizza.DAO;

import MyCustom.MyDialog;

import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

public class MyConnect {

    public static Connection conn = null;
    private static final String DB_DIR = "data";
    private static final String DB_NAME = "quanlypizza";
    private static final String DB_URL = "jdbc:h2:./" + DB_DIR + "/" + DB_NAME
            + ";MODE=MySQL;DATABASE_TO_LOWER=TRUE;CASE_INSENSITIVE_IDENTIFIERS=TRUE;AUTO_SERVER=TRUE";
    private static final String DB_USER = "sa";
    private static final String DB_PASS = "";

    public MyConnect() {
        try {
            Class.forName("org.h2.Driver");

            // Tạo thư mục data nếu chưa có
            File dataDir = new File(DB_DIR);
            if (!dataDir.exists()) {
                dataDir.mkdirs();
            }

            // Kiểm tra xem database đã tồn tại chưa
            boolean isNewDB = !new File(DB_DIR + "/" + DB_NAME + ".mv.db").exists();

            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            // Nếu là database mới, khởi tạo dữ liệu
            if (isNewDB) {
                initDatabase();
            }
        } catch (ClassNotFoundException ex) {
            new MyDialog("Không tìm thấy driver H2 Database!", MyDialog.ERROR_DIALOG);
            System.exit(0);
        } catch (SQLException ex) {
            new MyDialog("Không kết nối được tới CSDL!\n" + ex.getMessage(), MyDialog.ERROR_DIALOG);
            System.exit(0);
        }
    }

    private void initDatabase() {
        System.out.println("Đang khởi tạo database lần đầu...");
        try {
            // Đọc file SQL init
            InputStream is = getClass().getResourceAsStream("/database/quanlypizza_h2.sql");
            if (is == null) {
                // Thử đọc từ file system (khi chạy từ IDE)
                File sqlFile = new File("database/quanlypizza_h2.sql");
                if (sqlFile.exists()) {
                    is = new FileInputStream(sqlFile);
                } else {
                    System.out.println("Không tìm thấy file SQL khởi tạo!");
                    return;
                }
            }

            BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"));
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                // Bỏ qua comment
                String trimmed = line.trim();
                if (trimmed.startsWith("--") || trimmed.isEmpty()) continue;
                sb.append(line).append("\n");
            }
            br.close();

            // Thực thi từng statement (phân cách bằng dấu ;)
            String[] statements = sb.toString().split(";");
            Statement stmt = conn.createStatement();
            for (String sql : statements) {
                sql = sql.trim();
                if (!sql.isEmpty()) {
                    try {
                        stmt.execute(sql);
                    } catch (SQLException e) {
                        System.err.println("Lỗi SQL: " + sql);
                        System.err.println("  -> " + e.getMessage());
                    }
                }
            }
            stmt.close();
            System.out.println("Khởi tạo database thành công!");

        } catch (Exception e) {
            System.err.println("Lỗi khởi tạo database: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
