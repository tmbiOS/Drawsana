//
//  ImageTool.swift
//  Drawsana
//
//  Created by Andrey Rudenko on 04.12.2020.
//  Copyright © 2020 Asana. All rights reserved.
//

import CoreGraphics

public class ImageTool: DrawingToolForShapeWithOnePoint {

  override public var name: String {
    "ImageTool"
  }
  override open var drawingSize: CGSize {
    imageDrawingSize
  }

  private var imageName: String
  private var imageDrawingSize: CGSize

  public init(withImageName name: String, drawingSize: CGSize) {
    self.imageName = name
    self.imageDrawingSize = drawingSize
  }
  
  public override func makeShape() -> ShapeType { ImageShape(withImageName: imageName)
  }
}
