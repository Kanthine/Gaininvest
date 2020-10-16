//
//  TransactionBuyUpOrDownView.m
//  GainInvest
//
//  Created by 苏沫离 on 17/2/23.
//  Copyright © 2017年 苏沫离. All rights reserved.
//

#define AnimationDuration 0.2

#import "TransactionBuyUpOrDownView.h"


#import "TransactionViewController.h"
#import "RechargeViewController.h"

#import "UIColor+Y_StockChart.h"

#pragma mark - 商品种类
    
@interface MetalKindView : UIView
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *countPriceLabel;
@property (nonatomic ,strong) UILabel *bottomLable;
@property (nonatomic ,strong) UIButton *button;
@property (nonatomic ,assign) BOOL isSelected;
- (void)updateInfo:(ProductInfoModel *)info;
@end

@implementation MetalKindView

/**
 * @param name 商品名称
 * @param uPrice 商品单价
 */
- (instancetype)initWithFrame:(CGRect)frame name:(NSString *)name uPrice:(NSString *)uPrice{
    self = [super initWithFrame:frame];
    if (self){
        _isSelected = NO;
        self.backgroundColor = RGBA(240, 242, 245, 1);
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        self.layer.borderWidth = 1;
        self.layer.borderColor = RGBA(237, 238, 240, 1).CGColor;
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), 16)];
        topLable.text = @"白银 300元/千克";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:topLable];
        _nameLabel = topLable;
        
        UILabel *bottomLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 16 - 8,CGRectGetWidth(frame), 16)];
        bottomLable.tag = 3;
        bottomLable.text = @"元/手";
        bottomLable.textColor = TextColorGray;
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:bottomLable];
        _bottomLable = bottomLable;
        UILabel *middleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (CGRectGetHeight(frame) - 30) / 2.0, CGRectGetWidth(frame), 30)];
        middleLable.text = @"200";
        middleLable.textColor = TextColorGray;
        middleLable.textAlignment = NSTextAlignmentCenter;
        middleLable.font = [UIFont systemFontOfSize:25];
        [self addSubview:middleLable];
        _countPriceLabel = middleLable;
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = self.bounds;
        _button.backgroundColor = UIColor.clearColor;
        [self addSubview:_button];
    }
    
    return self;
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    if (isSelected){
        self.backgroundColor = RGBA(240, 242, 245, 1);
        _nameLabel.textColor = [UIColor blackColor];
        _countPriceLabel.textColor = [UIColor blackColor];
        _bottomLable.textColor = [UIColor blackColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        _nameLabel.textColor = TextColorGray;
        _countPriceLabel.textColor = TextColorGray;
        _bottomLable.textColor = TextColorGray;
    }
}

- (void)updateInfo:(ProductInfoModel *)info{
    _nameLabel.text = [NSString stringWithFormat:@"%@ %@%@/%@",info.name,info.weight,info.unit,info.spec];
    _countPriceLabel.text = [NSString stringWithFormat:@"%@",info.price];
}

@end


#pragma mark - 滑块

@interface TransactionSlideView : UIView
@property (nonatomic ,strong) UILabel *currentValueLabel;
@property (nonatomic ,strong) UILabel *minValueLabel;
@property (nonatomic ,strong) UILabel *maxValueLabel;
@property (nonatomic ,strong) UISlider *slide;
@property (nonatomic ,strong) UIButton *leftButton;
@property (nonatomic ,strong) UIButton *rightButton;
@end

