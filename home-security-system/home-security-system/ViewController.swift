//
//  ViewController.swift
//  home-security-system
//
//  Created by Francesca Bueti on 4/2/18.
//  Copyright © 2018 Francesca Bueti. All rights reserved.
//

import UIKit
import CloudKit
import Alamofire

protocol DataEnteredDelegate:class {
    func passData(name:String, ip: String)
}

class ViewController: UIViewController {
    weak var delegate:DataEnteredDelegate? = nil
    
    
    @IBOutlet weak var tableView: UITableView!
    let database = CKContainer.default().publicCloudDatabase
    
    var sensors = [CKRecord]()
    
    @IBAction func addDevice(_ sender: Any) {
        let alert = UIAlertController(title: "New Sensor", message: "What would you like to save in a note?", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type Sensor Name Here"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Type Sensor IP Here"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let post = UIAlertAction(title: "Post", style: .default) { (_) in
            guard let text1 = alert.textFields![0].text else { return }
            guard let text2 = alert.textFields![1].text else { return }
            print(text1)
            print(text2)
            self.saveToCloud(name: text1, ip: text2)
        }
        alert.addAction(cancel)
        alert.addAction(post)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(queryDatabase), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        queryDatabase()
    }
    
    func saveToCloud(name: String, ip: String) {
        let newSensor = CKRecord(recordType: "Sensor")
        newSensor.setValue(name, forKey: "name")
        newSensor.setValue(ip, forKey: "ip")
        print(newSensor)
        database.save(newSensor) { (record, error) in
            print(error)
            guard record != nil else { return }
            print("saved sensor")
        }
    }
    
    @objc func queryDatabase() {
        let query = CKQuery(recordType: "Sensor", predicate: NSPredicate(value: true))
        database.perform(query, inZoneWith: nil) { (records, _) in
            guard let records = records else { return }
            let sortedRecords = records.sorted(by: { $0.creationDate! > $1.creationDate! })
            self.sensors = sortedRecords
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }


}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sensor = Sensor(name: sensors[indexPath.row].value(forKey: "name") as! String, ip: sensors[indexPath.row].value(forKey: "ip") as! String)
        delegate?.passData(name: sensor.name, ip: sensor.ip)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let sensor = Sensor(name: sensors[indexPath.row].value(forKey: "name") as! String, ip: sensors[indexPath.row].value(forKey: "ip") as! String)
        cell.textLabel?.text = sensor.description
        return cell
    }
}
