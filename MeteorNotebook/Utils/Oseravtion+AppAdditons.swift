//
//  Oseravtion+AppAdditons.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 10.04.24.
//

import Foundation
import UIKit

extension Observation {
    func observationPeriodString() -> String {
        return "\(DateFormatter.observationTimeFormatter.string(for: self.dateBegin)) - \(DateFormatter.observationTimeFormatter.string(for: self.dateEnd))"
    }
    
    func makePDF()-> NSData {
        let pdfData = NSMutableData()
        
        guard let orderedNotes = self.notes?.array as? Array<Note> else {
            print("empty observation export")
            
            //TODO: 500 500 - remove hardcode
            UIGraphicsBeginPDFPageWithInfo(CGRect(origin: CGPoint.zero, size: CGSize(width: 500,height: 500)), nil)
            
            if let pdfContext = UIGraphicsGetCurrentContext() {
                let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 500,height: 500)))
                label.numberOfLines = 0
                label.textColor = UIColor.black
                label.text = "\(observationPeriodString()) \nNo notes)"
                label.layer.render(in: pdfContext)
            }
            
            UIGraphicsEndPDFContext();
            
            return pdfData
        }
        
        //TODO: find max size
        let imageSize = UIImage(data: orderedNotes.first?.drawing ?? Data())?.size ?? CGSize.zero
        
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: CGPoint.zero, size: imageSize), nil);
        
        guard let nib = Bundle.main.loadNibNamed("ShowNoteView", owner: self, options: nil),
              let cellToDraw = nib.first as? ShowNoteView else {
            print("Failed to load ShowNoteView nib for pdf")
            UIAlertView(title: "Error", message: "Failed to load ShowNoteView nib for pdf", delegate: nil, cancelButtonTitle: "OK").show()
            UIGraphicsEndPDFContext();
            
            return pdfData
        }
        cellToDraw.timeLabel.font = UIFont.systemFont(ofSize: 50)
        
        UIGraphicsBeginPDFPageWithInfo(CGRect(origin: CGPoint.zero, size: imageSize), nil)
        
        if let pdfContext = UIGraphicsGetCurrentContext() {
            let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: imageSize))
            label.numberOfLines = 0
            label.textColor = UIColor.black
            label.text = "\(observationPeriodString()) \nNotes count: \(orderedNotes.count)"
            label.font = UIFont.systemFont(ofSize: 90)
            label.layer.render(in: pdfContext)
            label.frame = CGRect(origin: CGPoint.zero, size: imageSize)
            label.textAlignment = .center
        }
        
        for note in orderedNotes {
            let imageSize = UIImage(data: note.drawing ?? Data())?.size ?? CGSize.zero
            UIGraphicsBeginPDFPageWithInfo(CGRect(origin: CGPoint.zero, size: imageSize), nil)
            cellToDraw.frame = CGRect(origin: CGPoint.zero, size: imageSize)
            cellToDraw.fill(note: note)
            //            cellToDraw.sizeToFit()
            cellToDraw.setNeedsLayout()
            cellToDraw.layoutIfNeeded()
            
            guard let pdfContext = UIGraphicsGetCurrentContext() else {
                continue
            }
            cellToDraw.layer.render(in: pdfContext)
        }
        
        // remove PDF rendering context
        UIGraphicsEndPDFContext();
        
        return pdfData
    }
}
