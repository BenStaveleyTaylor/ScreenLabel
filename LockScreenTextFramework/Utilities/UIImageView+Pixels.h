//
//  UIImageView+Pixels.h
//  DeleteMe
//
//  Created by Ben Staveley-Taylor on 04/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (Pixels)

/**
 Get the color of a point in an image

 @param point Point to inspect in the frame of the image bounds rect
 @return Colour at the point, or nil if the point was out of the bounds.
 */
- (nullable UIColor *) colorAtPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
