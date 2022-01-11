package DTO;

public class InstrumentRentalInfo {
    private int instrumentId;
    private int studentId;
    private String instrumentKind;


    public InstrumentRentalInfo(int studentId, int instrumentId, String instrumentKind){
        this.studentId = studentId;
        this.instrumentId = instrumentId;
        this.instrumentKind = instrumentKind;
    }

    public int getInstrumentId() {
        return instrumentId;
    }

    public int getStudentId() {
        return studentId;
    }

    public String getInstrumentKind() {
        return instrumentKind;
    }
}
