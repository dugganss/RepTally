//
//  ExerciseDetector.swift
//  RepTally
//
//  Created by Samuel Duggan on 17/04/2025.
//
import CoreGraphics

class ExerciseDetector{
    var poseEstimator: PoseEstimator {
        return ModelSwitcher.shared.currentModel
    }
    
    var startRight: Bool = false
    var midRight: Bool = false
    var startLeft: Bool = false
    var midLeft: Bool = false
    var endLeft: Bool = false
    var endRight: Bool = false
    
    func detectExercise(){
        //Exercise tracking is currently disabled for Vision due to its irrelevance in the study.
        if poseEstimator.name != "Vision" && !SetTracker.shared.sets.isEmpty{
            switch (SetTracker.shared.currentSet()!.workout!){
            case Exercise.situp.description: detectSitup()
            case Exercise.bicepcurl.description: detectBicepCurl()
            case Exercise.squat.description: detectSquat()
            default: print("detecting exercise found an exercise that doesn't exist")
            }
        }
    }
    
    /*
     Creates vectors from points and applies the common dot product formula to calculate the
     angle between them, where pointB is the point of the angle.
     */
    func angleBetween(pointA: CGPoint, pointB: CGPoint, pointC: CGPoint) -> CGFloat {
        //formula adapted from Cuemath (n.d.) https://www.cuemath.com/geometry/angle-between-vectors/
        let vectorBA = CGVector(dx: pointA.x - pointB.x, dy: pointA.y - pointB.y)
        let vectorBC = CGVector(dx: pointC.x - pointB.x, dy: pointC.y - pointB.y)
        
        //formula, where x is the angle, a . b is the dot product and |n| refers to magnitude:
        // cos x = ( a . b ) / ( |a| |b| )
        
        let dotProd = vectorBA.dx * vectorBC.dx + vectorBA.dy * vectorBC.dy
        
        //standard euclidean distance
        let magnitudeBA = sqrt(vectorBA.dx * vectorBA.dx + vectorBA.dy * vectorBA.dy)
        let magnitudeBC = sqrt(vectorBC.dx * vectorBC.dx + vectorBC.dy * vectorBC.dy)
        
        //ensures the magnitude of the vectors is valid
        guard magnitudeBA > 0, magnitudeBC > 0 else {return 0}
        
        //perform formula, clamping result using min-max normalisation
        let cosTheta = min(1, max(-1, dotProd / (magnitudeBA * magnitudeBC)))
        
        //calculate angle and convert to degrees
        return acos(cosTheta) * 180.0 / .pi
        //end of adapted formula
    }
    
