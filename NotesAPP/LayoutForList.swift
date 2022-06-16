//
//  LayoutForList.swift
//  NotesAPP
//
//  Created by Jorel on 02/05/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

class LayoutForList: UIView {
    private let dateLabel = UILabel()
    private let titleLabel = UILabel()
    private let textLabel = UILabel()
    private let model = Storage()
    var fromModelToCell: Storage? {
        didSet {
            fromModelToCell?.fillStorage()
            titleLabel.text = fromModelToCell?.title
            textLabel.text = fromModelToCell?.text
            dateLabel.text = fromModelToCell?.date
        }
    }
    func listenClouser() {
        self.fromModelToCell = Storage()
    }
    func setConstraintsForCell() -> UIView {
        titleLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 18)
        textLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        dateLabel.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 10)
        textLabel.textColor = .systemGray
        self.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textLabel)
        self.addSubview(titleLabel)
        self.addSubview(dateLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 32),
            textLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            textLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 24),
            dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
        return self
    }
    func sendToModel() {
        model.getValues(title1: titleLabel.text ?? "", text1: textLabel.text ?? "", date1: dateLabel.text ?? "")
    }
}
