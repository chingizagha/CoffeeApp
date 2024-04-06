//
//  DetailViewController.swift
//  CoffeeApp
//
//  Created by Chingiz on 01.04.24.
//

import UIKit

class DetailViewController: UIViewController {
    
    let place: PlaceAnnotation
    
    let mainStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .vertical
        view.spacing = UIStackView.spacingUseSystem
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let contactStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = UIStackView.spacingUseSystem
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .label
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.alpha = 0.4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let directionButton: UIButton = {
//        var config = UIButton.Configuration.bordered()
//        let button = UIButton(configuration: config)
//        button.setTitle("Direction", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let callButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setTitle("Call", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let websiteButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        let button = UIButton(configuration: config)
        button.setTitle("Website", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        layoutUI()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        websiteButton.addTarget(self, action: #selector(didTapWebsiteButton), for: .touchUpInside)
        
    }
    
    @objc
    private func didTapWebsiteButton() {
        guard let url = place.websiteURL else {
            let alert = UIAlertController(title: "Something went wrong", message: "URL is wrong", preferredStyle: .alert)
            present(alert, animated: true)
            return
        }
        
        presentSafariVC(with: url)
    }
    
    private func layoutUI(){
        
        mainStackView.addArrangedSubview(nameLabel)
        mainStackView.addArrangedSubview(addressLabel)
        //contactStackView.addArrangedSubview(directionButton)
        contactStackView.addArrangedSubview(callButton)
        contactStackView.addArrangedSubview(websiteButton)
        mainStackView.addArrangedSubview(contactStackView)
        view.addSubviews(mainStackView)
        
        if place.phone.isEmpty {
            callButton.isEnabled = false
        }
        
        if place.websiteURL == nil {
            websiteButton.isEnabled = false
        }
        
        
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 20)
        ])
    }
    
    private func configure() {
        nameLabel.text = place.name
        addressLabel.text = place.address
    }
    


}
