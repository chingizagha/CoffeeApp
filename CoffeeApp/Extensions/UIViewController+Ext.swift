//
//  UIViewController+Ext.swift
//  CoffeeApp
//
//  Created by Chingiz on 02.04.24.
//

import UIKit
import SafariServices

extension UIViewController {
    
    func presentSafariVC(with url: URL){
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .systemGreen
        present(safariVC, animated: true)
    }
    
}
