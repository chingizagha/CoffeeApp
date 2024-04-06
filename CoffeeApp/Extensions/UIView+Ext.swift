//
//  UIView+Ext.swift
//  CoffeeApp
//
//  Created by Chingiz on 01.04.24.
//

import UIKit

extension UIView{
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}
