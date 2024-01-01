//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    let db = Firestore.firestore()
    
    var data:[Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMessages()
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        navigationItem.title = "⚡️FlashChat"
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
            }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text,let messageSender = Auth.auth().currentUser!.email{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField:messageSender,
                K.FStore.bodyField:messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    print("Successfully Saved Data")
                }
            }
        }
        DispatchQueue.main.async {
            self.messageTextfield.text = ""
        }
        
    }
    

    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener{
            (querySnapshot, err) in
                self.data = []
          if let err = err {
            print("Error getting documents: \(err)")
              return
          } else {
            for document in querySnapshot!.documents {
                let sender = document.data()[K.FStore.senderField]! as! String
                let body = document.data()[K.FStore.bodyField]! as! String
                self.data.append(Message(sender: sender, body:body))
    
            }
              DispatchQueue.main.async {
                  self.tableView.reloadData()
                  let indexPath = IndexPath(row: self.data.count-1, section: 0)
                  self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
              }
              
          }
        }
        
    }
}

extension ChatViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }else {
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        
        return cell
       
    }
    
}
