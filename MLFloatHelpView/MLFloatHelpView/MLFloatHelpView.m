//
//  MLFloatHelpView.m
//  PRJ_HQHD_BTN
//
//  Created by MacPro-Mr.Lu on 13-10-31.
//  Copyright (c) 2013年 MacPro-Mr.Lu. All rights reserved.
//

#import "MLFloatHelpView.h"

#define KFlowHelpViewHeight 40
#define KFlowHelpViewWidth	40

#define KFlowHelpViewNormalImage
#define KFlowHelpViewSelectImage

#define KFlowHelpBoundsVerEdgeSpace 100
#define KFlowHelpAnimationDuration	0.2
#define KFlowHelpAlpha 0.6

#define KFlowActionAreaWidth		[UIScreen mainScreen].bounds.size.width
#define KFlowActionAreaHeight		[UIScreen mainScreen].bounds.size.height

typedef enum {
	KFlowHelpViewpositionTop	= 0,
	KFlowHelpViewpositionBottom = 1,
	KFlowHelpViewpositionLeft	= 2,
	KFlowHelpViewpositionRight	= 3
} KFlowHelpViewposition;

@interface MLFloatHelpView ()

@property (strong, nonatomic) NSMutableDictionary	*locateMapDictionary;
@property (assign, nonatomic) CGPoint				offset;
@property (strong, nonatomic) UIWindow *bjFloatViewWindow;

@end

@implementation MLFloatHelpView

- (void)dealloc
{

}

+ (instancetype)shareInstance
{
    static MLFloatHelpView *sharedBJFlowHelpView = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedBJFlowHelpView = [[MLFloatHelpView alloc] init];
    });
    return sharedBJFlowHelpView;
}


- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
        _actionSize = CGSizeMake(KFlowActionAreaWidth, KFlowActionAreaHeight);
        _size = CGSizeMake(KFlowHelpViewHeight, KFlowHelpViewWidth);
        _edgeInset = UIEdgeInsetsZero;
        _point = CGPointZero;
        _verAttachVaileDistance = KFlowHelpBoundsVerEdgeSpace;
        _attachBound = YES;
        _bounces = YES;
        self.frame = CGRectMake(0, 0, _size.width, _size.height);
	}
	return self;
}

- (void)showInView:(nullable UIView *)view
{
    if (view==nil) {
        view = [[UIApplication sharedApplication].delegate window];
    }
    if (self.superview) {
        if ([self.superview isEqual:view]) {
            return;
        }
    }
    [view addSubview:self];
    _actionSize = view.bounds.size;
}

- (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //通知主线程刷新
        [self removeFromSuperview];
    });
}

- (UIWindow *)bjFloatViewWindow
{
    if (!_bjFloatViewWindow) {
        _bjFloatViewWindow = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _bjFloatViewWindow.rootViewController = [[UIViewController alloc] init];
        [_bjFloatViewWindow setWindowLevel:UIWindowLevelNormal+1];
    }
    return _bjFloatViewWindow;
}

//- (void)hidden
//{
//    [self setHidden:YES];
//}

/*!
 *  @author Mrlu, 15-07-03 15:07
 *
 *  @brief  背景动画
 *
 *  @since 2.4.0
 */
- (void)viewStyleAnimation
{
	[UIView animateWithDuration:1 delay:6 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction animations:^{
		self.backgroundColor = [UIColor colorWithRed:150.0 / 255.0 green:150.0 / 255.0 blue:150.0 / 255.0 alpha:0.4];
	} completion:^(BOOL finished) {}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
	self.offset = CGPointZero;
	if (touch.phase == UITouchPhaseBegan) {
		CGPoint touchPoint = [touch locationInView:self];
		self.offset = CGPointMake(touchPoint.x - _size.width / 2, touchPoint.y - _size.height / 2);
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];

	if (touch.phase == UITouchPhaseMoved) {
		CGPoint latMovedPoint = [touch locationInView:self];

		if ([self isContainsInView:latMovedPoint]) {
			CGPoint latTouchWindow = [touch locationInView:[UIApplication sharedApplication].keyWindow];
            [self followMoving:latTouchWindow];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];

	if (touch.phase == UITouchPhaseEnded) {
		CGPoint endPoint = [touch locationInView:self];
        if (_attachBound) {
            [self attachToBounds:endPoint];
        } else {
            _point = self.center;
        }
		//背景动画
		//[self viewStyleAnimation];
	}
}

/**
 *	切近那个边缘
 *
 *	@param	endPoint	最后的点
 */
- (void)attachToBounds:(CGPoint)endPoint
{
	if (self.center.x > _actionSize.width / 2) { //贴边右边
		if ((_verAttachVaileDistance > _actionSize.height - self.center.y) && (_verAttachVaileDistance > self.center.y)) {
			if (_verAttachVaileDistance >_actionSize.height - self.center.y) {
				if (_actionSize.height - self.center.y < _actionSize.width - self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionBottom];
				} else {
					[self attachAnimation:KFlowHelpViewpositionRight];
				}
			}

			if (_verAttachVaileDistance > self.center.y) {
				if (self.center.y < _actionSize.width - self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionTop];
				} else {
					[self attachAnimation:KFlowHelpViewpositionRight];
				}
			}
		} else {
			[self attachAnimation:KFlowHelpViewpositionRight];
		}
	} else { //贴边左边
		if (( _verAttachVaileDistance > _actionSize.height - self.center.y) && (_verAttachVaileDistance > self.center.y)) {
			if (_verAttachVaileDistance > _actionSize.height - self.center.y) {
				if (_actionSize.height - self.center.y < self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionBottom];
				} else {
					[self attachAnimation:KFlowHelpViewpositionLeft];
				}
			}

			if (_verAttachVaileDistance > self.center.y) {
				if (self.center.y < self.center.x) {
					[self attachAnimation:KFlowHelpViewpositionTop];
				} else {
					[self attachAnimation:KFlowHelpViewpositionLeft];
				}
			}
		} else {
			[self attachAnimation:KFlowHelpViewpositionLeft];
		}
	}
}

