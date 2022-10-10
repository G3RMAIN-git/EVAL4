//
//  ViewController.swift
//  EVAL4
//
//  Created by Germain Buchet on 10/10/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myData = [Expense]()
    var context: NSManagedObjectContext!
    
    func addDataCoreData(){
        let oneMyData = Expense(context: context)
        oneMyData.name = nameTextField.text
        oneMyData.value = Float(valueTextField.text!)!

        do{ try context.save()}
        catch{print("Error")}

        
    }
    
    func loadValueFromCoreData(){
        if let delegate = UIApplication.shared.delegate as? AppDelegate
        {
            let context = delegate.persistentContainer.viewContext
            self.context = context
            let request = Expense.fetchRequest()
            let orderByName = NSSortDescriptor(key: "name", ascending: true)

            request.sortDescriptors = [orderByName]
            
            do{myData = try context.fetch(request)}
            catch{print("errror 2")}
            
            myTableView.reloadData()
        }
    }
    
    
    @IBAction func addValueModal(_ sender: Any) {
        addDataCoreData()
        //let myData = Person(context: context)
    }
    
    
    @IBAction func showFullAddView(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addVC")
        self.present(vc, animated: true)
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
    
    
    @IBOutlet weak var myTableView: UITableView!{
        didSet{
            myTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableView.delegate = self
        myTableView.dataSource = self
        
        loadValueFromCoreData()
    }
}
    
    extension ViewController{
        
        public func tableView(_ tableview: UITableView, heightForRowAt indexPath: IndexPath)-> CGFloat {
            return 100
        }
        
        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            myData.count
        }
        
        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = myTableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
                print("error 3")
                //fatalError()
                return TableViewCell()
            }
            
            let Expense = myData[indexPath.row]
            
            cell.nameLabel.text = Expense.name
            cell.valueDataLabel.text = "\(Expense.value)"
            
            return cell
        }
        
        
    }





