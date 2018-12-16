//
//  EBElectionPositionDataSource.h
//  Isegoria
//
//  Created by Alan Gao on 6/06/2014.
//  Copyright (c) 2014 Eulers Bridge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EBNetworkService.h"

@protocol EBElectionPositionsDataSourceDelegate <NSObject>

- (void)electionPositionsFetchDataCompleteWithSuccess:(BOOL)success;

@end


@interface EBElectionPositionsDataSource : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, EBContentServiceDelegate>

@property (weak, nonatomic) id<EBElectionPositionsDataSourceDelegate> delegate;

@property (strong, nonatomic) NSArray *positions;

- (void)fetchData;
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

@end
