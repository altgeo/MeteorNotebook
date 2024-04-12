//
//  ShowNoteView.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 12.04.24.
//

import UIKit

class ShowNoteView: UIView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet private weak var drawingImageView: UIImageView!
    
    func fill (note: Note?) {
        self.timeLabel.text = DateFormatter.observationTimeFormatter.string(for: note?.time)
        self.drawingImageView.image = UIImage(data: note?.drawing ?? Data())
        
    }
    
    
}
