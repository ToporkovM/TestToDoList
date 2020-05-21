//
//  TableViewController.swift
//  TestCoreData
//
//  Created by max on 16.05.2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    lazy var tasks: [Task] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            try tasks = context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        

    }

    @IBAction func addButton(_ sender: Any) {
        let alert = UIAlertController(title: "Task", message: "Add new task", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Add", style: .default) { action in
            let alertTf = alert.textFields?.first
            if let newTask = alertTf?.text {
                self.saveTask(withTitle: newTask)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { _ in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        } else {
            return
        }
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    private func saveTask(withTitle title: String) {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        let taskObjekt = Task(entity: entity, insertInto: context)
        taskObjekt.title = title
        do {
            try context.save()
            tasks.insert(taskObjekt, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
             
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title

        return cell
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
