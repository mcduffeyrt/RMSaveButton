//
//  RMSaveButton.h
//
//  Created by Richard McDuffey on 5/20/15.
//  Copyright (c) 2015 Richard McDuffey. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import <UIKit/UIKit.h>


IB_DESIGNABLE @interface RMSaveButton : UIControl

///Label of the button. Default is SAVE.
@property (nonatomic, copy) IBInspectable NSString *label;

///Color of the the button background. Default is rgb(43, 189, 224)
@property (nonatomic, strong) IBInspectable UIColor *foregroundColor;

///Color of the button when highlighed. Default is rgb(108, 164, 176)
@property (nonatomic, strong) IBInspectable UIColor *highlightedColor;

///Block that is called when the button is pressed.
@property (nonatomic, copy) void (^startHandler) (void);

///Block that is called when the button is pressed before the download process is complete.
@property (nonatomic, copy) void (^interruptHandler)(void);

///Optional block that can be called after the download process is completed.
@property (nonatomic, copy) void (^completionHandler)(void);

///Performs out going animation. Must be called to end the process animation.
- (void)endAnimation;

///Resets button to default state.
- (void)resetButton;

@end