@implementation TransactionSlideView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor clearColor];

        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), 16)];
        topLable.text = @"止损：不限";
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentCenter;
        topLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:topLable];
        _currentValueLabel = topLable;
        
        UIImageView *leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyDown"]];
        leftImageView.frame = CGRectMake(10, CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        leftImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:leftImageView];
        
        UIImageView *rightImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Transaction_BuyUp"]];
        rightImageView.frame = CGRectMake(CGRectGetWidth(frame) - 30,CGRectGetMaxY(topLable.frame) + 5, 20, 20);
        rightImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:rightImageView];
        
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftImageView.frame), leftImageView.frame.origin.y, 60, CGRectGetHeight(leftImageView.frame))];
        leftLable.text = @"不限";
        leftLable.textColor = TextColorGray;
        leftLable.textAlignment = NSTextAlignmentCenter;
        leftLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:leftLable];
        _minValueLabel = leftLable;
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame) - 60, rightImageView.frame.origin.y , 60, CGRectGetHeight(leftImageView.frame))];
        rightLable.text = @"50点";
        rightLable.textColor = TextColorGray;
        rightLable.textAlignment = NSTextAlignmentCenter;
        rightLable.font = [UIFont systemFontOfSize:14];
        [self addSubview:rightLable];
        _maxValueLabel = rightLable;
        
        UISlider *slide = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftLable.frame), rightImageView.frame.origin.y , CGRectGetWidth(frame) - 2 * CGRectGetMaxX(leftLable.frame), 30)];
        slide.minimumValue = 0;
        slide.maximumValue = 5;
        [slide setValue:0 animated:YES];
        slide.center = CGPointMake(topLable.center.x, rightImageView.center.y);
        [self addSubview:slide];
        _slide = slide;
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, 7, CGRectGetMaxX(leftLable.frame) - 10, 35);
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(CGRectGetWidth(frame) - CGRectGetWidth(_leftButton.frame), _leftButton.frame.origin.y, CGRectGetWidth(_leftButton.frame), CGRectGetHeight(_leftButton.frame));
        [self addSubview:_rightButton];
    }
    return self;
}

@end





@interface TransactionBuyUpOrDownView()

{
    BOOL _isUseCoupon;
    
    NSArray<ProductInfoModel *> *_productListArray;
}

/** 遮盖 */
@property (nonatomic, strong) UIButton *coverButton;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) MetalKindView *kindLeftView;
@property (nonatomic, strong) MetalKindView *kindMiddleView;
@property (nonatomic, strong) MetalKindView *kindRightView;

@property (nonatomic, strong) TransactionSlideView *slideCountView;///买几手
@property (nonatomic, strong) UIButton *couponButton;///是否使用体验券
@property (nonatomic, strong) TransactionSlideView *slideGainView;///止盈
@property (nonatomic, strong) TransactionSlideView *slideLossView;///止损

@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation TransactionBuyUpOrDownView

#pragma mark - Private Method

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _isUseCoupon = NO;
        [self addSubview:self.coverButton];
        [self addSubview:self.contentView];
    }
    return self;
}

#pragma mark - Public Method

- (void)setIsBuyUp:(BOOL)isBuyUp
{
    _isBuyUp = isBuyUp;
    
    UIButton *buyUpButton = [self.contentView viewWithTag:20];
    UIButton *buyDownButton = [self.contentView viewWithTag:30];
    if (isBuyUp)
    {
        buyUpButton.selected = YES;
        buyDownButton.selected = NO;
    }
    else
    {
        buyUpButton.selected = NO;
        buyDownButton.selected = YES;
    }
    [self setBuyUPButtonSelectStateButton:buyUpButton];
    [self setBuyUPButtonSelectStateButton:buyDownButton];
    
}

- (void)setBalanceOfAccountString:(NSString *)balanceOfAccountString
{
    _balanceOfAccountString = balanceOfAccountString;
    
    UILabel *topLable = [self.contentView viewWithTag:1];
    topLable.text = [NSString stringWithFormat:@"余额：%@元",balanceOfAccountString];
}

- (void)setCouponNumberString:(NSString *)couponNumberString
{
    _couponNumberString = couponNumberString;
    
    UILabel *couponLable = [self.slideCountView viewWithTag:7];
    couponLable.text = [NSString stringWithFormat:@"使用体验券(当前可用%@张)",couponNumberString];
    UIButton *couponButton = [self.slideCountView viewWithTag:9];

    if ([couponNumberString isEqualToString:@"0"])
    {
        UIImageView *couponImageView = [self.slideCountView viewWithTag:8];
        couponImageView.highlighted = NO;
        
        couponButton.selected = NO;
        couponButton.enabled = NO;
        
        _isUseCoupon = NO;
    }
    else
    {
        couponButton.enabled = YES;
    }
}


