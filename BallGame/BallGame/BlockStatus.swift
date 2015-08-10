//
//  BlockStatus.swift
//  BallGame
//
//  Created by GreggColeman on 8/3/15.
//  Copyright (c) 2015 Gregg Coleman. All rights reserved.
//

import Foundation

class BlockStatus{
    var isRunning = false
    var timeGapForNextRun = UInt32(0)
    var currentInterval = UInt32(0)
    
    init(isRunning:Bool, timeGapForNextRun:UInt32, currentInterval:UInt32)
    {
        self.isRunning = isRunning
        self.timeGapForNextRun  = timeGapForNextRun
        self.currentInterval = currentInterval
    }
    
    func shouldRunBlock() -> Bool {
        return self.currentInterval > self.timeGapForNextRun
    }
}