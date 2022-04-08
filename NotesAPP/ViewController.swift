//
//  ViewController.swift
//  NotesAPP
//
//  Created by Jorel on 30/03/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private let textView = UITextView()
    private let defaults = UserDefaults.standard
    private let titleTextField = UITextField()
    private let myButton = UIBarButtonItem()

    private let mainTextView: UITextView = {
        let mainTextView = UITextView()
        mainTextView.translatesAutoresizingMaskIntoConstraints = false
        return mainTextView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        mainTextView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        titleTextField.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 22)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(save),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        let myButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(stopFocusing))

        titleTextField.placeholder = "Название заметки"

        mainTextView.text = defaults.string(forKey: "mainText")
        titleTextField.text = defaults.string(forKey: "topText")

        view.addSubview(mainTextView)
        view.addSubview(textView)
        view.addSubview(titleTextField)

        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = myButton
        setConstraints()
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        mainTextView.becomeFirstResponder()
    }

    private func setConstraints() {
        titleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true

        mainTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor).isActive = true
    }

    @objc func stopFocusing() {
        mainTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }

    @objc func save() {
        let mainText = mainTextView.text
        let topView = titleTextField.text
        defaults.set(topView, forKey: "topText")
        defaults.set(mainText, forKey: "mainText")
    }
}
