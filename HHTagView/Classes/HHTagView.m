//
//  HHTagView.m
//  Pods
//
//  Created by Henry on 2021/4/26.
//

#import "HHTagView.h"

@interface HHRangObject : NSObject

@property (nonatomic, assign) NSRange range;

@property (nonatomic, assign) NSInteger index;

@end

@implementation HHRangObject

- (BOOL)isEqualRange:(NSRange)range {
    return NSEqualRanges(range, self.range);
}

@end

@interface HHTagView()

@property (nonatomic, strong) NSMutableArray <HHRangObject *> *rangOfTags;

@end

@implementation HHTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

- (void)configView {
    self.strokeColor = [UIColor clearColor];
    self.strokeWidth = 0;
    self.fillColor = [UIColor blueColor];
    self.cornerRadius = 5;
    self.insets = UIEdgeInsetsMake(5, 8, 5, 8);
    self.lineJoin= kCGLineJoinBevel;
    self.tagFont = [UIFont systemFontOfSize:15];
    self.tagColor = [UIColor whiteColor];
    self.lineSpace = 10;
    self.space = 10;
    self.firstLineSpace = 10;
    self.maxWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.numberOfLines = 0;
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.displaysAsynchronously = YES;
        
}


- (void)setTagFont:(UIFont *)tagFont {
    _tagFont = tagFont;
    self.font = tagFont;
}

- (void)setTagArray:(NSArray<NSString *> *)tagArray {
    _tagArray = tagArray;
    
    self.rangOfTags = [NSMutableArray array];

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    NSInteger height = 0;

    for (int i = 0; i < tagArray.count; i ++) {
        NSString *tag = tagArray[i];
        
        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] init];
        // 标签左内边距
        [tagText appendAttributedString:[self createEmptyAttributeString:fabs(self.insets.left)]];
        // 标签内容
        [tagText yy_appendString:tag];
        // 标签右内边距
        [tagText appendAttributedString:[self createEmptyAttributeString:fabs(self.insets.right)]];
        // 标签字体颜色设置
        tagText.yy_font = self.tagFont;
        tagText.yy_color = self.tagColors[i] ?: self.tagColor;
        [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
        // 设置item外观样式
        [tagText yy_setTextBackgroundBorder:[self createTextBoardIndex:i] range:tagText.yy_rangeOfAll];
        // 只设置item右间距，左对齐时设置段落firstLineHeadIndent间距
        [text appendAttributedString:tagText];
        [text appendAttributedString:[self createEmptyAttributeString:self.space]];
        
        text.yy_lineSpacing = self.lineSpace;

        // 高度计算（超最大范围加换行符手动换行）
        YYTextContainer  *tagContarer = [[YYTextContainer alloc] init];
        tagContarer.size = CGSizeMake(self.maxWidth - self.space, CGFLOAT_MAX);
        YYTextLayout *tagLayout = [YYTextLayout layoutWithContainer:tagContarer text:text];
        if (tagLayout.textBoundingSize.height > height) {
            if (height != 0) {
                [text yy_insertString:@"\n" atIndex:text.length - tagText.length - 1];
            }
            tagLayout = [YYTextLayout layoutWithContainer:tagContarer text:text];
            height = tagLayout.textBoundingSize.height;
        }
                
        NSRange range = [text.string rangeOfString:tagText.string options:NSBackwardsSearch];
        HHRangObject *rangeObj = [[HHRangObject alloc] init];
        rangeObj.range = range;
        rangeObj.index = i;
        [self.rangOfTags addObject:rangeObj];
        
        __weak typeof(self) weakSelf = self;
        if (self.delegate && [self.delegate respondsToSelector:@selector(tagView:didSelectTagAtIndex:text:)]) {
            [text yy_setTextHighlightRange:range color:nil backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                
                NSInteger index = 0;
                for (int j = 0; j < weakSelf.rangOfTags.count; j ++) {
                    HHRangObject *rang = weakSelf.rangOfTags[j];
                    if ([rang isEqualRange:range]) {
                        index = rang.index;
                        break;
                    }
                }
                [weakSelf.delegate tagView:self didSelectTagAtIndex:index text:weakSelf.tagArray[index]];
            }];
        }
        
    }

    // 对齐方向设置及头尾边距
    [text addAttribute:NSParagraphStyleAttributeName value:[self createTextStyle]
                 range:NSMakeRange(0, text.length)];
    
    self.attributedText = text;
    
    // 高度记录（富文本已扩展高度属性）
    self.tagHeight = height + self.lineSpace * 2;
    
    CGSize labelSize = [self sizeThatFits:CGSizeMake(self.maxWidth, MAXFLOAT)];
    
    self.bounds = CGRectMake(0, 0, labelSize.width, self.tagHeight);

}

- (NSMutableAttributedString *)createEmptyAttributeString:(CGFloat)width {
    
    CGRect bounds = [@"XX" boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.tagFont} context:nil];
    CGFloat height = bounds.size.height + fabs(self.insets.bottom) + fabs(self.insets.top);
    
    NSMutableAttributedString *spaceText = [NSMutableAttributedString yy_attachmentStringWithContent:[[UIImage alloc] init] contentMode:UIViewContentModeScaleToFill attachmentSize:CGSizeMake(width, height) alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
    return spaceText;
}

- (YYTextBorder *)createTextBoardIndex:(NSInteger)index {
    YYTextBorder *border = [[YYTextBorder alloc] init];
    border.strokeWidth = self.strokeWidth;
    border.strokeColor = self.strokeColors[index] ?: self.strokeColor;
    border.fillColor = self.fillColors[index] ?: self.fillColor;
    border.cornerRadius = self.cornerRadius;
    border.lineJoin = self.lineJoin;
    border.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    return border;
}

- (NSMutableParagraphStyle *)createTextStyle {
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineSpacing = self.lineSpace;
    if (self.tagAlignment == HHTagAlignmentLeft) {
        style.firstLineHeadIndent = self.firstLineSpace;
    }
    switch (self.tagAlignment) {
        case HHTagAlignmentLeft:
            style.alignment = NSTextAlignmentLeft;
            break;
        case HHTagAlignmentCenter:
            style.alignment = NSTextAlignmentCenter;
            break;
        case HHTagAlignmentRight:
            style.alignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
    return style;
}

@end
