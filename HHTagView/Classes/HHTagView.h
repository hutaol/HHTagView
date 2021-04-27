//
//  HHTagView.h
//  Pods
//
//  Created by Henry on 2021/4/26.
//

#import "YYText.h"

@class HHTagView;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHTagAlignment) {
    HHTagAlignmentLeft,
    HHTagAlignmentCenter,
    HHTagAlignmentRight,
};

@protocol HHTagViewDelegate <NSObject>

- (void)tagView:(HHTagView *)view didSelectTagAtIndex:(NSInteger)index text:(NSString *)text;

@end


/**
 TODO 先设置属性才有效
 */
@interface HHTagView : YYLabel

@property (nonatomic, strong) NSArray <NSString *> *tagArray;

@property (nonatomic, weak) id<HHTagViewDelegate> delegate;

@property (nonatomic, strong) UIFont *tagFont;
@property (nonatomic, strong) UIColor *tagColor;

// 字体颜色数组
@property (nonatomic, strong, nullable) NSArray <UIColor *> *tagColors;

//标签边框
@property (nonatomic) CGFloat strokeWidth;
//标签边框颜色
@property (nonatomic, strong, nullable) UIColor *strokeColor;
// 标签边框颜色数组
@property (nonatomic, strong, nullable) NSArray <UIColor *> *strokeColors;

//标签填充颜色
@property (nonatomic, strong, nullable) UIColor *fillColor;
// 标签填充颜色数组
@property (nonatomic, strong, nullable) NSArray <UIColor *> *fillColors;

//路径的连接点形状,] kCGLineJoinMiter(默认全部连接),kCGLineJoinRound(圆形连接),kCGLineJoinBevel(斜角连接)
@property (nonatomic) CGLineJoin lineJoin;

//标签内容内边距
@property (nonatomic) UIEdgeInsets insets;

//标签圆角
@property (nonatomic) CGFloat cornerRadius;

//标签上下间距
@property (nonatomic, assign) CGFloat lineSpace;

//标签左右间距
@property (nonatomic, assign) CGFloat space;

//标签的最大宽度-》以便计算高度
@property (nonatomic, assign) CGFloat maxWidth;

//对齐方式
@property (nonatomic, assign) HHTagAlignment tagAlignment;

// 高度记录
@property (nonatomic, assign) CGFloat tagHeight;

@end

NS_ASSUME_NONNULL_END
