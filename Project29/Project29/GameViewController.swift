//
//  GameViewController.swift
//  Project29
//
//  Created by nikita on 20.04.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene?
    
    @IBOutlet var angleSlider: UISlider!
    @IBOutlet var angleLabel: UILabel!
    @IBOutlet var velocitySlider: UISlider!
    @IBOutlet var velocityLabel: UILabel!
    @IBOutlet var launchButton: UIButton!
    @IBOutlet var playerNumber: UILabel!
    
    @IBOutlet var player1Wind: UILabel!
    @IBOutlet var player2Wind: UILabel!
    @IBOutlet var playerOneScore: UILabel!
    @IBOutlet var playerTwoScore: UILabel!
    @IBOutlet var newGameButton: UIButton!
    
    var score1 = 0 {
        didSet {
            playerOneScore.text = "Score = \(score1)"
        }
    }
    
    var score2 = 0 {
        didSet {
            playerTwoScore.text = "Score = \(score2)"
        }
    }
    
    var gameStopped = false {
        didSet {
            newGameButton.isHidden = !gameStopped
        }
    }
    
    var wind: Wind!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameStopped = false
        score1 = 0
        score2 = 0
        
        wind = Wind.getRandomWind()
        player1Wind.attributedText = wind.getText()
        player1Wind.isHidden = false
        player2Wind.isHidden = true
        
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                currentGame = scene as? GameScene
                currentGame?.viewController = self
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
        angleChanged(self)
        velocityChanged(self)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func angleChanged(_ sender: Any) {
        angleLabel.text = "Angle: \(Int(angleSlider.value))°"
    }
    
    @IBAction func velocityChanged(_ sender: Any) {
        velocityLabel.text = "Velocity: \(Int(velocitySlider.value))"
    }
    
    @IBAction func launch(_ sender: Any) {
        currentGame?.launch(angle: Int(angleSlider.value), velocity: Int(velocitySlider.value))
    }
    
    func activatePlayer(number: Int) {
        wind = Wind.getRandomWind()
        
        if number == 1 {
            playerNumber.text = "<<< PLAYER ONE"
            player1Wind.attributedText = wind.getText()
            player1Wind.isHidden = false
            player2Wind.isHidden = true
        } else {
            playerNumber.text = "PLAYER TWO >>>"
            player2Wind.attributedText = wind.getText()
            player2Wind.isHidden = false
            player1Wind.isHidden = true
        }
        gameControls(isHidden: false)
    }
    
    func gameControls(isHidden: Bool) {
        angleSlider.isHidden = isHidden
        angleLabel.isHidden = isHidden
        velocitySlider.isHidden = isHidden
        velocityLabel.isHidden = isHidden
        launchButton.isHidden = isHidden
    }
    
    func playerScored(player: Int) {
        if player == 1 {
            score1 += 1
        }
        else {
            score2 += 1
        }
        
        if score1 == 3 {
            playerNumber.text = "PLAYER 1 WINS!!!"
            playerNumber.textColor = .red
            stopGame()
        }
        else if score2 == 3 {
            playerNumber.text = "PLAYER 2 WINS!!!"
            playerNumber.textColor = .red
            stopGame()
        }
    }
    
    func stopGame() {
        gameControls(isHidden: true)
        gameStopped = true
    }
    
    @IBAction func newGame(_ sender: Any) {
        gameStopped = false
        score2 = 0
        score1 = 0
        currentGame?.newGame()
    }
    
}

