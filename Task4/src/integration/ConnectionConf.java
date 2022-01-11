package integration;

import java.sql.Connection;
import java.sql.DriverManager;

public class ConnectionConf {

    // Connect to the database
    public static Connection getConnection() {
        try {
            Class.forName("org.postgresql.Driver");
            Connection connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/soundgoodMusicSchool", "postgres", "postgres");
            connection.setAutoCommit(false);
            System.out.println("the connection is successed");
            return connection;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
