//
//  Model.swift
//  NotesAPP
//
//  Created by Jorel on 20/04/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

final class Storage {
    var title = String()
    var date = String()
    var text = String()
    let defaults = UserDefaults.standard
    func getGet(title1: String, text1: String, date1: String) {
        let mainText = text1
        let topView = title1
        let dateField = date1
        defaults.set(topView, forKey: "topText")
        defaults.set(mainText, forKey: "mainText")
        defaults.set(dateField, forKey: "dateField")
    }
    func fillStorage() {
        title = defaults.string(forKey: "topText") ?? ""
        text = defaults.string(forKey: "mainText") ?? ""
        date = defaults.string(forKey: "dateField") ?? ""
    }
    var emptiness = String()
    var empty: String {
        if title == "" && text == "" {
            emptiness = "Yes"
        }
        return emptiness
    }
}
