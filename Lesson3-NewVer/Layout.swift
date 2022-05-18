//  Lauout.swift
//  NotesAPP
//
//  Created by Jorel on 18/04/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

class Layout: UIView {
    init(mainText: UITextView, title: UITextField, dateField: UILabel) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        mainText.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(mainText)
        self.addSubview(title)
        self.addSubview(dateField)
        title.translatesAutoresizingMaskIntoConstraints = false
        dateField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainText.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            mainText.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            mainText.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            mainText.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            title.topAnchor.constraint(equalTo: dateField.bottomAnchor, constant: 12),
            title.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            dateField.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            dateField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            dateField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20)
        ])
        dateField.textAlignment = .center
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
