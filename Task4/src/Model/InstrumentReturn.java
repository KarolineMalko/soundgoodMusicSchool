package Model;

import DTO.InstrumentRentalInfo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class InstrumentReturn {
    private static Connection connection;

    public InstrumentReturn (Connection connection) {
        InstrumentReturn.connection = connection;
    }

    public static String showRentledInstrument(int studentId) throws SQLException {
        String showRentedInstrumentIdQuery =    "SELECT student_id, instrument_id, kind, brand\n" +
                "FROM instrument_rental LEFT JOIN instrument ON instrument_rental.instrument_id = instrument.id\n" +
                "WHERE student_id = " + studentId + " AND terminated = false";

        ArrayList<InstrumentRentalInfo> instrumentRentalInfos = fillInstrumentRentalInfo(getResultsFromQuery(showRentedInstrumentIdQuery, 1), getResultsFromQuery(showRentedInstrumentIdQuery, 2), getResultsFromQuery(showRentedInstrumentIdQuery, 3));
        String instrumentRentedId = arrayListToString(instrumentRentalInfos);
        return instrumentRentedId;
    }

    public static void returnInstrument(int instrumentId, int studentId) throws Exception {

        String checkStudentRentedInsLimit = "SELECT rented_instrument_amount " +
                                            "FROM  student " +
                                            "WHERE  id = "+ studentId;

        String makeTerminatedTrueQuery =    "UPDATE public.instrument_rental " +
                                            "SET terminated= true " +
                                            "WHERE instrument_id= " + instrumentId + " and student_id = " + studentId + ";";
        String decreaseRentedInstrumentsAmoutQuery =  "UPDATE public.student " +
                                                    " SET rented_instrument_amount = rented_instrument_amount - 1 " +
                                                    " WHERE id = "+ studentId +";";
        String increasestockQuanQuery = "UPDATE public.stock " +
                                        " SET instruments_quantity = instruments_quantity +1 " +
                                        " WHERE instrument_id = "+ instrumentId +";";

        try {
            int checkRenatlLim = Integer.parseInt(getResultsFromQuery(checkStudentRentedInsLimit, 1).get(0));
            if (checkRenatlLim > 0) {
                getResultsFromQuery(makeTerminatedTrueQuery);
                getResultsFromQuery(decreaseRentedInstrumentsAmoutQuery);
                getResultsFromQuery(increasestockQuanQuery);
            }else{
                System.out.println("the student has no rented instruments!");
            }
        }catch (Exception e) {
            connection.rollback();
            throw new ExeptionForDataBase("commit to database has failed " + e.getMessage());
        }

    }




    public static ArrayList<InstrumentRentalInfo> fillInstrumentRentalInfo(ArrayList<String> studentsId, ArrayList<String> instrumentsId, ArrayList<String> instrumentsKind){
        ArrayList<InstrumentRentalInfo> rentedInstrumentinfo = new ArrayList<>();
        int numberOfstudents = studentsId.size();
        if(numberOfstudents != 0) {
            for (int i = 0; i < numberOfstudents; i++) {
                int studentId = Integer.parseInt(studentsId.get(i));
                int instrumentId = Integer.parseInt(instrumentsId.get(i));
                String instrumentKind = instrumentsKind.get(i);
                InstrumentRentalInfo instrumentRentalInfo = new InstrumentRentalInfo(studentId, instrumentId, instrumentKind);
                //InstrumentRentalInfo rentedInstrument = new InstrumentRentalInfo(instrumentId);
                rentedInstrumentinfo.add(instrumentRentalInfo);
            }
        }else{
            System.out.println("the chosen student has not rented any instruments!");
        }
        return rentedInstrumentinfo;
    }

    public static ArrayList<String> getResultsFromQuery(String query, int columNum) throws SQLException {
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
            //System.out.print("No Data has been returned from the update query");
            e.printStackTrace();
        }
        return new ArrayList<>();
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


    public static String arrayListToString(ArrayList<InstrumentRentalInfo> result) {

        StringBuilder sb = new StringBuilder();
        //sb.append(String.format("%-20s","Instruments IDs: ")) ;
        for (int i=0; i < result.size(); i++) {
            sb.append("Student id: ");
            sb.append(result.get(i).getStudentId());
            sb.append("\n");
            sb.append("Instrument id: " );
            sb.append(result.get(i).getInstrumentId());
            sb.append("\n");
            sb.append("Instrument kind: ");
            sb.append(result.get(i).getInstrumentKind());
            sb.append("\n");
            sb.append("");
        }
        String str = sb.toString();
        return str;

    }
}
