# Vacation

Vacation lets you host Jekyll sites on S3.  It is a gem.  You add it via `gem install vacation`.

Then you take a vacation.

## Creating a Jekyll site

Make site.

## Identify your AWS access credentials

These should look something like the ones you get from Amazon.  Not Rackspace.

Full `~/.fog` support will land in a bit.

Then identify the name of the bucket you want to hook things into.

## Backups

Vacation destructively overwrites the contents of the target bucket for now.
Previous content is (optionally, if you use the `vacation` executable) backed
up to a secondary bucket.

If you deploy to `bucket_name` bucket is called `bucket_name`-vacation-backup.

## Deploying

Vacation gets invoked via a command line executable script, also called `vacation`!

    vacation <bucket name>
    vacation <bucket name> <path to source>

    Your AWS information can be read from the environment as
    AWS_ID and AWS_KEY or using the following variables:

          --[no-]backup                Back up the contents of the destination bucket
          --id [ID]                    Your AWS access key id
          --key [KEY]                  Your AWS secret key
          --version                    Display current version


## MIT License

Copyright (c) 2011 Eric "Doc" Ritezel

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the 'Software'), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
