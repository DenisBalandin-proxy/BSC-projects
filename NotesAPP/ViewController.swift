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
private let textField = UITextField()
    
private let firstTitle = UITextField()
 
private let myButton = UIBarButtonItem()
private let titleField = UITextField()
private let mainTextView: UITextView = {
            
        let mainTextView = UITextView()
            mainTextView.translatesAutoresizingMaskIntoConstraints = false
            return mainTextView
            
            }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTextView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 14)
        firstTitle.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 22)
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(Save), name: UIApplication.willTerminateNotification, object: nil)
        
        let myButton = UIBarButtonItem(title: "Готово", style: .plain, target: self, action: #selector(stopFocusing))
        
        firstTitle.placeholder = "Название заметки"
        
        mainTextView.text = defaults.string(forKey: "mainText")
        firstTitle.text = defaults.string(forKey: "topText")
         
             view.addSubview(mainTextView)
             view.addSubview(titleField)
             view.addSubview(textView)
             view.addSubview(firstTitle)
       
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = myButton
        setConstraints()
        titleField.translatesAutoresizingMaskIntoConstraints = false
        firstTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTextView.becomeFirstResponder()
        
    }

    private func setConstraints(){
        
        firstTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        firstTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        firstTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        mainTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mainTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        mainTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        mainTextView.topAnchor.constraint(equalTo: firstTitle.bottomAnchor).isActive = true
        mainTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    }

    @objc func stopFocusing(){
        
        
        mainTextView.resignFirstResponder()
        firstTitle.resignFirstResponder()
    
    }
        
   @objc func Save(){
    
   let mainText = mainTextView.text
   let topView = firstTitle.text
   defaults.set(topView, forKey: "topText")
   defaults.set(mainText, forKey: "mainText")
    
    }
}

