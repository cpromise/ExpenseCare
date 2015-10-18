//
//  ExpenseScrollView.m
//  절약왕소희
//
//  Created by SH on 2015. 9. 30..
//  Copyright © 2015년 SH. All rights reserved.
//

#import "ExpenseScrollView.h"

@implementation ExpenseScrollView{
    BOOL hasValidRect;
    CGRect scrollRect;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init{
    hasValidRect = NO;
    return [super init];
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
//    return [super hitTest:point withEvent:event];
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (hasValidRect) {
        if (CGRectContainsPoint(scrollRect, point)) {
            return YES;
        }
    }
    return NO;
}

- (void)setValidRect:(CGRect)validRect{
    hasValidRect = YES;
    scrollRect = validRect;
}



@end
