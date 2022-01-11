package Model;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class InstrumentRental {
    private static Connection connection;

    public InstrumentRental (Connection connection) {
        InstrumentRental.connection = connection;
    }

    public static void createNewInstrumentRentalInstance(int instrumentId, int studentId, String rentalMethod) throws ExeptionForDataBase, SQLException {


        String checkStudentRentedInsLimit = "SELECT rented_instrument_amount " +
                                            "FROM  student " +
                                            "WHERE  id = "+ studentId;
        String checkInsQuanInStock = "SELECT instruments_quantity " +
                                     "FROM stock " +
                                     "WHERE instrument_id = "+ instrumentId;

        String NewInstrumentRentalQuery = "INSERT INTO public.instrument_rental(\n" +
                "instrument_id, student_id, rental_date, return_date, rental_period, delivery_method, terminated)\n" +
                "VALUES (" + instrumentId + ", " + studentId + ", CURRENT_DATE, CURRENT_DATE + interval '2 months', 12, \'" + rentalMethod +"\', false)";

        String updateInstQuanInStockQuery = "UPDATE public.stock " +
                                            "SET instruments_quantity =  instruments_quantity - 1 " +
                                            "WHERE instrument_id = " + instrumentId +" and  instruments_quantity > 0 ";

        String updateStudentRentedInstAmountQuery = "UPDATE public.student " +
                                                    "SET rented_instrument_amount  =  rented_instrument_amount + 1 " +
                                                    "WHERE id = " + studentId + " and rented_instrument_amount < 2";


        try{
            int checkRenatlLim = Integer.parseInt(getResultsFromQueryreAsArray(checkStudentRentedInsLimit, 1).get(0));
            int checkInstrmentQuantity = Integer.parseInt(getResultsFromQueryreAsArray(checkInsQuanInStock, 1).get(0));
            if( checkRenatlLim < 2 && checkInstrmentQuantity > 0 ) {
                getResultsFromQuery(NewInstrumentRentalQuery);
                getResultsFromQuery(updateInstQuanInStockQuery);
                getResultsFromQuery(updateStudentRentedInstAmountQuery);
            }
            else{
                System.out.println("limit rented instruments");
            }
        }catch (Exception e) {
            connection.rollback();
            throw new ExeptionForDataBase("commit to database has failed " + e.getMessage());
        }
    }


    public static void getResultsFromQuery(String query) throws ExeptionForDataBase, Exception {
        try{
            Statement statement = connection.createStatement();
            statement.executeUpdate(query);
            connection.commit();

        }catch (Exception e) {
            throw new ExeptionForDataBase("commit to database has failed " + e.getMessage());
           // e.printStackTrace();
        }
    }

    public static ArrayList<String> getResultsFromQueryreAsArray(String query, int columNum) throws SQLException {
        try{
            Statement statement = connection.createStatement();
            ResultSet resultQueryInstrument = statement.executeQuery(query);
            connection.commit();
            ArrayList<String> resultsArray = new ArrayList<>();
            while (resultQueryInstrument.next() == true) {
                resultsArray.add(resultQueryInstrument.getString(columNum));
            }
            return resultsArray;
        }catch (Exception e) {
            System.out.print("No Data has been returned from the update query");
        }
        return new ArrayList<>();
    }
}
