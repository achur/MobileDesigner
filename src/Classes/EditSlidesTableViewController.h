//
//  EditSlidesTableViewController.h
//  MobileDesigner
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "Project.h"
#import "ProjectRoutingDelegates.h"
#import "EditSlideViewController.h"


@interface EditSlidesTableViewController : CoreDataTableViewController <SlideEditDelegate> {
	
	Project* project;
	NSManagedObjectContext *managedObjectContext;
}

@property (assign) NSManagedObjectContext* managedObjectContext;
@property (assign) Project* project;

- initInManagedObjectContext:(NSManagedObjectContext *)context forProject:(Project*)proj;

- (void)updateTableData;



@end