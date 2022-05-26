//
//  ViewController.swift
//  NotesAPP
//
//  Created by Jorel on 30/03/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

protocol NoteViewControllerDelegate: AnyObject {
    func passData(title: String, text: String, date: String)
}
class NoteViewController: UIViewController {
    typealias CompletionHandler = ([String: Any ]) -> Void
    var completion: CompletionHandler?
    var delegate: NoteViewControllerDelegate?

    let mainTextView: UITextView = {
        let mainTextView = UITextView()
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        mainTextView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        mainTextView.backgroundColor = .systemGray5
        return mainTextView
    }()
    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
        return titleTextField
    }()
    let datePickField: UILabel = {
        let datePickField = UILabel()
        datePickField.translatesAutoresizingMaskIntoConstraints = false
        datePickField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        return datePickField
    }()
    let date = Date()
    var holderDate = String()
    public let defaults = UserDefaults.standard
    public var myButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(stopFocusing),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
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
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(
            title: "<",
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(back)
        )
        self.navigationItem.leftBarButtonItem = backButton

        let myButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(stopFocusing))
        titleTextField.placeholder = "Название заметки"
        setCurrentDate()
        navigationItem.rightBarButtonItem = myButton
        setConstraints()
        let gesture = UITapGestureRecognizer(
            target: self,
            action:
            #selector(self.tapOnText(_:))
        )
        mainTextView.isUserInteractionEnabled = true
        mainTextView.addGestureRecognizer(gesture)
        mainTextView.becomeFirstResponder()
        titleTextField.addTarget(self, action: #selector(showButton), for: .touchDown)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            guard let name = titleTextField.text else { return }
            guard let subName = mainTextView.text else { return }
            guard let dateName = datePickField.text else { return }
            let dict = ["name": name, "subName": subName, "dateName": dateName]
            guard let completionBlock = completion else { return }
            completionBlock(dict)
        }
    }
    @objc func back() {
        if titleTextField.text == "" && mainTextView.text == "" {
        } else {
            delegate?.passData(
                title: titleTextField.text ?? "",
                text: mainTextView.text,
                date: datePickField.text ?? ""
            )
        }
        navigationController?.popViewController(animated: true)
    }
    @objc func keyboardControl(notification: Notification) {
        let userInfo = notification.userInfo!
        guard let keyboardScreenEndFrame = (
            userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            )?.cgRectValue else { return }
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            mainTextView.contentInset = UIEdgeInsets.zero
        } else {
            mainTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        mainTextView.scrollIndicatorInsets = mainTextView.contentInset
        let selectedRange = mainTextView.selectedRange
        mainTextView.scrollRangeToVisible(selectedRange)
    }
    func setConstraints() {
        let layoutView = Layout(mainText: mainTextView, title: titleTextField, dateField: datePickField)
        view.addSubview(layoutView)
        NSLayoutConstraint.activate([
            layoutView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            layoutView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            layoutView.rightAnchor.constraint(equalTo: view.rightAnchor),
            layoutView.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        mainTextView.becomeFirstResponder()
    }
    @objc func tapOnText(_ sender: UITapGestureRecognizer) {
        myButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(stopFocusing))
        navigationItem.rightBarButtonItem = myButton
        mainTextView.becomeFirstResponder()
    }
    @objc func showButton() {
        myButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(stopFocusing))
        navigationItem.rightBarButtonItem = self.myButton
    }
    func setCurrentDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy EEEE HH:mm:ss"
        holderDate = dateFormatter.string(from: date)
        datePickField.text = "\(holderDate)"
    }
    @objc public func stopFocusing() {
        let model = Storage()
        setCurrentDate()
        model.getValues(title1: titleTextField.text ?? "", text1: mainTextView.text, date1: datePickField.text ?? "")
        model.fillStorage()
        if model.empty == "Yes" {
            showEmptyNoteAlert(on: self)
        } else {
            navigationItem.rightBarButtonItem = nil
            datePickField.resignFirstResponder()
            titleTextField.resignFirstResponder()
            mainTextView.resignFirstResponder()
        }
    }
}
extension UIViewController {
    func showAlertt(on viewController: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    func showEmptyNoteAlert (on viewController: UIViewController) {
        showAlertt(on: viewController, with: "ERROR", message: "Your note is empty!")
    }
}
