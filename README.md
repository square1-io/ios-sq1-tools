# Square1 Tool (Objective-C) #

This library contains a group of utilities, helpers and categories that can be use in the different iOS projects we develope.


### Configuration ###

Some classes require a parameter inside the Info.plist file of our project/target to work properly.

* **CoreDataManager**: Requires _"SQ1Tools-CoreDataModelName"_ parameter setting the Core Data model name that will be used.

* **UUID**: Requires _"SQ1Tools-UUIDAccountName"_ parameter setting the name of the Keychain account name used to store the UUID.

* **NSDate+Square1 and NSString+Square1**: (OPTIONAL) _"SQ1Tools-TimeZone"_ paremeter setting the TimeZone for date conversion. Default el GMT.
