//
//  XJInputView.m
//  XJTemplateProject
//
//  Created by 江鑫 on 2018/8/8.
//  Copyright © 2018年 XJ. All rights reserved.
//

#import "XJInputView.h"
#import "XJInputDefine.h"

@interface XJInputView()<XJFaceEmojeVieDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIButton *faceSelBtn;

@end

@implementation XJInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:self.contentTextView];
        [self addSubview:self.faceSelBtn];
        [self setupLayerLineView];
        
        [self makeConstraint];
        
    }
    return self;
    
}

- (void)makeConstraint
{
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9);
        make.bottom.mas_equalTo(-9);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(XJScreenWidth - 50);
    }];
    
    [self.faceSelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
    
}

- (UITextView*)contentTextView
{
    
    if (!_contentTextView) {
        
        UITextView *contentTextView = [[UITextView alloc]init];
//        contentTextView.placeholderText =  @"请在此评论";
//        contentTextView.placeholderFont = GETFONT(16);
//        contentTextView.textColor = contentThemeColor;
        contentTextView.scrollEnabled = NO;
        contentTextView.delegate = self;
        contentTextView.font = GETFONT(16);
        contentTextView.layer.cornerRadius = 5.0;
        contentTextView.layer.masksToBounds = YES;
        contentTextView.backgroundColor = [UIColor whiteColor];
        contentTextView.returnKeyType = UIReturnKeySend;
        contentTextView.layer.borderColor = [LINECOLOR CGColor];
        contentTextView.layer.borderWidth = 0.5;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 4;// 字体的行间距
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
        contentTextView.typingAttributes = attributes;
        _contentTextView = contentTextView;
        
    }
    return _contentTextView;
}


- (UIButton *)faceSelBtn
{
    if (!_faceSelBtn) {
        UIButton *faceSelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [faceSelBtn setBackgroundImage:GETIMG(@"IOS会话_表情按钮.png") forState:UIControlStateNormal];
        [faceSelBtn setBackgroundImage:GETIMG(@"btn_keyboard") forState:UIControlStateSelected];
        [faceSelBtn addTarget:self action:@selector(switchEnter) forControlEvents:UIControlEventTouchUpInside];
        _faceSelBtn = faceSelBtn;
    }
    return _faceSelBtn;
}

- (void)setupLayerLineView
{
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, self.xj_height-0.5,XJScreenWidth, 0.5);
    layer.backgroundColor = XJColor(200, 200, 200).CGColor;
    [self.layer addSublayer:layer];
}

- (void)switchEnter
{
    
    _faceSelBtn.selected = !_faceSelBtn.selected;
    
    if (_faceSelBtn.selected) {
        [self.parentView endEditing:YES];
    }else{
        [self.contentTextView becomeFirstResponder];
    }
    
    self.faceViewClickBlock();
    
}

#pragma mark  ------  YYTextViewDelegate --------

- (void)textViewDidChange:(UITextView *)textView
{
    [self adjustContentTextViewHeight];
}

#pragma mark ------- XJFaceEmojeVieDelegate ----

- (void)faceViewClickHeightChanged
{
    [self adjustContentTextViewHeight];
}

/**
 调整文本显示的高度;
 */
- (void) adjustContentTextViewHeight
{
    
    CGSize newSize  = [_contentTextView sizeThatFits:CGSizeMake(XJScreenWidth - 50,MAXFLOAT)];
    NSLog(@"vvv----%@",NSStringFromCGSize(newSize));
    
    if (newSize.height > maxheight) {
        
        self.xj_height = maxheight;
        _contentTextView.scrollEnabled = YES;
        
    }else{
        
        self.xj_height = newSize.height + 20;
        _contentTextView.scrollEnabled = NO;
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(xjInputViewHeightChanged:)]) {
    
        [self.delegate xjInputViewHeightChanged:self.xj_height];
        
    }
    
}
@end
