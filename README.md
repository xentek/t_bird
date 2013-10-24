# t_bird

Straight forward uploads for your Ruby apps.

_Uploading is... fun, fun, fun, until daddy takes the `t_bird` away._

## Project Status

- Build: [![Build Status](https://secure.travis-ci.org/xentek/t_bird.png)](http://travis-ci.org/xentek/t_bird)
- Dependencies: [![Dependency Status](https://gemnasium.com/xentek/t_bird.png)](https://gemnasium.com/xentek/t_bird)
- Code Quality: [![Code Climate](https://d3s6mut3hikguw.cloudfront.net/github/xentek/t_bird.png)](https://codeclimate.com/github/xentek/t_bird)

## Installation

Add this line to your application's Gemfile:

    gem 't_bird'

And then execute:

    $ bundle

## Why?

I became frustrated by the very coupled design of the leading ruby
upload libraries and wanted something that was a more modular (to
allow for flexibility), wasn't glued to a `model`, and fulfilled my
most common use case out of the box: 

 - Upload an image, posted from a multi-part form,
 - process the file into 1 or more versions (resize, crop, etc),
 - and stream the files to s3 for storage without keeping anything on
   the local filesystem.

## Usage

First, configure `t_bird` with a few settings:

````ruby
TBird::Configuration.configure |config|
  config.aws_key 'amazon access key id'
  config.aws_secret 'amazon secret access key'
  config.aws_bucket 'name of s3 bucket that already exists'
  config.thumbnail_size 100
end
````
Place this code so that it runs when your app boots.

- If you're using Sinatra or Rack, `config.ru` is probably a good spot.
- If you're using Rails, put the configuration in an initializer, e.g. `config/initializers/t_bird.rb`.

Then, assuming you have a multipart form like this:

````ruby
form enctype="multipart/form-data" method="POST"
  input type="file" name="brand[image]"
  input type="submit"
````
_Example is using [slim](http://slim-lang.com) for clarity and terseness, but that doesn't mean you have to._

In the action the form posts to, grab the uploaded file and upload it with `t_bird`:

````ruby
uploader = TBird::Uploader.new(params[:brand][:image])

uploader.upload! # return value is same as uploader.uploads

uploader.uploads # returns a hash of urls pointing to your image versions
                 # store this in the way that makes the most sense for your app
````

- By default, there are two `versions` defined: `:thumbnail` and `:original`.
- `:thumbnail` will create crop a square image from the upload.
  - You can control the size of the square by setting `thumbnail_size` in your configuration (see above).
- `:original` will be the raw, unadulterated file that the user submitted.

## Options

There are three options you can pass into your `TBird::Uploader` instance:

  - `:identifer`
    - app specific identifer for his upload, e.g. your model's databae ID, timestamp, whatever
    - used as the folder this file's uploads are stored in on s3
      - you can pass a path fragment here to create a folder heirarchy, e.g. 'uploads/images'
      - don't want any folders?, just pass an empty string, e.g. `''`
    - defaults to a `SHA1` digest of the `original_filename`
    - value should be URL safe, no encoding is done for you by `t_bird`
  - `:token`
    - needs to be a unique value per upload, to help avoid name collisions and writing over existing files
    - used as part of the filename, version and extension are
      automatically appended on to the end.
    - defaults to a [UUID](http://en.wikipedia.org/wiki/Universally_unique_identifier), think hard before straying from this strategy
    - value should be URL safe, no encoding is done for you by `t_bird`
  - `:metadata`
    - value must be a hash, as it will be merged in when your uploader is instantiated
    - the file's `content_type` is automatically added to this hash
    - values in this hash will be stored, with your file, on S3 as metadata.
      - this could be used for versioning your files, e.g. `version: 2` , marking them with
        the name/title of the model it's associated with, etc.
      - `t_bird` doesn't provide any read access to this metadata, once it's stored on S3, so it's up to you to use S3's API to do anything with it.

## Custom Uploaders

In order to define custom versions, and other advanced customization, create a subclass of `TBird::Uploader`:

````ruby
class FileUploader < TBird::Uploader
  version :original do
    ->(file) { file.original }
  end
end
````

- In this simple example we have created a subclass and defined a single
version, `:original`, that skips processing the file, making `FileUploader` suitable
for handling non-image uploads.
- No other versions were defined, so only `:original` will be created.
  - In other words, if you create a subclass without any `versions`
    defined, your uploader won't upload anything.

Here's a more complex example that defines several custom `versions`:

````ruby
class ComplexUploader < TBird::Uploader

  # resizes image to a *width* of 200px, maintains aspect ratio
  version :small do
    ->(img) { img.resize '200' } 
  end

  # resizes image to a *height* of 300px, maintains aspect ratio
  version :large do
    ->(img) { img.resize 'x300' }
  end

  # resizes image to a *height* of 300px, maintains aspect ratio
  version :resized do
    ->(img) { img.resize '500x300' }
  end

  # custom thumbnail size, allowing your to ignore TBird::Configuration.thumbnail_size
  # on an uploader by uploader basis
  version :thumbnail do
    ->(img) { img.thumbnail 200 }
  end

  # want MOAR power?
  # use process, which gets you inside a MiniMagick::Image#combine_options block
  version :complex do
    lambda do |img|
      img.process do |magick|
        magick.sample "50%"
        magick.rotate "-90>"
        magick.quality '88'
      end
    end
  end
end
````
For more information on `MiniMagick::Image#combine_options`, refer to the [mini_magick docs](https://github.com/minimagick/minimagick/blob/master/README.md).

:skull: `TBird::Processor#process` can be a _very sharp stick_, so carefully test your processing code with a variety of files in a non-production environment, and as usual be wary of using values from outside of your class as input for your processing routines.

## More customization options

- Redefine the `namer` method in your subclass to switch out the object that's responsible for generating the name used on S3.
  - Your object must respond to `new_name`, and take the `version`, which will be a symbol, as input.
- Redefine the `processor` method in your subclass to switch out the processing library.
  - Blocks defined by the `version` macro will be passed an instance of your `processor`,
    so be sure that your `processor` will respond to any methods the code inside your blocks call on it. 
- Redefine the `upload!` to remix the whole show!
  - really the sky's the limit here, but at some point you might be
    better of just writing your own uploader class.
  - Currently this is the only way to swith out S3 for another storage provider.
    - Better support changing the storage mechanism will likely come out in a future version.
    - Talk to me before working on a patch for this, so we can agree on implementation.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
6. ???
7. Profit!

#### Colophon

  - This project was not named after the Thunderbird model of car. Ford Motor Company does not have any connection to, or responsibility for this project, and does not endorse it in any way (or even know it exists).
  - Sample image, used in tests, was provided by [cherrylet](http://www.flickr.com/photos/cherrylet/10258332985/sizes/o/in/photostream/), under the Creative Commons 2.0. No endorsement of this library by the photographer is intended or implied.
