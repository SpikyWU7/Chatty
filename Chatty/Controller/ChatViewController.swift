import Foundation
import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet private var chatTableView: UITableView!
    @IBOutlet private var messageTextField: UITextField!
    
    var listener: ListenerRegistration?
    let db = Firestore.firestore()
    var messages: [Message] = [Message(sender: "1@1.com", body: "test")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatTableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        chatTableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        loadMessages()
    }
    
//MARK: - LoadMessages -> reloadTableView
    private func loadMessages() {
        listener = db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            
            if let e = error {
                print("ERROR: Issue with retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
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
    @IBAction private func sendMessagePressed(_ sender: UIButton) {
        
        if let messageBody = messageTextField.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Error: Some issue with saving data to firestore, \(e)")
                } else {
                    print("Succesfuly saved data")
                    DispatchQueue.main.async {
                        self.messageTextField.endEditing(true)
                        self.messageTextField.text = ""
                    }
                }
            }
        }
    }
    
//MARK: - func logOutPressed
    @IBAction private func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        if let safeListener = listener {
            safeListener.remove()
        }
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

//MARK: - Extension for ChatVC: TableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = chatTableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.navyBlue)
            cell.label.textColor = UIColor(named: K.BrandColors.lightBlue)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightBlue)
            cell.label.textColor = UIColor(named: K.BrandColors.navyBlue)
        }
        return cell
    }
}

