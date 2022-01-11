package Controller;

import Model.ExeptionForDataBase;
import Model.InstrumentRental;
import Model.InstrumentReturn;
import Model.Stock;

import java.sql.Connection;
import java.sql.SQLException;

public class Controller {
    Connection connection;
    Stock stock;
    InstrumentRental instrumentRental;
    InstrumentReturn instrumentReturn;


    public Controller(Connection connection) {
        this.connection = connection;
        stock = new Stock(connection);
        instrumentRental = new InstrumentRental(connection);
        instrumentReturn = new InstrumentReturn(connection);
    };



    public String printAvailabInsInStock() throws SQLException {
        try {
            return stock.getAvailableInstrumentsInStock();
        }catch (Exception e){
            e.printStackTrace();
        }
        return "";
    }
    public void rentalInstrument(int instrumentId, int studentId, String rentalMethod){
        try{
            if(rentalMethod != "") {
                InstrumentRental.createNewInstrumentRentalInstance(instrumentId, studentId, rentalMethod);
                System.out.println("the rental has been successfully entered!");
            }else {
                System.out.println("choose a delivery method!");
            }

        }catch (ExeptionForDataBase | SQLException e){

            System.out.println("check the student id and the instrument id!");
            //e.printStackTrace();
        }
    }
    public String printRentedInstrument(int studentId) throws SQLException {
        try {
            return InstrumentReturn.showRentledInstrument(studentId);

        }catch (Exception e){
            System.out.println("chose the student id between 1 and 30!");
            //e.printStackTrace();
        }
        return "";
    }
    public void returnInstrument(int instrumentId, int studentId){
        try {
             InstrumentReturn.returnInstrument(instrumentId,studentId);
            System.out.println("the instrument has successfully returned ");
        }catch (Exception e){
            System.out.println("the instrument has NOT been rented successfully");
            //e.printStackTrace();
        }
    }

    public void closeConnection() {
        try {
            connection.close();
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }
    public void rollback() throws SQLException {
        connection.rollback();
    }
}
