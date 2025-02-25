//
//  SaleClientgraphMainCell.h
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PNPieChart.h"
#import "ZXCustomCellCollectionView.h"
#import "ClientLegendCollectionCell.h"

@interface SaleClientgraphMainCell : BaseTableViewCell

@property (nonatomic, strong) PNPieChart *pieChart;
@property (weak, nonatomic) IBOutlet ZXCustomCellCollectionView *customCellCollectionView;

@property (nonatomic, copy) NSArray *colorArray;

@end
