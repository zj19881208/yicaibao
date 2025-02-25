//
//  JLCycleScrollerView.h
//  JLCycleScrollView
//
//  Created by yangjianliang on 2017/9/24.
//  Copyright © 2017年 yangjianliang. All rights reserved.
//
//  GitHub：https://github.com/Yangjianliang/JLCycleScrollView

#import <UIKit/UIKit.h>
#import "JLCycScrollDefaultCell.h"
#import "JLPageControl.h"

NS_ASSUME_NONNULL_BEGIN

@class JLCycleScrollerView;
@protocol JLCycleScrollerViewDatasource <NSObject>
@optional
/**
 使用默认轮播图cell设置Datasource会执行该方法
 @param cell 可以直接进行cell设置
 @param index 当前cell的index<0.1.2...>
 @param sourceArray 传入进来的原始数据
 @return 默认支持数据类型(NSString,NSURL,UIImage)会自动设置展示,其他类型可以在DataSource直接根据代理方法cel进行设置或者return默认支持数据类型(NSString,NSURL,UIImage)
 1.eg: ExampleModel *model = = sourceArray[index];
       [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
       return nil;
 2.eg: ExampleModel *model = = sourceArray[index];
       return model.url;
 */
-(nullable id)jl_cycleScrollerView:(JLCycleScrollerView*)view defaultCell:(JLCycScrollDefaultCell*)cell cellForItemAtIndex:(NSInteger)index sourceArray:(NSArray*)sourceArray;
@end

@protocol JLCycleScrollerViewDelegate <NSObject>
@optional
/**
 点击轮播Cell代理
 @param index 点击的<0.1.2...>
 @param sourceArray 传入进来的原始数据
 */
-(void)jl_cycleScrollerView:(JLCycleScrollerView*)view didSelectItemAtIndex:(NSInteger)index sourceArray:(NSArray*)sourceArray;
@end

@interface JLCycleScrollerView : UIView
/**支持storyboard/Xib初始化，或[alloc init］方式初始化*/
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;
/**数据源
 数组内默认支持数据类型(NSString,NSURL,UIImage),其他类型可以在DataSource直接根据代理方法cel进行设置
 eg：
 ExampleModel *model = = sourceArray[index];
 [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:nil];
 */
@property (nonatomic, strong) NSArray *sourceArray;
//default is 0,注意: 取值时sourceArray[curryPage]时需要判断下sourceArray.count>0。
@property (nonatomic, readonly) NSInteger curryPage;

/**
 使用默认的cell创建轮播图设置datasource,默认cell只添加了imageview子视图
 datasource只用于系统自带默认cell数据的设置，如果使用自定义的cell,即
 [setCustomCell: isXibBuild:]方法后，datasource设置无效，此时需要使用协议设置Cell数据
 eg:JLCycScrollDefaultCell
 */
@property (nonatomic, weak, nullable) id<JLCycleScrollerViewDatasource>datasource;
@property (nonatomic, weak, nullable) id<JLCycleScrollerViewDelegate>delegate;

// -------------UICollectionView设置------------
/**
 轮播图使用自定义的cell创建,cell上子控件可高度自定义
 @param cell  自定义cell必须遵循JLCycleScrollDataProtocol协议，cell执行协议方法给cell赋值,使用自定义cell不再需要datasource
 @param isxib 自定义cell是否以xib方式创建
 eg:[self.jLCycleScrollerView setCustomCell:[[JLLunBoCollectionViewCell alloc] init] isXibBuild:YES];
 */
-(void)setCustomCell:(UICollectionViewCell<JLCycSrollCellDataProtocol>*)cell isXibBuild:(BOOL)isxib ;
/** default is nil */
@property (nonatomic, strong) UIImage *placeholderImage;
/** default is UICollectionViewScrollDirectionHorizontal */
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
/** default is YES */
@property (nonatomic) BOOL scrollEnabled;
/**default is 1.0,每行、列cell个数,*/
@property (nonatomic) CGFloat cellsOfLine;
/**default is YES */
@property (nonatomic) BOOL pagingEnabled;
/**default is YES,是否需要无限拖拽*/
@property (nonatomic) BOOL infiniteDragging;
/**default is NO,eg:sourceArray.count=1、cellsOfLine<=1.0时不能被无限拖拽*/
@property (nonatomic) BOOL infiniteDraggingForSinglePage;

// --------------pageControl设置------------
/**if pageControlNeed=NO,pageControl is nil; eg:pageControl.currentPageIndicatorTintColor...*/
@property (nonatomic, strong, nullable) JLPageControl* pageControl;
/**Whether or not need pageControl，default is YES;设置NO后pageControl=nil,如果再次设置为YES,将重新创建默认pageControl*/
@property(nonatomic, assign) BOOL pageControlNeed;

/**距离父视图边距,同一方向(水平/垂直)属性设置互斥，即同一方向上多个设置只有最后一次设置生效
 eg:
 self.jLCycleScrollerView.pageControl_left = 20;
 self.jLCycleScrollerView.pageControl_right = 15;
 最终pageControl在水平方向上距离右边距15,距离底部10，宽高为系统自动计算
 默认 pageControl_centerX=0;pageControl_botton=10;
 */
@property(nonatomic, assign) CGFloat pageControl_centerX;
@property(nonatomic, assign) CGFloat pageControl_left;
@property(nonatomic, assign) CGFloat pageControl_right;

@property(nonatomic, assign) CGFloat pageControl_top;
@property(nonatomic, assign) CGFloat pageControl_botton;
@property(nonatomic, assign) CGFloat pageControl_centerY;

// --------------timer设置------------
//note:当视图添加、移除、push-pop等时,定时器会自动重新创建激活或销毁定时器，
//eg：当push时，你不必考虑暂停定时器，当pop回来时，你也不必激活定时器
/**是否需要定时器,default is YES */
@property(nonatomic, assign) BOOL timerNeed;
/**定时器时间间隔(default is 2.5)*/
@property(nonatomic, assign) NSTimeInterval timeDuration;
/**多少秒后启动*/
-(void)resumeTimerAfterDuration:(NSTimeInterval)duration;
/**暂停*/
-(void)pauseTimer;

@end
NS_ASSUME_NONNULL_END
