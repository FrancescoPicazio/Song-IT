//
//  AddViewController.swift
//  Song-IT
//
//  Created by Giovanni Bassolino on 06/12/17.
//  Copyright © 2017 Giovanni Bassolino. All rights reserved.
//

import UIKit

class AddViewController: UIViewController , UITextFieldDelegate , UIPickerViewDataSource,UIPickerViewDelegate , UITextViewDelegate {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var artistField: UITextField!
    @IBOutlet weak var moodPicker: UIPickerView!
    @IBOutlet weak var commentTextField: UITextView!
    @IBOutlet weak var myScroll: UIScrollView!
    
    let moods = ["angry","excited","happy","nostalgic","relaxed","romantic","sad"] ////array with moods . This will load in picker
    var moodSelected : String = "angry" ////default mood selected
    

    override func viewDidLoad() {
        super.viewDidLoad()
        moodPicker.delegate = self //set delegate of picker
        moodPicker.dataSource = self
        commentTextField.delegate = self   ////set delegate of TextView
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad)
        {
        myScroll.isScrollEnabled = false   ///lock scrollview on ipad
        }else{
            UIApplication.shared.statusBarStyle = .default  ///change status bar color
        }
            //add subview with blur
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.view.frame
            blurEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight]

            self.view.insertSubview(blurEffectView, at: 0)
            
            commentTextField.backgroundColor = UIColor(red: 239, green: 239, blue: 244, alpha: 0.8)
        commentTextField.text = "Insert any comment or thought (max 256 char)"   //create a fake placeholder
        commentTextField.textColor = UIColor.lightGray
        
        commentTextField.layer.cornerRadius = 10
    }
    
  
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return moods.count
    }
    

    
    func pickerView(_ pickerView: UIPickerView,didSelectRow row: Int,inComponent component: Int)
    {
        moodSelected = moods[row]
    }
    
    ////function that change color of pickerview
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            return NSAttributedString(string: moods[row], attributes: [ NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 14.0)! ])
    }
    
    
    
    /////placeholder in textview
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Insert any comment or thought (max 256 char)"
            textView.textColor = UIColor.lightGray
        }
    }
    
    
    //Return close keyboard and max size of 265 char
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        print(Int(newText.count))
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return numberOfChars < 265;
    }
    ////////////////////////////////////////////////
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        DataManager.shared.loadData()
        dismiss(animated: true, completion: nil)
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone){
            UIApplication.shared.statusBarStyle = .lightContent
        }
        

    }
    
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone){     ///change status bar color
            UIApplication.shared.statusBarStyle = .lightContent
        }
        
        //  check that text of texfields is valid
        guard let guardTitle = titleField.text,
            let guardArtist = artistField.text,
            var guardComment = commentTextField.text    //guardia della textView
            else {
                return
            }
        
        // check that textfields of title and artist aren't empty
        if guardTitle.isEmpty == true || guardArtist.isEmpty == true
        {
            // if is empty
            // make an alert
            let myAlert = UIAlertController(title: "ERROR",
                                            message: "Please complete artist and title fields",
                                            preferredStyle: .alert)
            myAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(myAlert, animated: true, completion: nil)
            
            // fermiamo il codice in modo che non prosegua oltre
            return
        }
        
        if guardComment == "Insert any comment or thought (max 256 char)"{
            guardComment = ""
        }
        
        if guardComment == ""{
            moodSelected += "wc"        ///suffix if post hasn't a comment
            print(moodSelected)
        }
        
        ///create new post
        DataManager.shared.newPost(title: guardTitle, artist: guardArtist, nlike: 0, ndislike: 0, comment: guardComment, mood: moodSelected)
        // close
        DataManager.shared.loadData()
        dismiss(animated: true, completion: nil)
    }
    
    
////////METHOD TEXTFIELD
    /// Method textfield's delegate that close when you click return

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }

    ////max 30 char
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 30 // Bool
    }
    
    
        
}
