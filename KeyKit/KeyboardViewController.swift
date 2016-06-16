//
//  KeyboardViewController.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public protocol KeyboardDelegate: class {
    func keyboardViewController(controller: KeyboardViewController, didReceiveInputFrom key: Key)
    func keyboardViewController(controller: KeyboardViewController, didInputCharacter character: String)
    func keyboardViewController(controller: KeyboardViewController, didBackspaceLength length: Int)
    
    func keyboardViewControllerDidReturn(controller: KeyboardViewController)
    func keyboardViewControllerDidRequestNextKeyboard(controller: KeyboardViewController)
}

public class KeyboardViewController: UIViewController {
    
    weak var delegate: KeyboardDelegate?
    
    private var keyboardView: KeyboardView!
    private var faces:        [String : Face] = [:]
    
    private var shiftEnabled: Bool = false

    // ----------------------------------
    //  MARK: - Init -
    //
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - View Loading -
    //
    public override func loadView() {
        super.loadView()
        
        let face                           = self.faceFor(Identifier.Letters)
        self.keyboardView                  = KeyboardView(faceView: self.faceViewFor(face))
        self.keyboardView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.keyboardView.backgroundColor  = UIColor.clearColor()
        
        self.view.addSubview(self.keyboardView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.keyboardView.frame = self.view.bounds
    }
    
    // ----------------------------------
    //  MARK: - Face Management -
    //
    private func faceFor(identifier: String) -> Face {
        if let face = self.faces[identifier] {
            return face
            
        } else {
            
            let face: Face
            switch identifier {
            case Identifier.Letters:
                face = Face.lettersFace()
            case Identifier.Numbers:
                face = Face.numbersFace()
            case Identifier.Characters:
                face = Face.charactersFace()
            default:
                fatalError("Unable to create face with identifier: \(identifier)")
            }
            
            self.faces[identifier] = face
            return face
        }
    }
    
    private func faceViewFor(face: Face) -> FaceView {
        return FaceView(face: face, target: self, selector: #selector(keyAction))
    }
    
    // ----------------------------------
    //  MARK: - UI Actions -
    //
    @objc private func keyAction(keyView: KeyView) {
        self.delegate?.keyboardViewController(self, didReceiveInputFrom: keyView.key)
        
        switch keyView.key.value {
        case .Action(let action):
            print("\nAction from: \(action)")
            
            switch action {
            case .Globe:
                self.delegate?.keyboardViewControllerDidRequestNextKeyboard(self)
                
            case .Backspace:
                self.delegate?.keyboardViewController(self, didBackspaceLength: 1)
                
            case .ChangeFace(let identifier):
                self.changeFaceTo(identifier)
                
            case .Shift:
                self.shiftEnabled = !self.shiftEnabled
                
            case .Return:
                print("")
                self.delegate?.keyboardViewControllerDidReturn(self)
            }
            
        case .Char(let character):
            print("\(character)", terminator: "")
        }
        
    }
    
    // ----------------------------------
    //  MARK: - Actions -
    //
    private func changeFaceTo(identifier: String) {
        let face = self.faceFor(identifier)
        self.keyboardView.setFaceView(self.faceViewFor(face))
    }
}