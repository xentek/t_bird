# TBird

Straight forward file uploads for Ruby Apps.

## Installation

Add this line to your application's Gemfile:

    gem 't_bird'

And then execute:

    $ bundle

## Why?

I became frustrated by the very coupled design of the leading ruby
upload libraries and wanted something that was a little more modular (to
allow for flexibility), wasn't glued to a `model` class, and fulfilled my
most common use case out of the box: 

 - Upload an image, posted from a multi-part form,
 - process the file into 1 or more versions (resize, crop, etc),
 - and stream the files to s3 for storage without keeping anything on
   the local filesystem.

## Usage

_Coming Soon_

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Shout Outs

Sample image, used in tests, was provided by [cherrylet](http://www.flickr.com/photos/cherrylet/10258332985/sizes/o/in/photostream/), under the Creative Commons 2.0. No endorsement of this library by the photographer is intended or implied.
