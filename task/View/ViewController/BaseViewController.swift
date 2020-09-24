//
//  task
//
//  Created by islam on 9/23/20.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

func maxHeight(wallPositions : [Int],wallHeights : [Int]) -> Int{
    
    var positionsCount = wallPositions.count;
    var heightCount = wallHeights.count;
    var max = 0;

    for i in 0..<positionsCount-1{
        if (wallPositions[i]<wallPositions[i+1]-1) {
            // We have a gap
            var heightDiff = abs(wallHeights[i+1] - wallHeights[i]);
            var gapLen = wallPositions[i+1] - wallPositions[i] - 1;
            var localMax = 0
            if (gapLen > heightDiff) {
                var low = Swift.max(wallHeights[i+1], wallHeights[i]) + 1;
                var remainingGap = gapLen - heightDiff - 1;
                localMax = low + remainingGap/2;

            } else {
                localMax = min(wallHeights[i+1], wallHeights[i]) + gapLen;
            }

            max = Swift.max(max, localMax);
        }
    }

    return max;
}

