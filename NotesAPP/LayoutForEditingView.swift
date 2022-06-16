//
//  LayoutForEditingView.swift
//  NotesAPP
//
//  Created by Jorel on 18/04/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

protocol LayoutDelegate: AnyObject {
    func sendDataFields(title: String, text: String, data: String)
}
class LayoutForEditingView: UIView {
    var delegate: LayoutDelegate?
    var note: Storage? {
        didSet {
            note?.fillStorage()
            titleTextField.text = note?.title
            mainTextView.text = note?.text
            datePickField.text = note?.date
        }
    }
    private let mainTextView: UITextView = {
        let mainTextView = UITextView()
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        mainTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        mainTextView.backgroundColor = .systemGray5
        return mainTextView
    }()
    private let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.placeholder = "Заголовок заметки"
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        return titleTextField
    }()
    private let datePickField: UILabel = {
        let datePickField = UILabel()
        datePickField.translatesAutoresizingMaskIntoConstraints = false
        datePickField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        return datePickField
    }()
    var buttonCallBackAction : (() -> Void)?
    var showButton: (() -> Void)?
    let date = Date()
    var holderDate = String()
    let listController = ListViewController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.firstInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.firstInit()
    }
    private func firstInit() {
        note = Storage()
        createConstraints()
        setGesture()
        setNotifications()
    }
    private func createConstraints() {
        addSubview(mainTextView)
        addSubview(titleTextField)
        addSubview(datePickField)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        datePickField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            mainTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            mainTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            mainTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleTextField.topAnchor.constraint(equalTo: datePickField.bottomAnchor, constant: 12),
            titleTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            titleTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            datePickField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 5),
            datePickField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            datePickField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20)
        ])
        datePickField.textAlignment = .center
    }
    func prepareForSendData() {
        setCurrentDate()
        delegate?.sendDataFields(
            title: titleTextField.text ?? "",
            text: mainTextView.text,
            data: datePickField.text ?? ""
        )
    }
    func setCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "MM.dd.yyyy EEEE HH:mm:ss"
        holderDate = dateFormatter.string(from: date)
        datePickField.text = "\(holderDate)"
    }
    func resignFocus() {
        datePickField.resignFirstResponder()
        titleTextField.resignFirstResponder()
        mainTextView.resignFirstResponder()
    }
    private func setGesture() {
        let gesture = UITapGestureRecognizer(
            target: self,
            action:
            #selector(tapOnText(_:))
        )
        mainTextView.isUserInteractionEnabled = true
        mainTextView.addGestureRecognizer(gesture)
        mainTextView.becomeFirstResponder()
        titleTextField.addTarget(self, action: #selector(showButtonOnNavigationBar), for: .touchDown)
    }
    private func setNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardControl),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardControl),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    @objc private func keyboardControl(notification: Notification) {
        let userInfo = notification.userInfo!
        guard let keyboardScreenEndFrame = (
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            )?.cgRectValue else { return }
        let keyboardViewEndFrame = self.convert(keyboardScreenEndFrame, from: self.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            mainTextView.contentInset = UIEdgeInsets.zero
        } else {
            mainTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        mainTextView.scrollIndicatorInsets = mainTextView.contentInset
        let selectedRange = mainTextView.selectedRange
        mainTextView.scrollRangeToVisible(selectedRange)
    }
    @objc private func showButtonOnNavigationBar() {
        showButton?()
    }
    @objc private func tapOnText(_ sender: UITapGestureRecognizer) {
        showButton?()
        mainTextView.becomeFirstResponder()
    }
}
