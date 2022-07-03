//
//  Constants.swift
//  BuyList
//
//  Created by Lyudmila Tokar on 4/15/21.
//

struct K {
    
    static let appTitle = "Family Buy List"
    static let titleForList = "Need to Byu"
    static let registerSegueId = "RegisterToList"
    static let logInSegueId = "LogInToList"
    static let cellId = "ReusableCell"
    static let cellNibName = "ListCell"
    
    struct BrandColor {
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
        static let greenBlue = "BrandBlueGreen"
    }
    
    struct FSStore {
        static let collectionName = "list"
        static let senderField = "sender"
        static let itemNameField = "item"
        static let checkMarkField = "doneMark"
        static let dateField = "date"
    }
}
