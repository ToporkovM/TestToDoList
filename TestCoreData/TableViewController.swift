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
    
    //массив сущностей
    lazy var tasks: [Task] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //получаем контекст
        let context = getContext()
        //запрос на получение сущности Task
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        do {
            //присваеваем массиву tasks, полученный массив данных из fetchRequest
            try tasks = context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        //создаем массив объектов, которые содержатся в сущности Task, с помощью fetchRequest
        if let objects = try? context.fetch(fetchRequest) {
            for object in objects {
                context.delete(object)
            }
        } else {
            return
        }
        //сохраняем контекст после удаления объектов сущности
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
    }
    
    //сохраняет в базу полученную строку
    private func saveTask(withTitle title: String) {
        let context = getContext()
        //создаем сущность для сущности Task, в контексте
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        //создаем объект равный сущности Task
        let taskObjekt = Task(entity: entity, insertInto: context)
        //присваеваем тайтлу сущности Task пришедшую в параметры строку
        taskObjekt.title = title
        //сохраняем контекст в базе и добавляем taskObjekt в массив tasks
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
}
