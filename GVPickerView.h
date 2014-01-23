//
//  MPickerView.h
//  CalculatorTips
//
//  Created by admin on 24.10.13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GVPickerView;

@protocol GVPickerViewDelegate <NSObject>
@optional
- (void)gvPickerView:(GVPickerView *)pickerView
     didSelectIndex:(NSInteger)index
          component:(NSInteger)component;

@end

@interface GVPickerView : UIView

@property (nonatomic, weak) id <GVPickerViewDelegate, UIPickerViewDelegate> delegate;
@property (nonatomic, weak) id <UIPickerViewDataSource> datasource;

@property (nonatomic, assign, readonly) BOOL isPresented;

- (void)show:(void(^)(BOOL finished))completion;
- (void)dismiss:(void(^)(BOOL finished))completion;

@end
