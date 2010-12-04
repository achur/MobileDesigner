//
//  ProjectsTableViewController.h
//  MobileDesigner
//

#import <Foundation/Foundation.h>
#import "CoreDataTableViewController.h"
#import "Project.h"
#import "ProjectRoutingDelegates.h"


@interface ProjectsTableViewController : CoreDataTableViewController {
	
	id <ProjectOpenerDelegate> delegate;

}

- initInManagedObjectContext:(NSManagedObjectContext *)context;


@property (nonatomic, retain) id <ProjectOpenerDelegate> delegate;


@end