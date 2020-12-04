//
//  CurvedTool.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import Foundation

public class CurvedTool: DrawingToolForShapeWithTwoPoints {
  override public var name: String {
    "CurvedTool"
  }

  override public func makeShape() -> ShapeType { CurvedShape()
  }
}
