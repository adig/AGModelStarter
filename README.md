# AGModelStarter

Base class for model types that makes your life easy. Provides the following for all subclasses : 
* `NSCoding` protocol implementation. Archive and unarchive your models like a boss.
* `NSCopying` protocol implementation. Copy your models back and forth without implementing a thing.
* `description` implementation for easier debugging. Just `NSLog` model instance to view all properties.
* `isEqual` implementation to compare instances.

## Usage
Subclass your model classes from AGModelStarter. Done.
See Demo project for example.

## License
The MIT License (MIT)
