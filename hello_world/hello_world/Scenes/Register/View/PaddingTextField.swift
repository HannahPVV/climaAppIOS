//
//  PaddingTextFiels.swift
//  hello_world
//
//  Created by Hannah Valencia on 04/05/26.
//
import UIKit

class PaddingTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40)

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
