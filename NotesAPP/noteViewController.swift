//
//  ViewController.swift
//  NotesAPP
//
//  Created by Jorel on 30/03/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

final class noteViewController: UIViewController {
    
    
    
    var model: Model? {
        
        didSet {
            
            guard let model = model else {return}
            self.mainTextView.text = model.text
            self.titleTextField.text = model.title
            self.datePickField.text = model.date
        }
    }


        let date = Date()
    var holderDate = String()
  //  let model = Model()
 let mainTextView: UITextView = {
            
        let mainTextView = UITextView()
            mainTextView.translatesAutoresizingMaskIntoConstraints = false
            return mainTextView
            }()
    
    let titleTextField: UITextField = {
         let titleTextField = UITextField()
         titleTextField.translatesAutoresizingMaskIntoConstraints = false
         return titleTextField
     }()

    let datePickField = UITextField()
    public let defaults = UserDefaults.standard
    public let myButton = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        

    }
        
        
         public func setCurrentDate() {
               // var a = String()
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "MMMM d, YYYY"
               holderDate = dateFormatter.string(from: date)
               datePickField.placeholder = "\(holderDate)"
           }

        
    override func loadView() {
       self.view = Lauout()
        
        
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

         self.titleTextField.placeholder = "Название заметки"

                setCurrentDate()

                if datePickField.text != nil || datePickField.text != "" {
                   datePickField.text = defaults.string(forKey: "dateField")
                }

                mainTextView.text = defaults.string(forKey: "mainText")
                titleTextField.text = defaults.string(forKey: "topText")
                navigationItem.rightBarButtonItem = myButton
                mainTextView.becomeFirstResponder()
          view().setConstraints()
    }
    
    
    func view() -> Lauout {
       return self.view as! Lauout
    }
    
    @objc public func stopFocusing() {
            save()
            mainTextView.text = defaults.string(forKey: "mainText")
            titleTextField.text = defaults.string(forKey: "topText")

            var emptyCck = EmptyCheck()
            emptyCck.empty = mainTextView.text
            let val1 = emptyCck.empty
            emptyCck.empty = titleTextField.text
            let val2 = emptyCck.empty

            if val1 == "Yes" && val2 == "Yes" {
                showEmptyNoteAlert(on: self)
            } else {
                mainTextView.resignFirstResponder()
                titleTextField.resignFirstResponder()
            }
        }

        @objc func save() {
            let mainText = mainTextView.text
            let topView = titleTextField.text
            let dateField = datePickField.text
            defaults.set(topView, forKey: "topText")
            defaults.set(mainText, forKey: "mainText")
            defaults.set(dateField, forKey: "dateField")
        }

        @objc func cancelAction() {
            self.datePickField.resignFirstResponder()
        }

        @objc public func doneAction() {
            if let datePickerView = datePickField.inputView as? UIDatePicker {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, YYY"
                let dateString = dateFormatter.string(from: datePickerView.date)
                datePickField.text = dateString
                datePickField.resignFirstResponder()
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

extension UITextField {
    func datePicker<T>(
        targer: T,
        doneAction: Selector,
        cancelAction: Selector,
        datePickerMode: UIDatePicker.Mode = .date
    ) {
        let screenWidth = UIScreen.main.bounds.width
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : targer
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(
                barButtonSystemItem: style,
                target: buttonTarget,
                action: action
            )
            return barButtonItem
        }

        let datePicker = UIDatePicker(frame: CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: 216
        ))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(
            x: 0,
            y: 0,
            width: screenWidth,
            height: 44
        ))
        toolBar.setItems(
            [buttonItem(withSystemItemStyle: .cancel),
             buttonItem(withSystemItemStyle: .flexibleSpace),
             buttonItem(withSystemItemStyle: .done)],
            animated: true
        )
        self.inputAccessoryView = toolBar
    }
}

    