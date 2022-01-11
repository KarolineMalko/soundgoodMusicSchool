package Model;

import DTO.StockInstrumentInfo;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Stock {
    private static Connection connection;
    private ArrayList<StockInstrumentInfo> stockInstrumentInfo;

    public Stock (Connection connection) {
        Stock.connection = connection;
    }

    public String getAvailableInstrumentsInStock() throws SQLException {


            String sql = "SELECT\tinstrument.id\n, instrument.kind\n, instrument.brand\n, instrument.price\n" +
                    "FROM\tstock LEFT JOIN instrument ON stock.instrument_id = instrument.id\n" +
                    "WHERE\tstock.instruments_quantity > 0 ";

            ArrayList<StockInstrumentInfo> stockInstrumentInfo = fillStockInstInfo(getResultsFromQuery(sql, 1), getResultsFromQuery(sql, 2), getResultsFromQuery(sql, 3), getResultsFromQuery(sql, 4));
            String stockInstrumentsAsList = arrayListToString(stockInstrumentInfo);
            return stockInstrumentsAsList;

    }


    public ArrayList<StockInstrumentInfo> fillStockInstInfo(ArrayList<String> instrumentsId, ArrayList<String> instrumentsKind, ArrayList<String> instrumentsBrand, ArrayList<String> instrumentsPrice){
       ArrayList<StockInstrumentInfo> StockInstruments = new ArrayList<>();
       int numberOfInstrumentKind = instrumentsKind.size();
       for(int i = 0; i < numberOfInstrumentKind; i++){
           int instrumentId = Integer.parseInt(instrumentsId.get(i));
           int instrumentPrice = Integer.parseInt(instrumentsPrice.get(i));
           StockInstrumentInfo stockInstrument = new StockInstrumentInfo(instrumentId, instrumentsKind.get(i), instrumentsBrand.get(i), instrumentPrice);
           StockInstruments.add(stockInstrument);
        }
       return StockInstruments;
    }

    public ArrayList<String> getResultsFromQuery(String query, int columNum) throws SQLException {
        try{
            Statement statement = connection.createStatement();
            ResultSet resultQueryInstrument = statement.executeQuery(query);
            connection.commit();
            ArrayList<String> resultsArray = new ArrayList<>();
            while (resultQueryInstrument.next() == true) {
                resultsArray.add(resultQueryInstrument.getString(columNum));
                //System.out.println("the data is returned from data base");
                //String instrumentKind = resultQueryInstrument.getString(1);
                //System.out.println(instrumentKind);
            }
            return resultsArray;
        }catch (Exception e) {
            System.out.print("No Data has been returned from the update query");
        }
        return new ArrayList<>();
    }

    public String arrayListToString(ArrayList<StockInstrumentInfo> result) {

        StringBuilder sb = new StringBuilder();
        sb.append(String.format("%-20s%-20s%-20s%-70s\n","ID","Kind","Brand","Rental Price")) ;
        for (int i=0; i < result.size(); i++) {
            sb.append(result.get(i).getInstrumentId());
            sb.append("                 ");
            sb.append(result.get(i).getInstrumentKind());
            sb.append("             ");
            sb.append(result.get(i).getInstrumentBrand());
            sb.append("                         ");
            sb.append(result.get(i).getPrice());
            sb.append("\n");
        }
        String str = sb.toString();
        return str;

    }
}
