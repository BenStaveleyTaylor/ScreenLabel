//
//  UIImageView+Pixels.m
//  DeleteMe
//
//  Created by Ben Staveley-Taylor on 04/12/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

#import "UIImageView+Pixels.h"

@implementation UIImageView (Pixels)

- (UIColor *) colorAtPoint:(CGPoint)point
{
    UIImage *image = self.image;
    CGImageRef cgImage = image.CGImage;

    if (!cgImage) {
        return nil;
    }

    unsigned char pixels[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    NSUInteger cgWidth = CGImageGetWidth(cgImage);
    NSUInteger cgHeight = CGImageGetHeight(cgImage);
    CGFloat xScale = (CGFloat)cgWidth/(CGFloat)self.bounds.size.width;
    CGFloat yScale = (CGFloat)cgHeight/(CGFloat)self.bounds.size.height;

    // Copy just the one pixel we want into a buffer where we can inspect its components

    CGContextRef context = CGBitmapContextCreate(pixels,
                                                 1, // width
                                                 1, // height
                                                 8, // bitsPerComponent
                                                 4, // bytesPerRow
                                                 colorSpace,
                                                 kCGImageAlphaNoneSkipLast);

    // CG-space is flipped vertically
    CGFloat flippedY = self.bounds.size.height-point.y;

    CGContextDrawImage(context,
                       CGRectMake(-point.x * xScale,
                                  -flippedY * yScale,
                                  cgWidth,
                                  cgHeight),
                       cgImage);

    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    CGFloat red = pixels[0]/255.0;
    CGFloat green = pixels[1]/255.0;
    CGFloat blue = pixels[2]/255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

@end
