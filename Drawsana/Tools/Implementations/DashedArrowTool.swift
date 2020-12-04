//
//  DashedArrowTool.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import Foundation

public class DashedArrowTool: DrawingToolForShapeWithTwoPoints {
  override public var name: String { "DashedArrow" }
  override public func makeShape() -> ShapeType {
    let shape = LineShape()
    shape.arrowStyle = .standard
    shape.dashPhase = 4
    shape.dashLengths = [8, 4]
    return shape
  }
}