- (void)updateBuyUpOrDownProductInfo:(NSArray<ProductInfoModel *> *)array{
    _productListArray = array;
    
    [self.kindLeftView updateInfo:array.firstObject];
    [self.kindMiddleView updateInfo:array[1]];
    [self.kindRightView updateInfo:array[2]];
    //更新底部信息
    [self updateBottomViewInfo];
}

// 出现
- (void)show{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    
    NSLog(@"keyWindow == %@",[UIApplication sharedApplication].keyWindow.subviews);
    
    
    [UIView animateWithDuration:AnimationDuration animations:^{
         self.contentView.transform = CGAffineTransformMakeTranslation(0, - CGRectGetMaxY(self.bottomView.frame));
         self.coverButton.alpha = 0.3;
     }];
}

- (void)dismissPickerView{
    [self dismissPickerViewWithNeedTip:NO Error:nil];
}

// 消失
- (void)dismissPickerViewWithNeedTip:(BOOL)isNeed Error:(NSError *)error{
    [UIView animateWithDuration:AnimationDuration animations:^{
         self.contentView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMaxY(self.bottomView.frame));
         self.coverButton.alpha = 0.0;
     } completion:^(BOOL finished) {
         [self removeFromSuperview];
         if (isNeed){
             self.transactionResultTip(error);
         }
     }];
}

#pragma mark - UpDate UI Stste

- (void)setBuyUPButtonSelectStateButton:(UIButton *)sender
{
    if (sender.selected)
    {
        if (sender.tag == 20)
        {
            //买涨
            
            sender.layer.borderColor = RGBA(252, 71, 75, 1).CGColor;
            sender.backgroundColor = [UIColor decreaseColor];
            
            UIButton *orderButton = [self.bottomView viewWithTag:4];
            orderButton.backgroundColor = [UIColor decreaseColor];

        }
        else if (sender.tag == 30)
        {
            //买跌
            sender.layer.borderColor = RGBA(45, 176, 71, 1).CGColor;
            sender.backgroundColor = [UIColor increaseColor];
            
            UIButton *orderButton = [self.bottomView viewWithTag:4];
            orderButton.backgroundColor = [UIColor increaseColor];
        }
        
    }
    else
    {
        sender.backgroundColor = [UIColor whiteColor];
        sender.layer.borderColor = RGBA(237, 238, 240, 1).CGColor;
    }
}

#pragma mark - response click
//优惠券
- (void)couponButtonClick:(UIButton *)sender{
    if ([_couponNumberString isEqualToString:@"0"]){
        return;
    }
    
    sender.selected = !sender.selected;
    UIImageView *couponImageView = [sender.superview viewWithTag:8];
    couponImageView.highlighted = sender.selected;
    _isUseCoupon = sender.selected;

    if (_isUseCoupon){
        // 使用优惠券 假如买的数量大于1手 减值1手
        UISlider *slide = [self.slideCountView viewWithTag:4];
        if (slide.value > 1){
            slide.value = 1;
            UILabel *topLable = [self.slideCountView viewWithTag:1];
            topLable.text = @"买几手：1手";
        }
    }
    [self updateBottomViewInfo];
}

// 充值界面
- (void)pushRechargeViewControllerButtonClick{
    [self dismissPickerView];
    
    //充值界面
    RechargeViewController *rechargeVC = [[RechargeViewController alloc]init];
    rechargeVC.hidesBottomBarWhenPushed = YES;
    rechargeVC.isBuyUp = _isBuyUp;
    [self.currentViewController.navigationController pushViewController:rechargeVC animated:YES];
}

- (void)kindViewButtonClick:(UIButton *)sender{
    self.kindLeftView.isSelected = NO;
    self.kindMiddleView.isSelected = NO;
    self.kindRightView.isSelected = NO;
    ((MetalKindView *)sender.superview).isSelected = YES;
    [self updateBottomViewInfo];
}

