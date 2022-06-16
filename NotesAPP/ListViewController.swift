//
//  ListViewController.swift
//  NotesAPP
//
//  Created by Jorel on 02/05/2022.
//  Copyright © 2022 Jorel. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    private var cellView = UIView()
    private var scrollView: UIScrollView = {
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
    private var button: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "createNewNote")
        button.setImage(image, for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createNote), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    override func viewDidLoad() {
        navigationItem.title = "Заметки"
        navigationController?.navigationBar.barTintColor = .systemGray5
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
        let model = Storage()
        model.getValues(title1: "", text1: "", date1: "")
        let noteController = NoteViewController()
        noteController.delegateForNote = self
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
        let viewFromSender = sender.view as? LayoutForList
        viewFromSender?.sendToModel()
        let noteController = NoteViewController()
        noteController.completionOfCurrentCell = {
            viewFromSender?.listenClouser()
        }
        navigationController?.pushViewController(noteController, animated: true)
    }
    private func createNoteInStack() {
        let layoutList = LayoutForList()
        layoutList.listenClouser()
        cellView = layoutList.setConstraintsForCell()
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.backgroundColor = .systemBackground
        cellView.layer.cornerRadius = 10
        stackView.addArrangedSubview(cellView)
        let gesture = UITapGestureRecognizer(
            target: self,
            action:
            #selector(self.tapOneAct(_:))
        )
        cellView.isUserInteractionEnabled = true
        cellView.addGestureRecognizer(gesture)
    }
}
extension ListViewController: NoteViewControllerDelegate {
    func passData(title: String, text: String, date: String) {
        let model = Storage()
        model.getValues(title1: title, text1: text, date1: date)
        createNoteInStack()
    }
}
