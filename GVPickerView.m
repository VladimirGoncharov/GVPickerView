//
//  MPickerView.m
//  CalculatorTips
//
//  Created by admin on 24.10.13.
//  Copyright (c) 2013 admin. All rights reserved.
//

#import "GVPickerView.h"

@interface GVPickerView ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *backgoroundView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeBarButtonItem;

@end

@implementation GVPickerView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self _updateInterface];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    if (self)
    {
        [self _updateInterface];
    }
    return self;
}

#pragma mark - notifications

- (void)_updateInterface
{
    self.doneBarButtonItem.title = @"Готово";
    self.closeBarButtonItem.title = @"Отмена";
}

#pragma mark - accessory

- (void)setDelegate:(id<GVPickerViewDelegate,UIPickerViewDelegate>)delegate
{
    _delegate                       = delegate;
    self.pickerView.delegate        = delegate;
}

- (void)setDatasource:(id<UIPickerViewDataSource>)datasource
{
    _datasource = datasource;
    self.pickerView.dataSource  = datasource;
}

#pragma mark - dislpay

- (void)show:(void (^)(BOOL))completion
{
    if (!self.isPresented)
    {
        _isPresented                    = YES;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        __weak typeof(self) wself       = self;
        
        UIView *rootView                = [[[[[UIApplication sharedApplication] delegate] window] rootViewController] view];
        [rootView addSubview:self];
        
        CGRect boundsScreen             = [UIScreen mainScreen].bounds;
        self.backgoroundView.alpha      = 0.0f;
        self.containerView.frame        = CGRectMake(0.0f, boundsScreen.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height);
        
        [UIView animateWithDuration:0.2f animations:^{
            wself.backgoroundView.alpha = 0.5f;
            wself.containerView.frame                 = CGRectMake(0.0f,
                                                                   boundsScreen.size.height - self.containerView.frame.size.height,
                                                                   self.containerView.frame.size.width,
                                                                   self.containerView.frame.size.height);
        } completion:^(BOOL finished) {
            double delayInSeconds = 0.2f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                if (completion)
                {
                    completion(finished);
                }
            });
        }];
    }
    else
    {
#if DEBUG
        NSLog(@"view is shown");
#endif
        if (completion)
        {
            completion(YES);
        }
    }
}

- (void)dismiss:(void (^)(BOOL finished))completion
{
    if (self.isPresented)
    {
        _isPresented                    = NO;
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        __weak typeof(self) wself       = self;
        
        CGRect boundsScreen             = [UIScreen mainScreen].bounds;
        
        [UIView animateWithDuration:0.2f animations:^{
            wself.backgoroundView.alpha = 0.0f;
            wself.containerView.frame        = CGRectMake(0.0f, boundsScreen.size.height, self.containerView.frame.size.width, self.containerView.frame.size.height);
        } completion:^(BOOL finished) {
            [wself removeFromSuperview];
            
            double delayInSeconds = 0.2f;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if (completion)
                {
                    completion(finished);
                }
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            });
        }];
    }
    else
    {
#if DEBUG
        NSLog(@"view not shown");
#endif
        if (completion)
        {
            completion(YES);
        }
    }
}

#pragma mark - action's

- (IBAction)doneHandler:(UIBarButtonItem *)sender
{
    if ([self.delegate respondsToSelector:@selector(gvPickerView:didSelectIndex:component:)])
    {
        for (NSInteger i = 0; i < self.pickerView.numberOfComponents; i++)
        {
            [self.delegate gvPickerView:self
                        didSelectIndex:[self.pickerView selectedRowInComponent:i]
                             component:i];
        }
    }
}

- (IBAction)cancelHandler:(UIBarButtonItem *)sender
{
    [self dismiss:nil];
}

@end
