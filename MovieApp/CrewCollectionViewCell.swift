//
//  RoleView.swift
//  MovieApp
//
//  Created by endava-bootcamp on 28.03.2023..
//

import UIKit
import PureLayout

class CrewCollectionViewCell: UICollectionViewCell {
    let nameLabel = UILabel()
    let roleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        buildViews()
    }
    
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        self.addSubview(nameLabel)
        self.addSubview(roleLabel)
    }
    
    public func setText(name: String, role: String) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.4
        nameLabel.attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        roleLabel.attributedText = NSMutableAttributedString(string: role, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
    
    private func styleViews() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        roleLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    private func defineLayoutForViews() {
        nameLabel.autoPinEdge(toSuperviewEdge: .top)
        nameLabel.autoPinEdge(toSuperviewEdge: .leading)
        nameLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        roleLabel.autoPinEdge(.top, to: .bottom, of: nameLabel)
        roleLabel.autoPinEdge(toSuperviewEdge: .bottom)
        roleLabel.autoPinEdge(toSuperviewEdge: .leading)
        roleLabel.autoPinEdge(toSuperviewEdge: .trailing)
        roleLabel.autoMatch(.height, to: .height, of: nameLabel)
    }
}
