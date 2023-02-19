//
//  personModel.swift
//  slot-game
// Created by
//  Sriskandarajah Sayanthan  301279325.
//  Neha Patel  301280513
//  Rutvik Lathiya 301282022
import Foundation
import CoreData

struct personModel {

    let int : Float
    let name : String
    

    init(int:Float, name:String) {
        self.int = int
        self.name = name
        
    }
}


    struct Stop {
       var name: String;
       var int: Float ;
    }

    class Favourite: NSManagedObject {

        @NSManaged var name: String
        @NSManaged var int: Float

        var stop : Stop {
           get {
                return Stop(name: self.name, int: self.int)
            }
            set {
                self.name = newValue.name
                self.int = newValue.int
            }
         }
    }
