# Book Finder
[![Gem Version](https://badge.fury.io/rb/book_finder.svg)](https://badge.fury.io/rb/book_finder)

A gem to find books on libgen and b-ok sites

## Installation

Add this line to your application's Gemfile:
``` rb
    gem 'book_finder'
```
And then execute:
```
    bundle
```
Or install it yourself as:

```
   gem install book_finder
```
    
## Examples
``` rb
require 'book_finder'

finder = BookFinder.new
from_libgen = finder.search(api: 'libgen', params: { query: 'ruby' })
from_bok = finder.search(api: 'bok', params: { query: 'ruby' })
from_both = finder.search(params: { query: 'ruby' })
from_libgen_by_author = finder.search(api: 'libgen', params: { query: 'elixir', by: 'author'})
from_libgen_order_by_author_desc = finder.search(api: 'ibgen', params: { query: 'elixir', ordered_by: 'author', order_mode: 'DESC' })
```
---------------------------------------------------------------------------

# Docs
### BookFinder

### \#search

#### api 
Api where to fetch from

* libgen
* bok
* nil (both)

#### params
Params and filters for the result

| key | Description | Values | Default | Necessary |
| -- | -- | -- | -- | -- |
| query | Input given to the apis to look for the books | String | "" | true |
| by | Column in which the api will search | String | "" | false |
| ordered_by | Column in which the result will be ordered | String | "" | false |
| order_mode | Either ascendent or descendent | ASC, DESC | "" | false |
| page | Page number of the result to bring | Number | 1 | false |
| language | Language of the books listed | String | "" | false |
| from | From which date to start searching | Date | "" | false |
| to | Which date to end searching | Date | "" | false |


### Which data is returned?

| key | Data |
| -- | -- |
| authors | { "author's name" => "link_to_author" } |
| title | "Book title" |
| publisher | "Book publisher" |
| year | 1930 |
| pages | 225 |
| language | "English" |
| File size | "26 mb" |
| extension | "pdf" |
| mirrors | ["mirror1", "mirror2", "mirrorn"] |

