//
//  ListViewController.swift
//  NotesAPP
//
//  Created by Jorel on 02/05/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    var infoViews = UIView()
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private var stackView: UIStackView = {
        let verticalFirstStackView = UIStackView()
        verticalFirstStackView.axis = .vertical
        verticalFirstStackView.alignment = .fill
        verticalFirstStackView.distribution = .fillEqually
        verticalFirstStackView.spacing = 4
        verticalFirstStackView.translatesAutoresizingMaskIntoConstraints = false
        return verticalFirstStackView
    }()
    lazy var button: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "type=Add")
        button.setImage(image, for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createNote), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        navigationItem.title = "Заметки"
        navigationController?.navigationBar.barTintColor = .systemGray5
        infoViews.translatesAutoresizingMaskIntoConstraints = false
        setupViews()
        setupLayout()
    }
    @objc private func setupViews() {
        view.backgroundColor = .systemGray5
        scrollView.backgroundColor = .systemGray5
        contentView.backgroundColor = .systemGray5
        stackView.backgroundColor = .systemGray5
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        view.addSubview(button)
    }
    @objc private func createNote() {
        let noteController = NoteViewController()
        noteController.delegate = self
        navigationController?.pushViewController(noteController, animated: true)
    }
    private func setupLayout() {
        NSLayoutConstraint.activate([
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -69),
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
    @objc func tapOneAct(_ sender: UITapGestureRecognizer) {
        let noteController = NoteViewController()
        let getView = sender.view
        guard let label1 = getView?.subviews[0] as? UILabel else { return }
        guard let label2 = getView?.subviews[1] as? UILabel else { return }
        guard let label3 = getView?.subviews[2] as? UILabel else { return }
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false

        noteController.titleTextField.text = label2.text
        noteController.mainTextView.text = label1.text
        noteController.datePickField.text = label3.text

        noteController.completion = { dict in
            label2.text = dict["name"] as? String
            label1.text = dict["subName"] as? String
            label3.text = dict["dateName"] as? String
        }
        navigationController?.pushViewController(noteController, animated: true)
    }
    private func createNoteInStack() {
        let layoutList = LayoutForList()
        infoViews = layoutList.setCon()
        infoViews.translatesAutoresizingMaskIntoConstraints = false
        infoViews.backgroundColor = .systemBackground
        infoViews.layer.cornerRadius = 10
        stackView.addArrangedSubview(infoViews)
        let gesture = UITapGestureRecognizer(
            target: self,
            action:
            #selector(self.tapOneAct(_:))
        )
        infoViews.isUserInteractionEnabled = true
        infoViews.addGestureRecognizer(gesture)
    }
}
extension ListViewController: NoteViewControllerDelegate {
    func passData(title: String, text: String, date: String) {
        let model = Storage()
        model.getValues(title1: title, text1: text, date1: date)
        createNoteInStack()
    }
}
