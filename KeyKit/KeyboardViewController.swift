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
}

public class KeyboardViewController: UIViewController {
    
    weak var delegate: KeyboardDelegate?
    
    private var keyboardView: KeyboardView!

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
        
        let face                           = Face.lettersFace()
        let faceView                       = FaceView(face: face, target: self, selector: #selector(keyAction))
        
        self.keyboardView                  = KeyboardView(faceView: faceView)
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
    //  MARK: - UI Actions -
    //
    @objc private func keyAction(keyView: KeyView) {
        switch keyView.key.value {
        case .Action(let action):
            print("Action from: \(action)")
            
        case .Char(let character):
            print("\(character)", terminator: "")
        }
        
        self.delegate?.keyboardViewController(self, didReceiveInputFrom: keyView.key)
    }
}
