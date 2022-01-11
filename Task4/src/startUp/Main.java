package startUp;

import Controller.Controller;
import Model.ExeptionForDataBase;
import View.View;
import integration.ConnectionConf;

import java.sql.Connection;
import java.sql.SQLException;

public class Main {
    public static void main(String[] args) throws SQLException, ExeptionForDataBase {
        Connection connection = ConnectionConf.getConnection();
        Controller controller = new Controller(connection);
        View view = new View(controller);
        view.startInterface();
    }

}
