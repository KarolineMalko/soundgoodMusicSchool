package DTO;

public class StockInstrumentInfo {
    private int instrumentId;
    private String instrumentKind;
    private String instrumentBrand;
    private int price;



    public StockInstrumentInfo(int instrumentId, String instrumentKind, String instrumentBrand, int price) {
        this.instrumentId = instrumentId;
        this.instrumentKind = instrumentKind;
        this.instrumentBrand = instrumentBrand;
        this.price = price;
    }

    public int getInstrumentId() {
        return instrumentId;
    }

    public String getInstrumentKind() {
        return instrumentKind;
    }

    public String getInstrumentBrand() {
        return instrumentBrand;
    }

    public int getPrice() {
        return price;
    }
}
