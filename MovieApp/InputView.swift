//
//  InputView.swift
//  MovieApp
//
//  Created by endava-bootcamp on 27.03.2023..
//

import UIKit
import PureLayout

class InputView: UIView {
    let label = UILabel()
    var labelText: String
    let inputField = UITextField()
    var inputFieldDefaultText: String
    
    let textColor = UIColor(red: 76/255, green: 178/255, blue: 223/255, alpha: 1)
    let inputPadding = 16
    
    init(label labelText: String, placeholder inputFieldDefaultText: String) {
        self.labelText = labelText
        self.inputFieldDefaultText = inputFieldDefaultText
        super.init(frame: .zero)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        self.labelText = ""
        self.inputFieldDefaultText = ""
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        createViews()
        style()
        layout()
    }
    
    private func createViews() {
        self.addSubview(label)
        self.addSubview(inputField)
        
        label.text = labelText
        let placeholder = NSAttributedString(string: inputFieldDefaultText,
                                             attributes: [NSAttributedString.Key.foregroundColor: textColor])
        inputField.attributedPlaceholder = placeholder
    }
    
    private func style() {
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        
        inputField.layer.borderColor = CGColor(red: 21/255, green: 77/255, blue: 133/255, alpha: 1)
        inputField.layer.borderWidth = 1
        inputField.layer.shadowColor = UIColor.black.cgColor
        inputField.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        inputField.layer.shadowOpacity = 0.09
        inputField.layer.shadowRadius = 3.0
        inputField.layer.cornerRadius = 10.0
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: inputPadding, height: Int(inputField.frame.size.height)))
        inputField.leftView = paddingView
        inputField.leftViewMode = .always
        inputField.rightView = paddingView
        inputField.rightViewMode = .always
        
        inputField.font = UIFont.systemFont(ofSize: 16)
        inputField.textColor = textColor
        inputField.backgroundColor = UIColor(red: 19/255, green: 59/255, blue: 99/255, alpha: 1)
    }
    
    private func layout() {
        label.autoPinEdge(toSuperviewEdge: .top)
        label.autoPinEdge(toSuperviewEdge: .leading)
        
        inputField.autoPinEdge(.top, to: .bottom, of: label, withOffset: 8)
        inputField.autoPinEdge(toSuperviewEdge: .bottom)
        inputField.autoAlignAxis(toSuperviewAxis: .vertical)
        inputField.autoMatch(.width, to: .width, of: self)
        inputField.autoSetDimension(.height, toSize: 48)
    }
    
}
