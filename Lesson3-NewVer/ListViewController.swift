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
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        button.setTitle("  +  ", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .regular)
        button.backgroundColor = UIColor(red: 0, green: 0.478, blue: 1, alpha: 1)
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
        tapOneAct(gesture)
    }
    private func setupLayout() {
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -69).isActive = true
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
    }
    @objc func tapOneAct(_ sender: UITapGestureRecognizer) {
        let noteController = NoteViewController()
        let model = Storage()
        let getView = sender.view
        guard let label1 = getView?.subviews[0] as? UILabel else { return }
        guard let label2 = getView?.subviews[1] as? UILabel else { return }
        guard let label3 = getView?.subviews[2] as? UILabel else { return }
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        model.getGet(title1: label2.text ?? "", text1: label1.text ?? "", date1: label3.text ?? "")

        noteController.completion = { dict in
            label2.text = dict["name"] as? String
            label1.text = dict["subName"] as? String
            label3.text = dict["dateName"] as? String
        }
        navigationController?.pushViewController(noteController, animated: true)
    }
}
