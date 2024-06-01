/**
 * The ViewController for the Installation screen of the Scribe app.
 *
 * Copyright (C) 2023 Scribe
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import UIKit

/// A UIViewController that provides instructions on how to install Keyboards as well as information about Scribe.
class InstallationVC: UIViewController {
  // Variables linked to elements in AppScreen.storyboard.
  @IBOutlet var appTextViewPhone: UITextView!
  @IBOutlet var appTextViewPad: UITextView!
  var appTextView: UITextView!

  @IBOutlet var appTextBackgroundPhone: UIView!
  @IBOutlet var appTextBackgroundPad: UIView!
  var appTextBackground: UIView!

  @IBOutlet var topIconPhone: UIImageView!
  @IBOutlet var topIconPad: UIImageView!
  var topIcon: UIImageView!

  @IBOutlet var settingsBtnPhone: UIButton!
  @IBOutlet var settingsBtnPad: UIButton!
  var settingsBtn: UIButton!

  @IBOutlet var settingsCornerPhone: UIImageView!
  @IBOutlet var settingsCornerPad: UIImageView!
  var settingsCorner: UIImageView!

  @IBOutlet var settingCornerWidthConstraintPhone: NSLayoutConstraint!
  @IBOutlet var settingCornerWidthConstraintPad: NSLayoutConstraint!
  var settingCornerWidthConstraint: NSLayoutConstraint!

  // Spacing views to size app screen proportionally.
  @IBOutlet var topSpace: UIView!
  @IBOutlet var logoSpace: UIView!

  @IBOutlet var installationHeaderLabel: UILabel!

  func setAppTextView() {
    if DeviceType.isPad {
      appTextView = appTextViewPad
      appTextBackground = appTextBackgroundPad
      topIcon = topIconPad
      settingsBtn = settingsBtnPad
      settingsCorner = settingsCornerPad
      settingCornerWidthConstraint = settingCornerWidthConstraintPad

      appTextViewPhone.removeFromSuperview()
      appTextBackgroundPhone.removeFromSuperview()
      topIconPhone.removeFromSuperview()
      settingsBtnPhone.removeFromSuperview()
      settingsCornerPhone.removeFromSuperview()
    } else {
      appTextView = appTextViewPhone
      appTextBackground = appTextBackgroundPhone
      topIcon = topIconPhone
      settingsBtn = settingsBtnPhone
      settingsCorner = settingsCornerPhone
      settingCornerWidthConstraint = settingCornerWidthConstraintPhone

      appTextViewPad.removeFromSuperview()
      appTextBackgroundPad.removeFromSuperview()
      topIconPad.removeFromSuperview()
      settingsBtnPad.removeFromSuperview()
      settingsCornerPad.removeFromSuperview()
    }
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func viewDidLoad() {
    super.viewDidLoad()
    setCurrentUI()
  }

  /// Includes a call to checkDarkModeSetColors to set brand colors and a call to set the UI for the app screen.
  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    setCurrentUI()
  }

  /// Includes a call to set the UI for the app screen.
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    setCurrentUI()
  }

  // Lock the device into portrait mode to avoid resizing issues.
  var orientations = UIInterfaceOrientationMask.portrait
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    get { return orientations }
    set { orientations = newValue }
  }

  /// Sets the top icon for the app screen given the device to assure that it's oriented correctly to its background.
  func setTopIcon() {
    if DeviceType.isPad {
      topIconPhone.isHidden = true
      topIconPad.isHidden = false
      for constraint in settingsCorner.constraints {
        if constraint.identifier == "settingsCorner" {
          constraint.constant = 125
        }
      }
    } else {
      topIconPhone.isHidden = false
      topIconPad.isHidden = true
      for constraint in settingsCorner.constraints {
        if constraint.identifier == "settingsCorner" {
          constraint.constant = 70
        }
      }
    }
  }

  /// Sets the functionality of the button over the keyboard installation guide that opens Settings.
  func setSettingsBtn() {
    settingsBtn.addTarget(self, action: #selector(openSettingsApp), for: .touchUpInside)
    settingsBtn.addTarget(self, action: #selector(keyTouchDown), for: .touchDown)
  }

  /// Sets constant properties for the app screen.
  func setUIConstantProperties() {
    // Set the scroll bar so that it appears on a white background regardless of light or dark mode.
    let scrollbarAppearance = UINavigationBarAppearance()
    scrollbarAppearance.configureWithOpaqueBackground()

    // Disable spacing views.
    let allSpacingViews: [UIView] = [topSpace, logoSpace]
    for view in allSpacingViews {
      view.isUserInteractionEnabled = false
      view.backgroundColor = .clear
    }
  }

  /// Sets properties for the app screen given the current device.
  func setUIDeviceProperties() {
    settingsCorner.layer.maskedCorners = .layerMaxXMinYCorner
    settingsCorner.layer.cornerRadius = DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05

    settingsBtn.setTitle("", for: .normal)
    settingsBtn.clipsToBounds = true
    settingsBtn.layer.masksToBounds = false
    settingsBtn.layer.cornerRadius = DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05

    let allTextViews: [UITextView] = [appTextView]

    // Disable text views.
    for textView in allTextViews {
      textView.isUserInteractionEnabled = false
      textView.backgroundColor = .clear
      textView.isEditable = false
    }

    // Set backgrounds and corner radii.
    appTextBackground.isUserInteractionEnabled = true
    appTextBackground.clipsToBounds = true
    applyCornerRadius(
      elem: appTextBackground,
      radius: DeviceType.isPad ? appTextBackground.frame.width * 0.02 : appTextBackground.frame.width * 0.05
    )

    // Set link attributes for all textViews.
    for textView in allTextViews {
      textView.linkTextAttributes = [
        NSAttributedString.Key.foregroundColor: linkBlueColor,
        NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    }
  }

  /// Sets the necessary properties for the installation UI including calling text generation functions.
  func setInstallationUI() {
    let settingsSymbol: UIImage = getSettingsSymbol(fontSize: fontSize * 0.9)
    topIconPhone.image = settingsSymbol
    topIconPad.image = settingsSymbol
    topIconPhone.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor
    topIconPad.tintColor = UITraitCollection.current.userInterfaceStyle == .dark ? scribeCTAColor : keyCharColor

    // Enable installation directions and GitHub notice elements.
    settingsBtn.isUserInteractionEnabled = true
    appTextBackground.backgroundColor = lightWhiteDarkBlackColor

    // Set the texts for the fields.
    appTextView.attributedText = setInstallation(fontSize: fontSize)
    appTextView.textColor = keyCharColor
  }

  /// Creates the current app UI by applying constraints and calling child UI functions.
  func setCurrentUI() {
    // Sets the font size for the text in the app screen and corresponding UIImage icons.
    if DeviceType.isPhone {
      if Locale.userSystemLanguage == "DE" {
        fontSize = UIScreen.main.bounds.height / 61
      } else {
        fontSize = UIScreen.main.bounds.height / 59
      }
    } else if DeviceType.isPad {
      fontSize = UIScreen.main.bounds.height / 50
    }

    installationHeaderLabel.text = NSLocalizedString(
      "settings.installation.header", comment: "The title of the installed keyboards section"
    )
    installationHeaderLabel.font = UIFont.boldSystemFont(ofSize: fontSize * 1.1)

    setAppTextView()
    setTopIcon()
    setSettingsBtn()
    setUIConstantProperties()
    setUIDeviceProperties()
    setInstallationUI()
  }

  /// Function to open the settings app that is targeted by settingsBtn.
  @objc func openSettingsApp() {
    guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
      fatalError("Failed to create settings URL.")
    }
    UIApplication.shared.open(settingsURL)
  }

  /// Function to change the key coloration given a touch down.
  ///
  /// - Parameters
  ///  - sender: the button that has been pressed.
  @objc func keyTouchDown(_ sender: UIButton) {
    sender.backgroundColor = .black
    sender.alpha = 0.2

    // Bring sender's opacity back up to fully opaque and replace the background color.
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
      sender.backgroundColor = .clear
      sender.alpha = 1.0
    }
  }
}
