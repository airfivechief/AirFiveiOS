//
//  UIUnderlinedButton.m
//  AirFiveiOS
//
//  Created by Joshua Gafni on 8/10/15.
//  Copyright (c) 2015 AirFive. All rights reserved.
//

#import "UIUnderlinedButton.h"

@implementation UIUnderlinedButton

- (void)setUnderline:(bool)underline
{
    _underline = underline;
    [self setNeedsDisplay];
}

//http://stackoverflow.com/questions/2630004/underlining-text-in-uibutton
- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    
    if(self.underline){
        // need to put the line at top of descenders (negative value)
        CGFloat descender = self.titleLabel.font.descender;
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        
        // set to same colour as text
        CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
        
        CGContextSetLineWidth(contextRef, 2.0);
        
        CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender + 9);
        
        CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender + 9);
        
        CGContextClosePath(contextRef);
        
        CGContextDrawPath(contextRef, kCGPathStroke);
    }
}


@end
