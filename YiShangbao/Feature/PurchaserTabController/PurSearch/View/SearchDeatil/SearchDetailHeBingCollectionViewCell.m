//
//  SearchDetailHeBingCollectionViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
#define PhotoMargin 10  //间距
#define ContentWidth LCDW-30
#import "SearchDetailHeBingCollectionViewCell.h"


@implementation SearchDetailHeBingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.jindianBtn.layer.masksToBounds = YES;
    self.jindianBtn.layer.cornerRadius = self.jindianBtn.frame.size.height/2;
    self.jindianBtn.layer.borderWidth = 0.5;
    self.jindianBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"F58F23"].CGColor;
    
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.height/2;
    
    self.photosBackView.backgroundColor = [UIColor whiteColor];
    // 创建一个流水布局photosView(默认为流水布局)
    ZXPhotosView *photoView   = [ZXPhotosView photosView];
    photoView.autoLayoutWithWeChatSytle = YES;
    photoView.photoMaxCount = 3;
    photoView.photoMargin = PhotoMargin;
    photoView.photoWidth = (ContentWidth-PhotoMargin*2)/3;
    photoView.photoHeight = photoView.photoWidth;
    self.photosView = photoView;
//    self.photosView.delegate = self;

    photoView.photoModelItemViewBlock = ^(UIView *itemView)
    {
        [itemView zx_setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    };
    [self.photosBackView addSubview:self.photosView];
    [photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.photosBackView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];

    //icons
    [self updateConstraintsIfNeeded];
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 4.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
}
-(void)setHeBingCellData:(SearchShopModel*)data
{
    NSURL *url =  [NSURL URLWithString:data.headPicUrl];
    [self.headerImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:url] placeholderImage:AppPlaceholderShopImage options:SDWebImageRetryFailed | SDWebImageRefreshCached ];
    
    self.titleLabel.text = data.name;
    self.moshiLabel.text = data.businessAgeAndMode;
    self.addressLabel.text = data.address;
//    self.numsLabel.text  = data.resultDesc;
    
    NSMutableAttributedString *attributedText = [self changeAllnumbersOfString:data.resultDesc WithStrColor:[WYUISTYLE colorWithHexString:@"868686"] numberColor:[WYUISTYLE colorWithHexString:@"F68F23"]];
    self.numsLabel.attributedText = attributedText;
        
    if ([NSString zhIsBlankString:data.payMark]) {
        self.tuiguangContentView.hidden = YES;
        self.tuiguangLabel.text = @"";
    }else{
        self.tuiguangContentView.hidden = NO;
        self.tuiguangLabel.text = data.payMark;
    }
    
    NSMutableArray *picMArray = [NSMutableArray array];
    [data.products enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SearchShopProductsModel *picModel = (SearchShopProductsModel *)obj;
        
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:picModel.picUrl];
        NSURL *thumbnail_pic = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:picModel.picUrl];
        photo.thumbnail_pic = thumbnail_pic.absoluteString;
        ////        photo.width = picModel.width;
        ////        photo.height = picModel.height;
        [picMArray addObject:photo];
        
    }];
    self.photosView.photoModelArray = picMArray;
    //    self.photosView.userInfo = model.postId;
    
    //icons
    NSMutableArray *imgIcons = [NSMutableArray array];
    [data.icons enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
}

//-(void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray *)photos
//{
//
//    SearchShopProductsModel* modelProduct =  self.searchshopModel.products[index];
//    NSString *url = [modelProduct.link stringByReplacingOccurrencesOfString:@"{productId}" withString:modelProduct.iid];
//    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_PushProductH5_SearchDetailViewController  object:url];
//
//
//}

/**
 针对特定字符串样式:XXX123XXX
 @param str eg:店内共有12件商品－>店内共有 12 件商品
 @param color 字体颜色
 @param numColr 数字颜色
 @return Label.attributedText
 */
-(NSMutableAttributedString*)changeAllnumbersOfString:(NSString*)str WithStrColor:(UIColor*)color numberColor:(UIColor*)numColr
{
    if (!str) {
        return nil;
    }
    NSArray* arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]];
    NSInteger length = 1;
    for (NSString* str in arr) {
        if ([str isEqualToString:@""]) {
            length ++;
        }
    }
    NSString* firStr = arr.firstObject;
    NSUInteger location = firStr.length;
    NSMutableString* strM = [NSMutableString stringWithString:str];
    [strM insertString:@" " atIndex:location];
    if (strM.length>=location+length+1) {
        [strM insertString:@" " atIndex:location+length+1];
    }else{
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSLog(@"目前只支持'XX123XX'这种特定格式");
        return attributedString;
    }
    
    NSRange range = NSMakeRange(location+1, length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strM];
    [attributedString addAttribute:NSForegroundColorAttributeName value:numColr range:range];
    return attributedString;
}
@end
