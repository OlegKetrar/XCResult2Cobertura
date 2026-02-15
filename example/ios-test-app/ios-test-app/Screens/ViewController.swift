//
//  ViewController.swift
//  ios-test-app
//
//  Created by Oleg Ketrar on 27.11.2023.
//

import UIKit

class ViewController: UIViewController {

  var onDidLoad: () -> Void = {}
  var onWillAppear: () -> Void = {}
  var onDidAppear: () -> Void = {}

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .red
    onDidLoad()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    onWillAppear()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    onDidAppear()
  }
}
