//
//  TodoListViewController.swift
//  todo-list
//
//  Created by Alfred Hanssen on 8/29/15.
//  Copyright © 2015 One Month. All rights reserved.
//

import UIKit

class TodoListViewController: UIViewController, UITableViewDataSource, AddItemViewControllerProtocol {

    static let Title = "Todo List"
    static let CellIdentifier = "CellIdentifier"
    static let CacheKey = "CacheKey"
    
    @IBOutlet weak var tableView: UITableView?
    
    var items: NSMutableArray = NSMutableArray()
    var cache: CacheProtocol = KeyedArchiverCache()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.load()
        
        self.title = TodoListViewController.Title
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "didTapAdd:")

        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        self.tableView?.dataSource = self
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: TodoListViewController.CellIdentifier)
    }
    
    // MARK: AddItemViewControllerProtocol

    func addItem(item: String) {
        
        self.items.insertObject(item, atIndex: 0)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
        
        self.save()
    }
    
    // MARK: UITableView DataSource

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(TodoListViewController.CellIdentifier)!
        
        let item = self.items[indexPath.row] as! String
        cell.textLabel?.text = item
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {

        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.items.removeObjectAtIndex(indexPath.row)
            self.tableView?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
        
            self.save()
        }
    }
    
    // MARK: Actions
    
    func didTapAdd(sender: UIBarButtonItem) {
        
        let viewController = AddItemViewController()
        viewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.view.backgroundColor = UIColor.whiteColor()

        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.tableView?.editing = editing

        self.navigationItem.rightBarButtonItem?.enabled = !editing
    }
    
    // MARK: Cache Actions
    
    func load() {
        let object = self.cache.loadObjectForKey(TodoListViewController.CacheKey)
        
        if let object = object as? NSArray {
            self.items = NSMutableArray(array: object)
        }
    }
    
    func save() {
        self.cache.saveObject(self.items, key: TodoListViewController.CacheKey)
    }
}