/**
 *  停止之后靠近边缘的动画
 *
 *	@param	positon	靠近那个边缘
 */
- (void)attachAnimation:(KFlowHelpViewposition)positon
{
    void(^animations)(void)=^{
        if (positon == KFlowHelpViewpositionTop) {
            CGPoint newPoint = self.center;
            
            if (self.center.x < _size.width / 2 +_edgeInset.left) {
                newPoint.x = _size.width / 2 +_edgeInset.left;
            }
            
            if (self.center.x > _actionSize.width - _size.width / 2 - _edgeInset.right) {
                newPoint.x = _actionSize.width - _size.width / 2 - _edgeInset.right;
            }
            
            self.center = CGPointMake(newPoint.x, _size.height / 2+_edgeInset.top);
        }
        
        if (positon == KFlowHelpViewpositionBottom) {
            CGPoint newPoint = self.center;
            
            if (self.center.x < _size.width / 2 +_edgeInset.left) {
                newPoint.x = _size.width / 2 +_edgeInset.left;
            }
            
            if (self.center.x > _actionSize.width - _size.width / 2 - _edgeInset.right) {
                newPoint.x = _actionSize.width - _size.width / 2 - _edgeInset.right;
            }
            
            self.center = CGPointMake(newPoint.x, _actionSize.height - _size.height / 2 - _edgeInset.bottom);
        }
        
        if (positon == KFlowHelpViewpositionLeft) {
            CGPoint newPoint = self.center;
            
            if (self.center.y < _size.height / 2 + _edgeInset.top) {
                newPoint.y = _size.height / 2 + _edgeInset.top;
            }
            
            if (self.center.y > _actionSize.height - _size.height / 2 - _edgeInset.bottom) {
                newPoint.y = _actionSize.height - _size.height / 2 - _edgeInset.bottom;
            }
            
            self.center = CGPointMake(_size.height / 2+_edgeInset.left, newPoint.y);
        }
        
        if (positon == KFlowHelpViewpositionRight) {
            CGPoint newPoint = self.center;
            
            if (self.center.y < _size.height / 2 + _edgeInset.top) {
                newPoint.y = _size.height / 2 + _edgeInset.top;
            }
            
            if (self.center.y > _actionSize.height - _size.height / 2 - _edgeInset.bottom) {
                newPoint.y = _actionSize.height - _size.height / 2 - _edgeInset.bottom;
            }
            
            self.center = CGPointMake(_actionSize.width - _size.height / 2 - _edgeInset.right, newPoint.y);
        }
    };
	[UIView animateWithDuration:KFlowHelpAnimationDuration delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
			animations:animations completion:^(BOOL finished) {
                _point = self.center;
            }];
}

/**
 *	判断点触摸点是否在视图内
 *
 *	@param	point	检测的点
 *
 *	@return	是否在视图内
 */
- (BOOL)isContainsInView:(CGPoint)point
{
	if (((point.x > _size.width) && (point.x < 0.0)) || ((point.y > _size.height) && (point.y < 0.0))) {
		return NO;
	} else {
		return YES;
	}
}

- (void)followMoving:(CGPoint)locate{
    CGFloat x = locate.x - self.offset.x;
    CGFloat y = locate.y - self.offset.y;
    
    if (!_bounces) {
        //left min
        if (x<_edgeInset.left+_size.width/2) {
            x = _edgeInset.left+_size.width/2;
        }
        //right max
        if (x> _actionSize.width - _edgeInset.right - _size.width/2) {
            x = _actionSize.width - _edgeInset.right - _size.width/2;
        }
        //top min
        if (y<_edgeInset.top +_size.height/2) {
            y = _edgeInset.top+_size.height/2;
        }
        
        //bottom max
        if (y> _actionSize.height - _edgeInset.bottom - _size.height/2) {
            y = _actionSize.height - _edgeInset.bottom - _size.height/2;
        }
    }
    
    self.center = CGPointMake(x, y);
}

- (void)setPoint:(CGPoint)point
{
    _point = point;
    [self layout];
    [self setNeedsLayout];
}

- (void)setSize:(CGSize)size
{
    _size = size;
    [self layout];
    [self setNeedsLayout];
}

- (void)setEdgeInset:(UIEdgeInsets)edgeInset
{
    _edgeInset = edgeInset;
    [self layout];
    [self setNeedsLayout];
}

- (void)setAttachBound:(BOOL)attachBound
{
    _attachBound = attachBound;
    if (!attachBound) {
        _bounces = NO;
    }
}

- (void)setBounces:(BOOL)bounces
{
    _bounces = bounces;
    if (!_attachBound) {
        _bounces = NO;
    }
}

- (void)layout
{
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame),
                              _size.width, _size.height)];
    [self setCenter:_point];
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
//    [self.bjFloatViewWindow setHidden:hidden];
}

@end

