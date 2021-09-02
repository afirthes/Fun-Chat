//
//  ViewController.swift
//  Fun Chat
//
//  Created by sehio on 25.08.2021.
//

import UIKit
import Firebase
import FirebaseFirestore


class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fun Chat"
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        
        loadMessages()
    }
    
    func loadMessages() {
        
        
        db.collection("messages")
            .order(by: "date")
            .addSnapshotListener {
                querySnapshot, error in
                
                if let e = error {
                    print("Issue retrieving data from firestore \(e)")
                    return
                }
                
                self.messages = []
                
                querySnapshot?.documents
                    .map{d in d.data()}
                    .forEach{d in
                        let sender = d["sender"] as? String
                        let body = d["body"] as? String
                        //let timestamp = d["date"] as? TimeInterval
                        
                        if let s = sender, let b = body {
                            self.messages.append(Message(sender: s, body: b))
                        }
                    }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.scrollToRow(at: IndexPath(row: self.messages.count-1, section: 0), at: .bottom, animated: true)
                }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(
                data: [
                    "sender":sender,
                    "body": messageBody,
                    "date": Date().timeIntervalSince1970
                ]) {
                (error) in
                
                if let e = error {
                    print("Issue saving data to firestore: \(e)")
                    return
                } else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
                
                
            }
            
            
            
        }
        
        
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        
        cell.label.text = messages[indexPath.row].body
        
        if Auth.auth().currentUser?.email == messages[indexPath.row].sender {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: "BrandCyan")
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: "BrandYellow")
        }
        
        return cell
        
         
    }
    
}


