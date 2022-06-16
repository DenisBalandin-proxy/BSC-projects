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
    var delegateForNote: NoteViewControllerDelegate?
    var editingView = LayoutForEditingView()
    let listController = ListViewController()
    var completionOfCurrentCell: (() -> Void)?
    public var myButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editingView

        let myButton = UIBarButtonItem(
            title: "Готово",
            style: .plain,
            target: self,
            action: #selector(self.stopFocusing)
        )

        editingView.showButton = {
            self.navigationItem.rightBarButtonItem = myButton
        }
        view.backgroundColor = .systemGray5
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(stopFocusing),
            name: UIApplication.willTerminateNotification,
            object: nil
        )
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        editingView.setCurrentDate()
        navigationItem.rightBarButtonItem = myButton
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
            editingView.delegate = self
            editingView.prepareForSendData()
            let model = Storage()
            model.fillStorage()
            if !(model.title.isEmpty && model.text.isEmpty) {
                delegateForNote?.passData(title: model.title, text: model.text, date: model.date)
            }
            completionOfCurrentCell?()
        }
    }
    @objc func showButton() {
        navigationItem.rightBarButtonItem = myButton
    }
    @objc public func stopFocusing() {
        let model = Storage()
        editingView.delegate = self
        editingView.prepareForSendData()
        model.fillStorage()
        if model.empty == true {
            showEmptyNoteAlert(on: self)
        } else {
            navigationItem.rightBarButtonItem = nil
            editingView.resignFocus()
        }
    }
}
extension UIViewController {
    func showAlert(on viewController: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    func showEmptyNoteAlert (on viewController: UIViewController) {
        showAlert(on: viewController, with: "ERROR", message: "Your note is empty!")
    }
}
extension NoteViewController: LayoutDelegate {
    func sendDataFields(title: String, text: String, data: String) {
        let model = Storage()
        model.getValues(title1: title, text1: text, date1: data)
    }
}
