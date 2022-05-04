//
//  ChatViewController.swift
//  Chatty
//
//  Created by Spiky WU7 on 27.04.2022.
//

import Foundation
import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    //Create listener for excluding firebase meanless errors
    var listener: ListenerRegistration?
    //initialization for database
    let db = Firestore.firestore()
    
    //Array of messages to pass into database, showing on chat VC for example
    var messages: [Message] = [
        Message(sender: "1@1.com", body: "Hey!")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
        
        //When tableView loads up it'll make a request for data, triggering the delegate methods from extension
        chatTableView.dataSource = self
        title = K.appName
        //Hiding back-to-login/register button from nav bar. Only log out to welcome VC.
        navigationItem.hidesBackButton = true
        
        //Adding custom cell
        chatTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    //MARK: - LoadMessages -> reloadTableView
    func loadMessages() {
        
        //Load messages from db
        listener = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
        
            .addSnapshotListener { (querySnapshot, error) in
            
            //empty messages array to db
            self.messages = []
            
            if let e = error {
                print("ERROR: Issue with retrieving data from Firestore. \(e)")
            } else {
//                querySnapshot?.documents[0].data()[K.FStore.senderField]
                //configuring docs in firebase
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            //reloading tableView with new messages from database
                            DispatchQueue.main.async {
                                self.chatTableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                self.chatTableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - sendMessagePressed
    @IBAction func sendMessagePressed(_ sender: UIButton) {
        
        //Sending the message to database
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                //Sort by the time last message sent
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Error: Some issue with saving data to firestore, \(e)")
                } else {
                    print("Succesfuly saved data")
                    
                    //Deleting sended message from textfield, hiding keyboard
                    DispatchQueue.main.async {
                        self.messageTextField.endEditing(true)
                        self.messageTextField.text = ""
                    }
                }
            }
        }
        
    }
    
    //MARK: - func logOutPressed
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
        
        let firebaseAuth = Auth.auth()
        //evading meanless errors
        if let safeListener = listener {
            safeListener.remove()
        }
        do {
            try firebaseAuth.signOut()
            //returning to main VC with reg and sign in
            navigationController?.popToRootViewController(animated: true)
            //catching error
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
        
        //        performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
}

//MARK: - Extension for ChatVC: TableViewDataSource

extension ChatViewController: UITableViewDataSource {
    
    //How many rows or cells in tableView, allocatng required number of rows/cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //This method is asking for a cell that should be displayed in particular row. Create a cell then returning it to the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        //Downcasting cell as MessageCell
        let cell = chatTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        //Label -> text inside message cell
        cell.label.text = message.body
        
        //Message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.navyBlue)
            cell.label.textColor = UIColor(named: K.BrandColors.lightBlue)
        }
        //Message from the another sender
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightBlue)
            cell.label.textColor = UIColor(named: K.BrandColors.navyBlue)
        }
            
        
        return cell
    }
}

