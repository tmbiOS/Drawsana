//
//  WaveTool.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import Foundation

public class WaveTool: DrawingToolForShapeWithTwoPoints {
  override public var name: String {
    "WaveTool"
  }

  override public func makeShape() -> ShapeType {
    WaveShape(amplitude: 30.0, frequency: 30.0)
  }
}
