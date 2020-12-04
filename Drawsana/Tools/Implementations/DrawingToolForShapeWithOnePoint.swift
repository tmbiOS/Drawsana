//
//  DrawingToolForShapeWithOnePoint.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import Foundation

open class DrawingToolForShapeWithOnePoint: DrawingTool {
  public typealias ShapeType = Shape & ShapeWithTwoPoints

  open var name: String {
    fatalError("Override me")
  }

  open var drawingSize: CGSize {
    fatalError("Override me")
  }

  public var shapeInProgress: ShapeType?

  public var isProgressive: Bool {
    false
  }

  public init() { }

  /// Override this method to return a shape ready to be drawn to the screen.
  open func makeShape() -> ShapeType {
    fatalError("Override me")
  }

  public func handleTap(context: ToolOperationContext, point: CGPoint) {

    shapeInProgress = makeShape()

    let startPointX = point.x - (drawingSize.width / 2.0)
    let startPointY = point.y - (drawingSize.height / 2.0)
    let startPoint = CGPoint(x: startPointX, y: startPointY)

    let endPointX = point.x + (drawingSize.width / 2.0)
    let endPointY = point.y + (drawingSize.height / 2.0)
    let endPoint = CGPoint(x: endPointX, y: endPointY)

    shapeInProgress?.a = startPoint
    shapeInProgress?.b = endPoint
    shapeInProgress?.apply(userSettings: context.userSettings)

    guard let shape = shapeInProgress else { return }

    context.operationStack.apply(operation: AddShapeOperation(shape: shape))
    shapeInProgress = nil
  }

  public func handleDragStart(context: ToolOperationContext, point: CGPoint) {
  }

  public func handleDragContinue(context: ToolOperationContext, point: CGPoint, velocity: CGPoint) {
  }

  public func handleDragEnd(context: ToolOperationContext, point: CGPoint) {
  }

  public func handleDragCancel(context: ToolOperationContext, point: CGPoint) {
    handleDragEnd(context: context, point: point)
  }

  public func renderShapeInProgress(transientContext: CGContext) {
    shapeInProgress?.render(in: transientContext)
  }

  public func apply(context: ToolOperationContext, userSettings: UserSettings) {
    shapeInProgress?.apply(userSettings: userSettings)
    context.toolSettings.isPersistentBufferDirty = true
  }
}
