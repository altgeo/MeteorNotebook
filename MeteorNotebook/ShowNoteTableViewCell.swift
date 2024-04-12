//
//  ShowNoteTableViewCell.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 12.04.24.
//

import UIKit

class ShowNoteTableViewCell: UITableViewCell {
    private weak var showNoteView: ShowNoteView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let showNoteView = (Bundle.main.loadNibNamed("ShowNoteView", owner: self)?[0] as? ShowNoteView) else {
            print("Cannot load Show note view from xib")
            return
        }
        
        self.showNoteView = showNoteView
        self.contentView.addSubview(showNoteView)
        showNoteView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addConstraints([
            NSLayoutConstraint(item: showNoteView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showNoteView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showNoteView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: showNoteView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        ])
    }
    
    func fill(note: Note?) {
        showNoteView.fill(note: note)
        
    }
}
