//
//  AppDelegate.swift
//  ios-test-app
//
//  Created by Oleg Ketrar on 27.11.2023.
//

import UIKit
import FeatureOne

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    return true
  }

  func makeViewController(
    isFirst: Bool
  ) -> UIViewController {

    let vc = ViewController()
    var feature = FeatureOne(isEnabled: isFirst)

    feature.doSomething()

    if feature.isDone {
      vc.title = "First screen"
    } else {
      vc.title = "Second screen"
    }

    vc.onDidLoad = {
      print("did load")
    }

    vc.onWillAppear = {
      print("will appear")
    }

    vc.onDidAppear = {
      print("did appear")
    }

    return vc
  }
}