- (void)chooseBuyUpOrDownButtonClick:(UIButton *)sender{
    NSInteger index = sender.tag;
    sender.selected = YES;
    [self setBuyUPButtonSelectStateButton:sender];
    
    if (index == 20){
        //买涨
        UIButton *button = [_contentView viewWithTag:30];
        button.selected = NO;
        [self setBuyUPButtonSelectStateButton:button];
    }else if (index == 30){
        //买跌
        UIButton *button = [_contentView viewWithTag:20];
        button.selected = NO;
        [self setBuyUPButtonSelectStateButton:button];
    }
}

- (void)slideValueChangeClick:(UISlider *)slide{

    int value = ceil(slide.value);
    if ([slide.superview isEqual:self.slideCountView]){
        
        if (slide.value > 1 && _isUseCoupon){
            // 优惠券 可买 1 手
            slide.value = 1;
            [ErrorTipView errorTip:@"使用优惠券只能买1手" SuperView:self];
            return;
        }
        self.slideCountView.currentValueLabel.text = [NSString stringWithFormat:@"买%d手",value];
    }else if ([slide.superview isEqual:self.slideGainView]){
        value = value * 10;
        if (value == 0){
            self.slideGainView.currentValueLabel.text = @"止盈：不限";
        }else{
            self.slideGainView.currentValueLabel.text = [NSString stringWithFormat:@"止盈：%d点",value];
        }
    }else if ([slide.superview isEqual:self.slideLossView]){
        value = value * 10;
        if (value == 0){
            self.slideLossView.currentValueLabel.text = @"止损：不限";
        }else{
            self.slideLossView.currentValueLabel.text = [NSString stringWithFormat:@"止损：%d点",value];
        }
    }
    
    [self updateBottomViewInfo];
}

- (void)changeSlideValueButtonClick:(UIButton *)sender{
    TransactionSlideView *slideView = (TransactionSlideView *)sender.superview;
    if ([sender isEqual:slideView.leftButton]){
        slideView.slide.value = slideView.slide.value - 1;
    }else if ([sender isEqual:slideView.rightButton]){
        slideView.slide.value = slideView.slide.value + 1;

        if ([slideView isEqual:self.slideCountView] && slideView.slide.value > 1 && _isUseCoupon){
            // 优惠券 可买 1 手
            slideView.slide.value = slideView.slide.value - 1;
            [ErrorTipView errorTip:@"使用优惠券只能买1手" SuperView:self];
            return;
        }
    }
    int value = ceil(slideView.slide.value);
    if ([slideView isEqual:self.slideCountView]){
        slideView.currentValueLabel.text = [NSString stringWithFormat:@"买%d手",value];
        [self updateBottomViewInfo];
    }else{
        value = value * 10;
        NSString *string = [slideView isEqual:self.slideGainView] ? @"止盈" : @"止损";
        if (value == 0){
            slideView.currentValueLabel.text = [NSString stringWithFormat:@"%@：不限",string];
        }else{
            slideView.currentValueLabel.text = [NSString stringWithFormat:@"%@：%d点",string,value];
        }
    }
}

/* 下单 */
- (void)placeAnOrderButtonClick:(UIButton *)sender{
    if (self.slideCountView.slide.value < 1){
        [ErrorTipView errorTip:@"请至少选择1手购买" SuperView:self];
        return;
    }
    UILabel *priceLable = [self.bottomView viewWithTag:1];
    if ([priceLable.text floatValue] > [self.balanceOfAccountString floatValue] && _isUseCoupon == NO){
        [ErrorTipView errorTip:@"账户余额不足" SuperView:self];
        return;
    }
    if ([self.couponNumberString intValue] < (int)self.slideCountView.slide.value && _isUseCoupon == YES){
        [ErrorTipView errorTip:@"可用代金券数量不足" SuperView:self];
        return;
    }

    
    ProductInfoModel *productInfo = _productListArray[self.currentProductIndex];
    
    /// 建仓
    OrderInfoModel *order = [[OrderInfoModel alloc] init];
    order.isBuyDrop = !self.isBuyUp;
    order.isUseCoupon = _isUseCoupon;
    order.productInfo = [productInfo copy];
    order.count = self.slideCountView.slide.value;
    order.topLimit = ((int)self.slideLossView.slide.value ) / 10.0;
    order.bottomLimit = ((int)self.slideGainView.slide.value ) / 10.0;
    
    [OrderInfoModel creatOrder:order handler:^(BOOL isSuccess) {
        [self dismissPickerViewWithNeedTip:YES Error:nil];
    }];
}

