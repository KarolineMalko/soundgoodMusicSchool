package View;

import Controller.Controller;
import Model.ExeptionForDataBase;

import java.sql.SQLException;
import java.util.Scanner;

public class View {

    Controller controller;

    public View(Controller controller) {
        this.controller = controller;
    }

    public void startInterface() throws SQLException, ExeptionForDataBase {

        String chooseOptionsText = "Welcome to the SoundGood Music school:\n" +
                "Enter the number of the category you want to enter: \n" +
                "1: Show the available instruments in the stock.\n" +
                "2: Show the current rented instrument for the special student.\n" +
                "3: rent an instrument.\n" +
                "4: return an instrument.\n" +
                "5: To exit.";
        System.out.println(chooseOptionsText);
        Scanner scan = new Scanner(System.in);
        boolean run = true;
        while (run) {
            System.out.println("Chose what to do:");

            switch (scan.nextInt()) {
                case 1:
                    System.out.println(controller.printAvailabInsInStock());
                    break;

                case 2:
                    System.out.println("Enter the student id you want to se their rented instruments: /student ids between 1 and 30/ ");
                    int studentId = scan.nextInt();
                    System.out.println(controller.printRentedInstrument(studentId));
                    break;

                case 3:
                    try {
                        System.out.println("Enter the student id: ");
                        int studentrentId = scan.nextInt();
                        System.out.println("Enter the instrument id:  /1-6/");
                        int instrumentRnetId = scan.nextInt();
                        System.out.println("chose the deliveryMethod: 1: Pick up or  2: Deliver to house ");
                        int deliverMethod = scan.nextInt();
                        if (deliverMethod == 1) {
                            controller.rentalInstrument(instrumentRnetId, studentrentId, "Pick up");
                        }
                        controller.rentalInstrument(instrumentRnetId, studentrentId, "Deliver to house");
                        break;
                    }catch (Exception e){
                        System.out.println("something went wrong, try again later!");
                    }


                case 4:
                    System.out.println("You can check the students and their rented instruments from alternative 2:");
                    System.out.println("Enter the student id: ");
                    int studentReturnId = scan.nextInt();
                    System.out.println("Enter the instrument id:  /1-6/");
                    int instrumentReturnId = scan.nextInt();
                    controller.returnInstrument(instrumentReturnId, studentReturnId);

                    break;

                case 5:
                    run = false;
                    controller.closeConnection();

            }

        }
    }
}
