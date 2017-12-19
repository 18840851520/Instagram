//
//  signInVC.swift
//  Instagram
//
//  Created by Shao Kahn on 9/13/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Parse

class signInVC: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var gradientBackground: UIImageViewX!
    
    @IBOutlet weak var usernameTxt: UITextField_Attributes!
    {didSet{usernameTxt.delegate = self}}
    
    @IBOutlet weak var passwordTxt: UITextField_Attributes!
{didSet{passwordTxt.delegate = self}}
    
   fileprivate var activeTextField: UITextField?
 
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpbtn: UIButton!

    @IBOutlet weak var forgotBtn: UIButton!
    
    @IBOutlet weak var signInBtnHeight: NSLayoutConstraint!
    
   fileprivate var currentColorArrayIndex = -1
    
   fileprivate var colorArray:[(color1:UIColor,color2:UIColor)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
 
  //initialize text fields false isEnable input
        initInputsFirst()
        
   //check text fields is or not written all
    setupAddTargetIsNotEmptyTextFields()
        
       createLeftImageOnTextField()
        
      //set image color set
        setColorArr()
      
        //recursively run animatedBackground()
        animatedBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //observe sign In button if is or not hidden
        createObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        //delete the observers
      releaseObservers()
    }
    

    //clicked sign in button
    @IBAction func signInBtn_click(_ sender: Any) {

        //login funcitons
        PFUser.logInWithUsername(inBackground: usernameTxt.text!, password: passwordTxt.text!) { (user:PFUser?, error:Error?) in
            
            if error == nil{
               
//remeber user or save in App memory did the user login or not
UserDefaults.standard.set(user?.username, forKey: "username")
UserDefaults.standard.synchronize()
                
   //call login function from AppDelegate.swift class
let appDelegate = UIApplication.shared.delegate as! AppDelegate
appDelegate.login()
                
}else{

//another case
let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
alert.addAction(ok)
self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func setUnwind(sender: UIStoryboardSegue){
    }
    
}//signInVC class over line

//custom functions
extension signInVC{
    
    fileprivate func createLeftImageOnTextField(){
        
usernameTxt.leftView = UIImageView.init(image: #imageLiteral(resourceName: "Username"))
usernameTxt.leftView?.frame = CGRect(x: 0, y: 5, width: 30 , height:30)
usernameTxt.leftViewMode = .always
        
        passwordTxt.leftView = UIImageView.init(image: #imageLiteral(resourceName: "Password"))
        passwordTxt.leftView?.frame = CGRect(x: 0, y: 5, width: 30 , height:30)
        passwordTxt.leftViewMode = .always
}
    
   fileprivate func setupAddTargetIsNotEmptyTextFields() {
        
        //hidden sign In Button
    signInBtnHeight.constant = 0
    
usernameTxt.addTarget(self, action: #selector(textFieldsIsOrNotEmpty),for: .editingChanged)
passwordTxt.addTarget(self, action: #selector(textFieldsIsOrNotEmpty),for: .editingChanged)
    }
    
    //initialize signInt button layout and background
   fileprivate func initInputsFirst(){
        
        signInBtnHeight.constant = 0
        
        signInBtn.applyGradient(colours:[UIColor(hex:"00C3FF"), UIColor(hex:"FFFF1C")], locations:[0.0, 1.0], stP:CGPoint(x:0.0, y:0.0), edP:CGPoint(x:1.0, y:0.0))
    }
    
    fileprivate func setColorArr(){
colorArray.append(contentsOf: [(color1: #colorLiteral(red: 0.2274509804, green: 0.1098039216, blue: 0.4431372549, alpha: 1), color2: #colorLiteral(red: 0.8431372549, green: 0.4274509804, blue: 0.4666666667, alpha: 1)),(color1: #colorLiteral(red: 0.8431372549, green: 0.4274509804, blue: 0.4666666667, alpha: 1), color2: #colorLiteral(red: 1, green: 0.8470588235, blue: 0.6078431373, alpha: 1)),(color1: #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), color2: #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)),(color1: #colorLiteral(red: 0.8980392157, green: 0.1764705882, blue: 0.1529411765, alpha: 1), color2: #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)),(color1: #colorLiteral(red: 0.5808190107, green: 0.0884276256, blue: 0.3186392188, alpha: 1), color2: #colorLiteral(red: 0.3236978054, green: 0.1063579395, blue: 0.574860394, alpha: 1))])
}
    
  fileprivate func animatedBackground(){
        
        currentColorArrayIndex = currentColorArrayIndex == (colorArray.count - 1) ? 0 : currentColorArrayIndex + 1
        UIView.transition(with: gradientBackground, duration: 2, options: [.transitionCrossDissolve], animations: {
            self.gradientBackground.firstColor = self.colorArray[self.currentColorArrayIndex].color1
            self.gradientBackground.secondColor = self.colorArray[self.currentColorArrayIndex].color2
        }) { (success) in
            self.animatedBackground()
        }
    }
}

//custom functions selectors
extension signInVC{
    
 //if all text fields has not been written anything, the sign In button will be hidden
    @objc fileprivate func textFieldsIsOrNotEmpty(sender: UITextField) {

    self.signInBtn.isHidden = (usernameTxt.text?.isEmpty)! || (passwordTxt.text?.isEmpty)!
      
        if self.signInBtn.isHidden{
          NotificationCenter.default.post(name: NSNotification.Name.init("isHidden"), object: nil)
        }else{
 NotificationCenter.default.post(name: NSNotification.Name.init("NotHidden"), object: nil)
        }
    }
}

//observers
extension  signInVC{
    
    //observe the sign In button is or not hidden
    fileprivate  func createObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(signInVC.btnHiddenStackLocation(argu:)), name: NSNotification.Name.init("isHidden"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signInVC.btnNotHiddenStackLocation(argu:)), name: NSNotification.Name.init("NotHidden"), object:nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(argu:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(argu:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //release the observers
    fileprivate func releaseObservers(){
        NotificationCenter.default.removeObserver(self)
    }
}

//observers selectors
extension signInVC{
    
    //if the sign In button is or not hidden, change the stack location
    @objc fileprivate func btnHiddenStackLocation(argu: Notification){signInBtnHeight.constant = 0}
    
    @objc fileprivate func btnNotHiddenStackLocation(argu: Notification){signInBtnHeight.constant = 60}
    
    @objc fileprivate func keyboardDidShow(argu: Notification){
        
        let info = argu.userInfo! as NSDictionary
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        
        guard let editingTextField = activeTextField?.frame.origin.y else
        {return}
        
        if self.view.frame.origin.y >= 0{
            
            //Checking if the textfield is really hidden behind the keyboard
    if editingTextField > keyboardY - 60{
UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations:
{[unowned self] in
self.view.frame = CGRect(x: 0.0, y: self.view.frame.origin.y - (editingTextField - (keyboardY - 60)), width: self.view.bounds.size.width, height: self.view.bounds.size.height)
                    }, completion: nil)
            }
        }
    }
    
    @objc fileprivate func keyboardWillHide(argu: Notification){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations:
            {[unowned self] in
                self.view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            }, completion: nil)
    }

}

//UITextFieldDelegate
extension signInVC{
    
    //get the currrent textfield whenever
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    //click keyboard return to close keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        usernameTxt.resignFirstResponder()
        passwordTxt.resignFirstResponder()
        return true
    }
    
}


