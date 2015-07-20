import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var scene: GameScene!
    var level: Level!
    var movesLeft = 0
    var score = 0
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var shuffleButton: UIButton!
    
    @IBOutlet weak var gameOverPanel: UIImageView!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    @IBAction func shuffleButtonPressed(AnyObject) {
        shuffle()
        decrementMoves()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        scene.swipeHandler = handleSwipe
        // Present the scene.
        gameOverPanel.hidden = true
        skView.presentScene(scene)
        level = Level(filename: "Level_1")
        scene.level = level
        scene.addTiles()
        beginGame()
    }
    
    func beginGame() {
        movesLeft = level.maximumMoves
        score = 0
        level.resetComboMultiplier()
        updateLabels()
        scene.animateBeginGame() {
            self.shuffleButton.hidden = false
        }
   
        shuffle()
        
    }
    
    func shuffle() {
        scene.removeAllCookieSprites()
        let newCookies = level.shuffle()
        scene.addSpritesForCookies(newCookies)
    }
    
    func handleSwipe(swap: Swap) {
        view.userInteractionEnabled = false
        
        if level.isPossibleSwap(swap) {
            level.performSwap(swap)
            scene.animateSwap(swap, completion: handleMatches);
            //scene.animateSwap(swap) {
               // self.view.userInteractionEnabled = true
            //}
        } else {
            scene.animateInvalidSwap(swap) {
                self.view.userInteractionEnabled = true
            }
         //   view.userInteractionEnabled = true
        }
    }
    
    func handleMatches() {
        let chains = level.removeMatches()
        if chains.count == 0 {
            beginNextTurn()
            return
        }
        // TODO: do something with the chains set
        scene.animateMatchedCookies(chains) {
            for chain in chains {
                self.score += chain.score
            }
            self.updateLabels()
            // self.view.userInteractionEnabled = true
            let columns = self.level.fillHoles()
            self.scene.animateFallingCookies(columns) {
                let columns = self.level.topUpCookies()
                self.scene.animateNewCookies(columns){
                    self.handleMatches()
                }
            }
        }
    }
    
    func beginNextTurn() {
        level.resetComboMultiplier()
        level.detectPossibleSwaps()
        view.userInteractionEnabled = true
        decrementMoves()
    }
    
    func updateLabels() {
        targetLabel.text = String(format: "%ld", level.targetScore)
        movesLabel.text = String(format: "%ld", movesLeft)
        scoreLabel.text = String(format: "%ld", score)
    }
    
    func decrementMoves() {
        --movesLeft
        updateLabels()
        if score >= level.targetScore {
            gameOverPanel.image = UIImage(named: "LevelComplete")
            showGameOver()
        } else if movesLeft == 0 {
            gameOverPanel.image = UIImage(named: "GameOver")
            showGameOver()
        }

        
    }

    func showGameOver() {
        gameOverPanel.hidden = false
        shuffleButton.hidden = true
        scene.userInteractionEnabled = false
        scene.animateGameOver() {
            self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "hideGameOver")
            self.view.addGestureRecognizer(self.tapGestureRecognizer)
        }
    }
    
    func hideGameOver() {
        view.removeGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer = nil
        
        gameOverPanel.hidden = true
        scene.userInteractionEnabled = true
        
        beginGame()
    }
    

}