- (void)updateBottomViewInfo{
    if (_productListArray){
        UILabel *unitLable = [self.bottomView viewWithTag:3];
        
        int value = ceil(self.slideCountView.slide.value);//多少手
        
        if (_isUseCoupon == NO){
            ProductInfoModel *info = _productListArray[self.currentProductIndex];
            float price = [info.price floatValue];
            unitLable.text = @"元";
            price = price * value;
            price = price + [info.fee floatValue];
            if (value == 0){
                price = 0;
            }
            
            [self setTotalPrice:[NSString stringWithFormat:@"%.1f",price] fee:info.fee ?: @""];
        }else{
            [self setTotalPrice:[NSString stringWithFormat:@"%d",value] fee:@"0"];
            
            unitLable.text = @"张代金券";
        }
    }
}

- (void)setTotalPrice:(NSString *)price fee:(NSString *)fee{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"总计" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColor.blackColor}];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:price attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColor.redColor}]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"元(手续费:" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColor.blackColor}]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:fee attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:UIColor.redColor}]];
    [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"元)" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:UIColor.blackColor}]];
    self.totalLabel.attributedText = string;
}

#pragma mark - setter and getters

- (CGSize)kindViewSize{
    return CGSizeMake((CGRectGetWidth(UIScreen.mainScreen.bounds) - 40) / 3.0, (CGRectGetWidth(UIScreen.mainScreen.bounds) - 50) / 3.0);
}

- (NSInteger)currentProductIndex{
    if (self.kindLeftView.isSelected) {
        return 0;
    }else if (self.kindMiddleView.isSelected) {
        return 1;
    }else {
        return 2;
    }
}

- (UIButton *)coverButton{
    if (_coverButton == nil){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor blackColor];
        button.alpha = 0.0;
        [button addTarget:self action:@selector(dismissPickerView) forControlEvents:UIControlEventTouchUpInside];
        button.frame = UIScreen.mainScreen.bounds;
        _coverButton = button;
    }
    return _coverButton;
}

