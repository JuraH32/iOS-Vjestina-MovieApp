//
//  LogInViewController.swift
//  MovieApp
//
//  Created by endava-bootcamp on 24.03.2023..
//
import UIKit
import PureLayout

class LogInViewController: UIViewController {
    
    var signInLabel: UILabel!
    var emailInput: InputView!
    var passwordInput: InputView!
    var signInButton: UIButton!
    
    init (){
        super.init(nibName: nil, bundle: nil)
        let color = UIColor(red: 11/255, green: 37/255, blue: 63/255, alpha: 1)
        view.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViews()
        styleViews()
        defineLayoutForViews()
        
    }
    
    func createViews() {
        signInLabel = UILabel()
        view.addSubview(signInLabel)
        signInLabel.text = "Sign in"
        
        emailInput = InputView(label: "Email address", placeholder: "ex. matt@ioscourse.com")
        view.addSubview(emailInput)
        
        passwordInput = InputView(label: "Password", placeholder: "Enter your password")
        view.addSubview(passwordInput)
        
        let signInButtonTitle = NSAttributedString(string: "Sign in",
                                                   attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                                                NSAttributedString.Key.foregroundColor: UIColor.white])
        
        signInButton = UIButton()
        signInButton.setAttributedTitle(signInButtonTitle, for: .normal)
        view.addSubview(signInButton)
    }
    
    func styleViews() {
        signInLabel.font = UIFont.boldSystemFont(ofSize: 24)
        signInLabel.textColor = .white
        
        signInButton.layer.cornerRadius = 10
        signInButton.backgroundColor = UIColor(red: 76/255, green: 178/255, blue: 223/255, alpha: 1)
    }
    
    func defineLayoutForViews() {
        signInLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: 40)
        signInLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        emailInput.autoPinEdge(.top, to: .bottom, of: signInLabel, withOffset: 48)
        emailInput.autoAlignAxis(toSuperviewAxis: .vertical)
        emailInput.autoMatch(.width, to: .width, of: view, withOffset: -16)
        
        passwordInput.autoMatch(.width, to: .width, of: emailInput)
        passwordInput.autoMatch(.height, to: .height, of: emailInput)
        passwordInput.autoAlignAxis(toSuperviewAxis: .vertical)
        passwordInput.autoPinEdge(.top, to: .bottom, of: emailInput, withOffset: 24)
        
        signInButton.autoPinEdge(.top, to: .bottom, of: passwordInput, withOffset: 48)
        signInButton.autoPinEdge(toSuperviewEdge: .leading, withInset: 32)
        signInButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 32)
        signInButton.autoSetDimension(.height, toSize: 40)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
