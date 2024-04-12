//
//  ViewController.swift
//  MeteorNotebook
//
//  Created by Nikolay Ivanov on 2.04.24.
//

import UIKit
import CoreData
import AVKit
import MusicKit
import MediaPlayer

class MakeNoteViewController: UIViewController {
    
    var isPracticeRun = false
    
    private var observation: Observation?
    private var noteTime: Date?
    
    @IBOutlet private weak var drawingView: DrawingView!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if(!isPracticeRun) {
            NotificationCenter.default.addObserver(self, selector:#selector(self.endObservation) , name: UIScene.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector:#selector(self.endObservation) , name: UIApplication.willTerminateNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector:#selector(self.startObservation) , name: UIScene.willEnterForegroundNotification, object: nil)
        }
        
        //Needed to not show volume change
        let volumeView = MPVolumeView(frame: CGRect(x: -1000, y: -1000, width: 0, height: 0))
        self.view.addSubview(volumeView)
        //Private API. Not guaranteed to work
        NotificationCenter.default.addObserver(self, selector: #selector(volumeChanged(_:)), name: NSNotification.Name(rawValue: "SystemVolumeDidChange"), object: nil)
    }
            
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isPracticeRun {
            self.navigationController?.isNavigationBarHidden = true
        }
        self.view.backgroundColor = isPracticeRun ? UIColor.white : UIColor.black
        startObservation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endObservation()
    }
    
    //MARK: - Actions

    @IBAction func draw(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            startNote()
            fallthrough
        case .changed: 
            drawingView?.addTouchedPoint(pointToAdd: gestureRecognizer.location(in: self.view))
        case .ended, .cancelled, .failed:
            drawingView?.addTouchedPoint(pointToAdd: gestureRecognizer.location(in: self.view))
            drawingView?.finishPath()
        default: break
        }
    }
    
    //MARK: - Observation lifecycle
    @objc
    private func startObservation() {
        guard !isPracticeRun else {
            return
        }
        let managedContext = PersistenceCoordinator.sharedInstance.persistentContainer.viewContext
        let newObservation = NSEntityDescription.insertNewObject(forEntityName: "Observation", into: managedContext)
        observation = (newObservation as! Observation)
        observation?.dateBegin = Date()
    }
    
    @objc
    private func endObservation() {
        guard !isPracticeRun else {
            return
        }
        endNote()
        observation?.dateEnd = Date()
        PersistenceCoordinator.sharedInstance.saveContext()
    }
    
    private func startNote() {
        
//        Времето се запазва при първото натискане
        noteTime = Date()
    }
    
    private func endNote() {
//        Когато натиснем volume/action button сменя страница
        if !isPracticeRun  {
            
            guard noteTime != nil  else { return }
            
            guard observation != nil else { return }
            
            
            let managedContext = PersistenceCoordinator.sharedInstance.persistentContainer.viewContext
            guard let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: managedContext) as? Note else {
                print("Cannot create note")
                return
            }
            
            newNote.time = noteTime
            newNote.drawing = getDrawing()
            observation?.addToNotes(newNote)
            
            noteTime = nil
        }
        drawingView.clearView()
        
    }
    
    
    //MARK: - Notification handlers
    @objc
    func volumeChanged(_ notification: Notification) {
        if let info = notification.userInfo,
           let changeReason = info["Reason"] as? String,
           changeReason == "ExplicitVolumeChange" {
            DispatchQueue.main.async { [weak self] in
                self?.endNote()
            }
        }
    }
    
    //MARK: - helper methods
    private func getDrawing() -> Data {
        guard let displayView = drawingView else {
            print("No drawingView")
            return Data()
        }
        UIGraphicsBeginImageContextWithOptions(displayView.layer.frame.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Cannot make graphics context")
            return Data()
        }
        displayView.layer.render(in: context)
        guard let viewImage = UIGraphicsGetImageFromCurrentImageContext() else {
            print("cannot draw image")
            return Data()
        }
        UIGraphicsEndImageContext()
        return viewImage.pngData() ?? Data()
    }
    
}

