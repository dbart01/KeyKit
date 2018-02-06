//
//  KeyboardViewController.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public protocol KeyboardCustomActionDelegate: class {
    func keyboardViewController(_ controller: KeyboardViewController, didReceiveCustomAction action: KeyActionType)
}

public protocol KeyboardDelegate: KeyboardCustomActionDelegate {
    func keyboardViewControllerDidRequestNextKeyboard(_ controller: KeyboardViewController)
    
    func keyboardViewController(_ controller: KeyboardViewController, didReceiveInputFrom key: Key)
    func keyboardViewController(_ controller: KeyboardViewController, didBackspaceLength length: Int)
    
    func keyboardViewControllerDidReturn(_ controller: KeyboardViewController)
}

open class KeyboardViewController: UIViewController {
    
    open weak var delegate:      KeyboardDelegate?
    open weak var documentProxy: UITextDocumentProxy? {
        didSet {
            self.updateShiftStateIn(self.documentProxy)
        }
    }
    
    open var usePeriodShortcut = true
    open var allowCapsLock     = false
    
    private var keyboardView: KeyboardView!
    
    private var shiftKeys:         [KeyView] = []
    private var shiftEnabled:      Bool = false
    private var capsLockEnabled:   Bool = false
    private var lastInsertedSpace: Bool = false
    private var insertedShortcut:  Bool = false
    
    private let faces: [String : Face]
    private let initialFaceIdentifier: String

    // ----------------------------------
    //  MARK: - Init -
    //
    public init(faces: [Face], initialFaceIdentifier: String) {
        
        self.faces                 = faces.dictionaryByIdentifier
        self.initialFaceIdentifier = initialFaceIdentifier
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - View Loading -
    //
    open override func loadView() {
        super.loadView()
        
        self.keyboardView                  = KeyboardView(faceView: nil)
        self.keyboardView.frame            = self.view.bounds
        self.keyboardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.changeFaceTo(self.initialFaceIdentifier, inProxy: self.documentProxy)
        
        self.view.addSubview(self.keyboardView)
    }
    
    // ----------------------------------
    //  MARK: - Text Actions -
    //
    open func textWillChange(_ input: UITextInput?) {
        
    }
    
    open func textDidChange(_ input: UITextInput?) {
        
    }
    
    // ----------------------------------
    //  MARK: - Face Management -
    //
    private func faceFor(_ identifier: String) -> Face {
        if let face = self.faces[identifier] {
            return face
        } else {
            fatalError("Could not load face. Face for identifier: \(identifier) cannot be found.")
        }
    }
    
    private func faceViewFor(_ face: Face) -> FaceView {
        return FaceView(face: face, targetable: self)
    }
    
    // ----------------------------------
    //  MARK: - Shift State -
    //
    private func referenceShiftKeys() {
        self.shiftKeys = self.keyboardView.keyViewsMatching { (key) -> Bool in
            if case .action(.shift) = key.value {
                return true
            }
            return false
        }
    }
    
    private func setShiftEnabled(_ enabled: Bool) {
        self.shiftEnabled = enabled
        for keyView in self.shiftKeys {
            keyView.setTrackingState(enabled ? .selected : .normal)
        }
    }
    
    // ----------------------------------
    //  MARK: - Updates -
    //
    private func updateShiftStateIn(_ proxy: UITextDocumentProxy?) {
        if let proxy = proxy {
            
            /* ---------------------------------
             ** Check the shift state and enable
             ** all the keys in case the faces
             ** have changed, etc.
             */
            if self.shiftEnabled {
                self.setShiftEnabled(true)
                
            } else {
                let content = proxy.documentContextBeforeInput ?? ""
                var enable  = false
                
                if content == "" {
                    enable = true
                } else {
                    enable = content.suffix(2) == ". "
                }
                
                self.setShiftEnabled(enable)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Actions -
    //
    open func simulate(_ action: Key.Action) {
        self.handle(.action(action), forKey: nil)
    }
    
    open func changeFaceTo(_ identifier: String, inProxy proxy: UITextDocumentProxy?) {
        let face = self.faceFor(identifier)
        self.keyboardView.setFaceView(self.faceViewFor(face))
        
        self.referenceShiftKeys()
        self.updateShiftStateIn(proxy)
    }
    
    fileprivate func handle(_ value: Key.Value, forKey key: Key?) {
        if let key = key {
            self.delegate?.keyboardViewController(self, didReceiveInputFrom: key)
        }
        
        switch value {
        case .action(let action):
            print("\nAction from: \(action)")
            
            switch action {
            case .globe:
                self.delegate?.keyboardViewControllerDidRequestNextKeyboard(self)
                
            case .backspace:
                self.processBackspaceIn(self.documentProxy)
                
                self.delegate?.keyboardViewController(self, didBackspaceLength: 1)
                
            case .changeFace(let identifier):
                self.changeFaceTo(identifier, inProxy: self.documentProxy)
                
            case .shift:
                self.setShiftEnabled(!self.shiftEnabled)
                
            case .return:
                self.handle(.char("\n"), forKey: nil)
                self.delegate?.keyboardViewControllerDidReturn(self)
                
            case .custom(let action):
                self.delegate?.keyboardViewController(self, didReceiveCustomAction: action)
            }
            
        case .char(let character):
            self.processInsertion(character, withProxy: self.documentProxy)
        }
    }
    
    private func processInsertion(_ character: String, withProxy proxy: UITextDocumentProxy?) {
        
        /* ---------------------------------
         ** If a proxy is provided, we need
         ** to handle the entered key events
         ** appropriately.
         */
        if let proxy = proxy {
            
            switch character {
            case " " where self.usePeriodShortcut:
                if !self.lastInsertedSpace {
                    self.lastInsertedSpace = true
                    
                } else if !self.insertedShortcut {
                    self.lastInsertedSpace = false
                    self.insertedShortcut  = true
                    
                    proxy.deleteBackward()
                    proxy.insertText(".")
                }
                proxy.insertText(character)
                
            default:
                var text = character
                if self.shiftEnabled {
                    text = character.capitalized
                }
                proxy.insertText(text)
                
                self.insertedShortcut  = false
                self.lastInsertedSpace = false
                
                /* ---------------------------------
                 ** Disable shift key after each key
                 ** press, unless we're in caps lock
                 ** mode.
                 */
                if self.shiftEnabled && !self.capsLockEnabled {
                    self.handle(.action(.shift), forKey: nil)
                }
            }
        }
        
        self.updateShiftStateIn(proxy)
        print("\(character)", terminator: "")
    }
    
    private func processBackspaceIn(_ proxy: UITextDocumentProxy?) {
        proxy?.deleteBackward()
        
        self.insertedShortcut  = false
        self.lastInsertedSpace = false
        
        self.updateShiftStateIn(proxy)
    }
}

// ----------------------------------
//  MARK: - KeyTargetable -
//
extension KeyboardViewController: KeyTargetable {
    
    public func keyReceivedAction(_ keyView: KeyView) {
        self.handle(keyView.key.value, forKey: keyView.key)
    }
    
    public func keyShouldRepeat(_ keyView: KeyView) -> Bool {
        if case .action(let action) = keyView.key.value, action == .backspace {
            return true
        }
        return false
    }
    
    public func keyDidRepeat(_ keyView: KeyView) {
        Click.play()
        self.keyReceivedAction(keyView)
    }
    
    public func key(_ keyView: KeyView, didChangeTrackingState tracking: Bool, draggedIn: Bool?) {
        if tracking {
            if let draggedIn = draggedIn, draggedIn {
                // Don't click
            } else {
                Click.play()
            }
        }
    }
}
