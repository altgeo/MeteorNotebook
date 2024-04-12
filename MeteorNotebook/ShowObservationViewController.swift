//
//  ShowObservationViewController.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 12.04.24.
//

import UIKit

class ShowObservationViewController: UIViewController {

    var observation: Observation! {
        didSet {
            self.title = observation.observationPeriodString()
        }
    }
    
    private let cellReuseIdentifier = "NoteCell"
    
    @IBOutlet private weak var shareButton: UIBarButtonItem!
    
    //MARK: - Actions
    @IBAction func share(_ sender: Any) {
        let pdfData = observation.makePDF()
        let activityVC = UIActivityViewController(
            activityItems: [
                              pdfData],
            applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceItem = self.shareButton
        
        self.present(activityVC, animated: true, completion: nil)
    }
}

extension ShowObservationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return observation.notes?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        (cell as? ShowNoteTableViewCell)?.fill(note: observation.notes?.array[indexPath.row] as? Note)
        return cell

    }
}

extension ShowObservationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
}


