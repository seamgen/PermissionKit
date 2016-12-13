//
//  PermissionViewController.swift
//  PermissionKit
//
//  Created by Sam Gerardi on 12/13/16.
//  Copyright © 2016 Seamgen. All rights reserved.
//

import UIKit
import PermissionKit


class PermissionViewController: UIViewController {
    
    // MARK: Properties
    
    let permission: RequestablePermission
    
    
    // MARK: Object Lifecycle
    
    public init(_ permission: RequestablePermission, _ title: String) {
        self.permission = permission
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Lifecycle
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        
        stackView.addArrangedSubview(permissionStatusLabel)
        stackView.addArrangedSubview(hasBeenRequestedLabel)
        stackView.addArrangedSubview(requestButton)
        view.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    
    // MARK: Methods
    
    @objc private func requestButtonTapped() {
        permission.request { status in
            self.updateUI()
        }
    }
    
    private func updateUI() {
        permissionStatusLabel.text = permission.status.description
        hasBeenRequestedLabel.text = "Has been requested: \(permission.hasBeenRequested.description)"
        requestButton.isEnabled = !permission.hasBeenRequested
    }
    
    
    // MARK: Controls
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private(set) lazy var permissionStatusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var hasBeenRequestedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private(set) lazy var requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("Request Permission", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(requestButtonTapped), for: .touchUpInside)
        return button
    }()
}

