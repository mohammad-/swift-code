//
//  ItemAddViewController.swift
//  Todo List
//
//  Created by Mohammad Bharmal on 4/14/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit
import CoreData

class ItemAddViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var itemText: UITextField!
    
    @IBOutlet weak var dateText: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var markAsDoneButton: UIButton!

    @IBOutlet weak var datePickerView: UIDatePicker!
    
    @IBOutlet weak var pickerViewPosition: NSLayoutConstraint!
    
    var params:ForWardParams?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let param = self.params{
            self.itemText.text = param.item
            self.dateText.text = dateformatter.stringFromDate(param.date)
            self.dateText.delegate = self;
            self.saveButton.setTitle("Update Item", forState: UIControlState.Normal)
            self.markAsDoneButton.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Events
    
    @IBAction func closeDatePicker(sender: AnyObject) {
        self.pickerViewPosition.constant = -192.0
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.9, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func saveToDoItem(sender: AnyObject) {
        var error:String? = nil
        if let itemtxt = itemText.text, dueDate = dateText.text {
            if let date = dateformatter.dateFromString(dueDate){
                if self.params == nil{
                    save(itemtxt, dueData: date)
                }else{
                    update(itemtxt, dueData: date, isFinished: false)
                }
            }else{
                error = "Invalid Date Format"
            }
            
        }else{
            error = "Item text and date should not be empty"
        }
        
        if error != nil{
            UIAlertView(title: "", message: error!, delegate: nil, cancelButtonTitle: "Ok").show()
        }
        
    }

    func save(itemText:String, dueData:NSDate){
        if let context = appDelegate?.managedObjectContext{
            if let todoItemEntity = NSEntityDescription.entityForName("TodoItem", inManagedObjectContext: context){
                var object = NSManagedObject(entity: todoItemEntity, insertIntoManagedObjectContext: context)
                object.setValue(itemText, forKey: "item_title")
                object.setValue(dueData, forKey: "item_due_date")
                object.setValue(false, forKey: "is_finished")
                context.insertObject(object)
                context.save(nil)
                goBackToMainScreen()
            }
        }else{
            UIAlertView(title: "", message: "Faled to save item", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }

    
    func update(itemText:String, dueData:NSDate, isFinished:Bool){
        if let context = appDelegate?.managedObjectContext{
            if let object = self.params?.object {
                object.setValue(itemText, forKey: "item_title")
                object.setValue(dueData, forKey: "item_due_date")
                object.setValue(isFinished, forKey: "is_finished")
                context.save(nil)
                goBackToMainScreen()
            }
        }else{
            UIAlertView(title: "", message: "Faled to save item", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }
    
    
    @IBAction func markAsDone(sender: AnyObject) {
        if let context = appDelegate?.managedObjectContext{
            if let object = self.params?.object {
                object.setValue(true, forKey: "is_finished")
                context.save(nil)
                goBackToMainScreen()
            }
        }else{
            UIAlertView(title: "", message: "Faled to save item", delegate: nil, cancelButtonTitle: "Ok").show()
        }
    }

    // MARK: - TextField Delegate
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.pickerViewPosition.constant = 0.0
        self.view.setNeedsUpdateConstraints()
        UIView.animateWithDuration(0.8, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        return false;
    }
    
    // MARK: - Navigation
    func goBackToMainScreen(){
         self.performSegueWithIdentifier("show_main_view_controller", sender: self)
    }
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
