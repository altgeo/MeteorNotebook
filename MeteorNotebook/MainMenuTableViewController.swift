//
//  MainMenuTableViewController.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 2.04.24.
//

import UIKit

class MainMenuTableViewController: UITableViewController {
  

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "startPracticeObservation":
            guard let destinationVC = segue.destination as? MakeNoteViewController else { break }
            destinationVC.isPracticeRun = true
        default:
            break
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
