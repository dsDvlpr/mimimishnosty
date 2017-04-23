//
//  DSInscriptionMOManager.h
//  Mimimishnosty
//
//  Created by Dmitry Sharygin on 22.04.17.
//  Copyright © 2017 Dmitry Sharygin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DSInscription_MO+CoreDataClass.h"
#import "DSOrder_MO+CoreDataClass.h"

@interface DSInscriptionMOManager : NSObject

- (DSInscription_MO *) newInscriptionMOForItemWithId:(int32_t) itemId;
- (DSInscription_MO *) inscriptionMOWithoutOrderForItemWithId:(int32_t) itemId;
- (void) setInscriptionString:(NSString *) string forItemWithId:(int32_t) itemId;
- (NSString *) inscriptionStringForItemWithId:(int32_t) itemId inOrder:(DSOrder_MO *)order;

@end