//种类
- (MetalKindView *)kindLeftView{
    if (_kindLeftView == nil){
        _kindLeftView = [[MetalKindView alloc]initWithFrame:CGRectMake(0, 0, self.kindViewSize.width, self.kindViewSize.height) name:@"白银" uPrice:@"23.5"];
        [_kindLeftView.button addTarget:self action:@selector(kindViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _kindLeftView.isSelected = YES;
    }
    return _kindLeftView;
}

- (MetalKindView *)kindMiddleView{
    if (_kindMiddleView == nil){
        _kindMiddleView = [[MetalKindView alloc]initWithFrame:CGRectMake(0, 0, self.kindViewSize.width, self.kindViewSize.height) name:@"黄金" uPrice:@"55.7"];
        [_kindMiddleView.button addTarget:self action:@selector(kindViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kindMiddleView;
}

- (MetalKindView *)kindRightView{
    if (_kindRightView == nil){
        _kindRightView = [[MetalKindView alloc]initWithFrame:CGRectMake(0, 0, self.kindViewSize.width, self.kindViewSize.height) name:@"钻石" uPrice:@"93.7"];
        [_kindRightView.button addTarget:self action:@selector(kindViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _kindRightView;
}

- (TransactionSlideView *)slideGainView{
    if (_slideGainView == nil){
        _slideGainView = [[TransactionSlideView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 50)];
        _slideGainView.currentValueLabel.text = @"止盈：不限";
        [_slideGainView.slide addTarget:self action:@selector(slideValueChangeClick:) forControlEvents:UIControlEventValueChanged];
        [_slideGainView.leftButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_slideGainView.rightButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _slideGainView;
}

- (UIButton *)couponButton{
    if (_couponButton == nil) {
        UIButton *couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
        couponButton.frame = CGRectMake(0, 0, 100, 35);
        couponButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        couponButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        couponButton.backgroundColor = UIColor.clearColor;
        [couponButton addTarget:self action:@selector(couponButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [couponButton setTitle:@"使用体验券(当前可用1张)" forState:UIControlStateNormal];
        [couponButton setTitle:@"使用体验券(当前可用1张)" forState:UIControlStateSelected];
        [couponButton setTitleColor:TextColorGray forState:UIControlStateNormal];
        [couponButton setTitleColor:TextColorGray forState:UIControlStateSelected];
        couponButton.titleLabel.font = [UIFont systemFontOfSize:14];

        //image.size = {16,16}
        [couponButton setImage:[UIImage imageNamed:@"ImageTransaction_CouponNoUse"] forState:UIControlStateNormal];
        [couponButton setImage:[UIImage imageNamed:@"Transaction_CouponUse"] forState:UIControlStateSelected];
        couponButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        couponButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 0);
        _couponButton = couponButton;
    }
    return _couponButton;
}

- (TransactionSlideView *)slideCountView{
    if (_slideCountView == nil){
        _slideCountView = [[TransactionSlideView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 50)];
        _slideCountView.currentValueLabel.text = @"买5手";
        _slideCountView.minValueLabel.text = @"1手";
        _slideCountView.maxValueLabel.text = @"10手";
        _slideCountView.slide.value = 5;
        _slideCountView.slide.minimumValue = 1;
        _slideCountView.slide.maximumValue = 10;
        [_slideCountView.slide addTarget:self action:@selector(slideValueChangeClick:) forControlEvents:UIControlEventValueChanged];
        
        [_slideCountView.leftButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_slideCountView.rightButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slideCountView;
}

- (TransactionSlideView *)slideLossView{
    if (_slideLossView == nil){
        _slideLossView = [[TransactionSlideView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 50)];
        _slideLossView.currentValueLabel.text = @"止损：不限";
        [_slideLossView.slide addTarget:self action:@selector(slideValueChangeClick:) forControlEvents:UIControlEventValueChanged];
        [_slideLossView.leftButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_slideLossView.rightButton addTarget:self action:@selector(changeSlideValueButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _slideLossView;
}

- (UIView *)contentView{
    if (_contentView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(UIScreen.mainScreen.bounds), CGRectGetWidth(UIScreen.mainScreen.bounds), 360)];
        view.backgroundColor = UIColor.whiteColor;
        
        UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, CGRectGetWidth(UIScreen.mainScreen.bounds) - 80, 20)];
        topLable.tag = 1;
        topLable.text = [NSString stringWithFormat:@"余额：%@元",AccountInfo.standardAccountInfo.balance];
        topLable.textColor = TextColorGray;
        topLable.textAlignment = NSTextAlignmentLeft;
        topLable.font = [UIFont systemFontOfSize:15];
        [view addSubview:topLable];
        
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topButton addTarget:self action:@selector(pushRechargeViewControllerButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [topButton setTitle:@"充值" forState:UIControlStateNormal];
        [topButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        topButton.titleLabel.font = [UIFont systemFontOfSize:15];
        topButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        topButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        topButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 70, 0, 70, 40);
        [view addSubview:topButton];
        
        [view addSubview:self.kindLeftView];
        [view addSubview:self.kindMiddleView];
        [view addSubview:self.kindRightView];
        
        self.kindLeftView.frame = CGRectMake(10, CGRectGetMaxY(topButton.frame) + 10, self.kindViewSize.width, self.kindViewSize.height);
        self.kindMiddleView.frame = CGRectMake(CGRectGetMaxX(self.kindLeftView.frame) + 10, CGRectGetMaxY(topButton.frame) + 10, self.kindViewSize.width, self.kindViewSize.height);
        self.kindRightView.frame = CGRectMake(CGRectGetMaxX(self.kindMiddleView.frame) + 10, CGRectGetMaxY(topButton.frame) + 10,self.kindViewSize.width, self.kindViewSize.height);
        
        UIButton *buyUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyUpButton.adjustsImageWhenHighlighted = NO;
        buyUpButton.tag = 20;
        [buyUpButton setTitle:@"买涨" forState:UIControlStateNormal];
        [buyUpButton addTarget:self action:@selector(chooseBuyUpOrDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        buyUpButton.layer.cornerRadius = 5;
        buyUpButton.layer.borderWidth = 1;
        buyUpButton.clipsToBounds = YES;
        [buyUpButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buyUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        buyUpButton.titleLabel.font = [UIFont systemFontOfSize:15];
        buyUpButton.frame = CGRectMake(10, CGRectGetMaxY(self.kindLeftView.frame) + 15,  CGRectGetWidth(self.kindMiddleView.frame) + 20, 40);
        buyUpButton.selected = YES;
        [self setBuyUPButtonSelectStateButton:buyUpButton];
        [view addSubview:buyUpButton];
        
        UIButton *buyDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        buyDownButton.adjustsImageWhenHighlighted = NO;
        buyDownButton.tag = 30;
        buyDownButton.selected = NO;
        buyDownButton.layer.cornerRadius = 5;
        [buyDownButton addTarget:self action:@selector(chooseBuyUpOrDownButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        buyDownButton.layer.borderWidth = 1;
        buyDownButton.clipsToBounds = YES;
        [buyDownButton setTitle:@"买跌" forState:UIControlStateNormal];
        [buyDownButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [buyDownButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];        buyDownButton.titleLabel.font = [UIFont systemFontOfSize:15];
        buyDownButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - CGRectGetWidth(buyUpButton.frame) - 10, CGRectGetMaxY(self.kindLeftView.frame) + 15, CGRectGetWidth(buyUpButton.frame), 40);
        [self setBuyUPButtonSelectStateButton:buyDownButton];
        [view addSubview:buyDownButton];

        [view addSubview:self.slideCountView];
        self.slideCountView.frame = CGRectMake(0, CGRectGetMaxY(buyDownButton.frame) + 20, CGRectGetWidth(UIScreen.mainScreen.bounds),50);

        [view addSubview:self.couponButton];
        self.couponButton.frame = CGRectMake(CGRectGetWidth(view.bounds) - 220, CGRectGetMaxY(self.slideCountView.frame), 220,20);
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.couponButton.frame), CGRectGetWidth(view.bounds), 10)];
        grayView.backgroundColor = TableGrayColor;
        [view addSubview:grayView];

        [view addSubview:self.slideGainView];
        [view addSubview:self.slideLossView];
        
        self.slideGainView.frame = CGRectMake(0, CGRectGetMaxY(grayView.frame) + 10, CGRectGetWidth(UIScreen.mainScreen.bounds),50);
        self.slideLossView.frame = CGRectMake(0, CGRectGetMaxY(self.slideGainView.frame) + 10, CGRectGetWidth(UIScreen.mainScreen.bounds),50);

        [view addSubview:self.bottomView];
        self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.slideLossView.frame), CGRectGetWidth(UIScreen.mainScreen.bounds),CGRectGetHeight(self.bottomView.bounds));
        
        view.frame = CGRectMake(0, CGRectGetHeight(UIScreen.mainScreen.bounds), CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetMaxY(self.bottomView.frame));
        _contentView = view;
    }
    return _contentView;
}

- (UIView *)bottomView{
    if (_bottomView == nil){
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), isIPhoneNotchScreen() ? (10 + 49 + 20) : (10 + 49))];
        view.backgroundColor = [UIColor whiteColor];
        
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 10)];
        grayView.backgroundColor = TableGrayColor;
        [view addSubview:grayView];
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 100, CGRectGetMaxY(grayView.frame), 100, 49);
        rightButton.tag = 4;
        rightButton.backgroundColor = RGBA(252, 71, 75, 1);
        rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [rightButton setTitle:@"下单" forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(placeAnOrderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:rightButton];
        
        _totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 49)];
        [view addSubview:_totalLabel];
        [self setTotalPrice:@"100" fee:@"24"];
        self.totalLabel.frame = CGRectMake(10, CGRectGetMaxY(grayView.frame), 300, 49);
        
        _bottomView = view;
    }
    return _bottomView;
}

@end
