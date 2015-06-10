//
//  ViewController.swift
//  Todo List
//
//  Created by Mohammad Bharmal on 4/13/15.
//  Copyright (c) 2015 Mohammad Bharmal. All rights reserved.
//

import UIKit
import CoreData
var dateformatter = NSDateFormatter();
struct ForWardParams {
    var item: String
    var date: NSDate
    var object: NSManagedObject
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var todoItemTable: UITableView!
    
    var forwardParam: ForWardParams?
    
    
    var todoItems:[AnyObject]? {
        didSet{
            self.todoItemTable.reloadData()
        }
    }

    var finishedItem:[AnyObject]? {
        didSet{
            self.todoItemTable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dateformatter.dateFormat = "dd-MM-yyyy HH:SS"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.todoItems = fetchAllData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func fetchAllData() -> [AnyObject]{
        var context = appDelegate?.managedObjectContext
        var fetchRequest = NSFetchRequest(entityName: "TodoItem")
        var notDone = NSPredicate(format: "%K == %@", "is_finished", "false")
        fetchRequest.predicate = notDone
        
        var error:NSError?
        if let result = context?.executeFetchRequest(fetchRequest, error: &error){
            return result
        }else{
            return []
        }
    }

    // MARK: Table Related Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rowCount = todoItems?.count{
            return rowCount
        }else{
            return 0
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("item_cell") as? UITableViewCell
        let object:NSManagedObject = todoItems?[indexPath.row] as! NSManagedObject
        let item = object.valueForKey("item_title") as? String
        let date = object.valueForKey("item_due_date") as? NSDate
        let stringDate = dateformatter.stringFromDate(date!)
        
        cell?.textLabel?.text = "I want to \(item!) by"
        cell?.detailTextLabel?.text = "\(stringDate)"
        return cell!
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let object:NSManagedObject = todoItems?[indexPath.row] as! NSManagedObject
        let date = object.valueForKey("item_due_date") as? NSDate
        let text = object.valueForKey("item_title") as? String
        self.forwardParam = ForWardParams(item: text!, date: date!, object: object)
        return indexPath
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if(editingStyle == UITableViewCellEditingStyle.Delete){
            let object = todoItems?[indexPath.row] as! NSManagedObject
            if let managedObjContext = appDelegate?.managedObjectContext {
                managedObjContext.deleteObject(object)
                managedObjContext.save(nil)
                todoItems = fetchAllData()
            }
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if forwardParam != nil{
            let nextController = segue.destinationViewController as! ItemAddViewController
            nextController.params = self.forwardParam            
            self.forwardParam = nil
        }
    }

    
}