    //Finds sit ups by applying the state machine to the angle at the hip and ensuring angle at the knee is within a reasonable range (not straight)
    func detectSitup() {
        var isLeft: Bool
        var isRight: Bool
        var leftShoulder: CGPoint = CGPoint(x: 0, y: 0)
        var leftHip: CGPoint = CGPoint(x: 0, y: 0)
        var leftKnee: CGPoint = CGPoint(x: 0, y: 0)
        var rightShoulder: CGPoint = CGPoint(x: 0, y: 0)
        var rightHip: CGPoint = CGPoint(x: 0, y: 0)
        var rightKnee: CGPoint = CGPoint(x: 0, y: 0)
        var rightAnkle: CGPoint = CGPoint(x: 0, y: 0)
        var leftAnkle: CGPoint = CGPoint(x: 0, y: 0)
        
        if let leftShoulderVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_shoulder"], let leftHipVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_hip"], let leftKneeVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_knee"], let leftAnkleVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_ankle"] {
            isLeft = true
            leftShoulder = leftShoulderVal
            leftHip = leftHipVal
            leftKnee = leftKneeVal
            leftAnkle = leftAnkleVal
        }else {
            isLeft = false
        }
        
        if let rightShoulderVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_shoulder"], let rightHipVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_hip"], let rightKneeVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_knee"] , let rightAnkleVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_ankle"]{
            isRight = true
            rightShoulder = rightShoulderVal
            rightHip = rightHipVal
            rightKnee = rightKneeVal
            rightAnkle = rightAnkleVal
        } else {
            isRight = false
        }
        
        if isLeft {
            if angleBetween(pointA: leftHip, pointB: leftKnee, pointC: leftAnkle) < 130{
                let angleLeft = angleBetween(pointA: leftShoulder, pointB: leftHip, pointC: leftKnee)
                stateMachine(startAngle: 120, finishAngle: 65, measuredAngle: angleLeft, side: "left")
            }
        }
        
        if isRight {
            if angleBetween(pointA: rightHip, pointB: rightKnee, pointC: rightAnkle) < 130{
                let angleRight = angleBetween(pointA: rightShoulder, pointB: rightHip, pointC: rightKnee)
                stateMachine(startAngle: 120, finishAngle: 65, measuredAngle: angleRight, side: "right")
            }
        }
        
        // Counts either side and resets everything.
        if endLeft || endRight {
            SetTracker.shared.incrementRep()
            startLeft = false
            startRight = false
            midLeft = false
            midRight = false
            endLeft = false
            endRight = false
        }
    }
    
    // Finds bicep curls by applying the state machine to the angle at the elbow
    func detectBicepCurl(){
        var isLeft: Bool
        var isRight: Bool
        var leftShoulder: CGPoint = CGPoint(x: 0, y: 0)
        var leftElbow: CGPoint = CGPoint(x: 0, y: 0)
        var leftWrist: CGPoint = CGPoint(x: 0, y: 0)
        var rightShoulder: CGPoint = CGPoint(x: 0, y: 0)
        var rightElbow: CGPoint = CGPoint(x: 0, y: 0)
        var rightWrist: CGPoint = CGPoint(x: 0, y: 0)
        
        if let leftShoulderVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_shoulder"], let leftElbowVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_elbow"], let leftWristVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_wrist"] {
            isLeft = true
            leftShoulder = leftShoulderVal
            leftElbow = leftElbowVal
            leftWrist = leftWristVal
        }else {
            isLeft = false
        }
        
        if let rightShoulderVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_shoulder"], let rightElbowVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_elbow"], let rightWristVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_wrist"] {
            isRight = true
            rightShoulder = rightShoulderVal
            rightElbow = rightElbowVal
            rightWrist = rightWristVal
        } else {
            isRight = false
        }
        
        if isLeft {
            let angleLeft = angleBetween(pointA: leftShoulder, pointB: leftElbow, pointC: leftWrist)
            stateMachine(startAngle: 135, finishAngle: 50, measuredAngle: angleLeft, side: "left")
        }
        
        if isRight {
            let angleRight = angleBetween(pointA: rightShoulder, pointB: rightElbow, pointC: rightWrist)
            stateMachine(startAngle: 135, finishAngle: 50, measuredAngle: angleRight, side: "right")
        }
        
        // Counts rep for one arm at a time or both arms at a time. Resets mid and end for both arms regardless to prevent double counting.
        if endLeft || endRight {
            SetTracker.shared.incrementRep()
            if endLeft {
                startLeft = false
            }
            if endRight{
                startRight = false
            }
            midLeft = false
            endLeft = false
            midRight = false
            endRight = false
        }
    }
    
    // Finds squats by applying the state machine to the angle at the knee.
    func detectSquat(){
        var isLeft: Bool
        var isRight: Bool
        var leftHip: CGPoint = CGPoint(x: 0, y: 0)
        var leftKnee: CGPoint = CGPoint(x: 0, y: 0)
        var rightHip: CGPoint = CGPoint(x: 0, y: 0)
        var rightKnee: CGPoint = CGPoint(x: 0, y: 0)
        var leftAnkle: CGPoint = CGPoint(x: 0, y: 0)
        var rightAnkle: CGPoint = CGPoint(x: 0, y: 0)
        
        if let leftHipVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_hip"], let leftKneeVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_knee"], let leftAnkleVal: CGPoint = poseEstimator.pointNameToLocationMapping["left_ankle"] {
            isLeft = true
            leftHip = leftHipVal
            leftKnee = leftKneeVal
            leftAnkle = leftAnkleVal
        }else {
            isLeft = false
        }
        
        if let rightHipVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_hip"], let rightKneeVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_knee"] , let rightAnkleVal: CGPoint = poseEstimator.pointNameToLocationMapping["right_ankle"]{
            isRight = true
            rightHip = rightHipVal
            rightKnee = rightKneeVal
            rightAnkle = rightAnkleVal
        } else {
            isRight = false
        }
        
        if isLeft {

            let angleLeft = angleBetween(pointA: leftHip, pointB: leftKnee, pointC: leftAnkle)
            stateMachine(startAngle: 160.0, finishAngle: 95.0, measuredAngle: angleLeft, side: "left")
        }
        
        if isRight {

            let angleRight = angleBetween(pointA: rightHip, pointB: rightKnee, pointC: rightAnkle)
            stateMachine(startAngle: 160.0, finishAngle: 95.0, measuredAngle: angleRight, side: "right")
        }
        
        //ensures that if both legs are visible, both legs must have completed the rep for it to count
        if endRight || endLeft {
            if isRight && isLeft && endLeft && endRight {
                SetTracker.shared.incrementRep()
            }
            else if isRight && !isLeft && !endLeft && endRight {
                SetTracker.shared.incrementRep()
            }
            else if !isRight && isLeft && endLeft && !endRight {
                SetTracker.shared.incrementRep()
            }
            startLeft = false
            startRight = false
            midLeft = false
            midRight = false
            endLeft = false
            endRight = false
        }
    }
    
    // General state machine for tracking an exercise rep, both for left and right.
    func stateMachine(startAngle: CGFloat, finishAngle: CGFloat, measuredAngle: CGFloat, side: String){
        switch (side){
        case "right":
            if measuredAngle > startAngle && !startRight {
                startRight = true
                midRight = false
            }
            if measuredAngle < finishAngle && startRight {
                midRight = true
            }
            if measuredAngle > startAngle && startRight && midRight {
                endRight = true
            }
        case "left":
            if measuredAngle > startAngle && !startLeft {
                startLeft = true
                midLeft = false
            }
            if measuredAngle < finishAngle && startLeft {
                midLeft = true
            }
            if measuredAngle > startAngle && startLeft && midLeft {
                endLeft = true
            }
        default:
            print("Invalid side passed to state machine")
        }
    }
}

