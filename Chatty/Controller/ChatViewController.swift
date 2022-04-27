//
//  ChatViewController.swift
//  Chatty
//
//  Created by Spiky WU7 on 27.04.2022.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup
    }
    
    @IBAction func sendMessagePressed(_ sender: UIButton) {
    }
    
}
