herb [![Build Status](https://travis-ci.org/frodsan/herb.svg)](https://travis-ci.org/frodsan/herb)
====

Minimal template engine with default escaping.

Description
-----------

Herb is a fork of [Mote] that uses a [ERB]-like style syntax and auto-escape HTML special characters by default.

Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "herb"
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install herb
```

Basic Usage
-----------

This is a basic example:

```ruby
require "herb"

template = Herb.parse("your template goes here!")
template.call
# => "your template goes here!"
```

Herb recognizes two tags to evaluate Ruby code: `<% %>`, and `<%= %>`. The difference between them is that while the `<% %>` tags only evaluate the code, the `<%= %>` tags also prints the result to the template.

Imagine that your template looks like this:

```erb
<% # single line code %>
<% gems = ["rack", "cuba", "herb"] %>

<%
  # multi-line code
  sorted = gems.sort
%>

<ul>
<% sorted.each do |name| %>
  <li><%= name %></li>
<% end %>
</ul>
```

The generated result will be like:

```html
<ul>
  <li>cuba</li>
  <li>herb</li>
  <li>rack</li>
</ul>
```

Parameters
----------

The values passed to the template are available as local variables:

```ruby
template = Herb.parse("Hello {{ name }}", [:name])
template.call(name: "Ruby")
# => Hello Ruby
```

You can also use the `params` local variable to access the given parameters:

```ruby
template = Herb.parse("Hello {{ params[:name] }}")
template.call(name: "Ruby")
# => Hello Ruby
```

Auto-escaping
-------------

By default, Herb escapes HTML special characters to prevent [XSS][xss] attacks. You can start the expression with an exclamation mark to disable escaping for that expression:

```ruby
template = Herb.parse("Hello {{ name }}", [:name])
template.call(name: "<b>World</b>")
# => Hello &lt;b&gt;World&lt;b&gt;

template = Herb.parse("Hello {{! name }}", [:name])
template.call(name: "<b>World</b>")
# => Hello <b>World</b>
```

Herb::Helpers
--------------

There's a helper available in the `Herb::Helpers` module, and you are
free to include it in your code. To do it, just type:

```ruby
include Herb::Helpers
```

### Using the `herb` helper

The `herb` helper receives a file name and a hash and returns the rendered version of its content. The compiled template is cached for subsequent calls.

```ruby
herb("test/basic.erb", n: 3)
# => "***\n"
```

### Template caching

When the `herb` helper is first called with a template name, the file is read and parsed, and a proc is created and stored in the current thread. The parameters passed are defined as local variables in the template. If you want to provide more parameters once the template was cached, you won't be able to access the values as local variables, but you can always access the `params` hash.

For example:

```ruby
# First call
herb("foo.erb", a: 1, b: 2)
```

Contributing
------------

Fork the project with:

```
$ git clone git@github.com:frodsan/herb.git
```

To install dependencies, use:

```
$ bundle install
```

To run the test suite, do:

```
$ rake test
```

For bug reports and pull requests use [GitHub][issues].

License
-------

Herb is released under the [MIT License][mit].

[erb]: http://ruby-doc.org/stdlib-2.3.1/libdoc/erb/rdoc/ERB.html
[issues]: https://github.com/frodsan/herb/issues
[mit]: http://www.opensource.org/licenses/MIT
[mote]: https://github.com/soveran/mote
[xss]: http://en.wikipedia.org/wiki/Cross-Site_Scripting
