# SlimEmbedCop

[![Gem Version](https://badge.fury.io/rb/slimembedcop.svg)](https://badge.fury.io/rb/slimembedcop)
[![CI](https://github.com/ydah/slimembedcop/actions/workflows/ci.yml/badge.svg)](https://github.com/ydah/slimembedcop/actions/workflows/ci.yml)
[![RubyDoc](https://img.shields.io/badge/%F0%9F%93%9ARubyDoc-documentation-informational.svg)](https://www.rubydoc.info/gems/slimembedcop)


[RuboCop](https://github.com/rubocop/rubocop) runner for [Ruby code embedded in Slim](https://github.com/slim-template/slim#embedded-engines-markdown-).

## Installation

**SlimEmbedCop**'s installation is pretty standard:

```sh
% gem install slimembedcop
```

If you'd rather install SlimEmbedCop using `bundler`, add a line for it in your `Gemfile` (but set the `require` option to `false`, as it is a standalone tool):

```ruby
gem 'slimembedcop', require: false
```

## Usage

Use `slimembedcop` executable to check offenses and autocorrect them.
[RuboCop's cop](https://docs.rubocop.org/rubocop/1.56/cops.html) or any [custom cop](https://docs.rubocop.org/rubocop/extensions.html#custom-cops) you create can also be used with `slimembedcop`.

```sh
% exe/slimembedcop --help
Usage: slimembedcop [options] [file1, file2, ...]
    -v, --version                    Display version.
    -a, --autocorrect                Autocorrect offenses.
    -c, --config=                    Specify configuration file.
        --[no-]color                 Force color output on or off.
    -d, --debug                      Display debug info.
```

### Example

You have a Slim file like this:

```ruby
ruby:
  message = "world"
html
  head
    title Slim Samples
  body
    ruby:
      if some_var = true
        do_something
      end
    h1 Hello, #{message}
ruby:
  do_something /pattern/i
```

When executed, it outputs the following offenses:

```sh
% slimembedcop dummy.slim
Inspecting 1 file
W

Offenses:

dummy.slim:2:13: C: [Correctable] Style/StringLiterals: Prefer single-quoted strings when you don't need string interpolation or special symbols.
  message = "world"
            ^^^^^^^
dummy.slim:8:19: W: [Correctable] Lint/AssignmentInCondition: Use == if you meant to do a comparison or wrap the expression in parentheses to indicate you meant to assign in a condition.
      if some_var = true
                  ^
dummy.slim:13:16: W: [Correctable] Lint/AmbiguousRegexpLiteral: Ambiguous regexp literal. Parenthesize the method arguments if it's surely a regexp literal, or add a whitespace to the right of the / if it should be a division.
  do_something /pattern/i
               ^

1 file inspected, 3 offenses detected, 3 offenses autocorrectable
```

## Configuration

The behavior of [RuboCop](https://github.com/rubocop/rubocop) can be controlled via the [.rubocop.yml](https://github.com/rubocop/rubocop/blob/master/.rubocop.yml) configuration file. The behavior of `SlimEmbedCop` can be controlled by the `.slimembedcop.yml` configuration file. It makes it possible to enable/disable certain cops (checks) and to alter their behavior if they accept any parameters. The file can be placed in your home directory, XDG config directory, or in some project directory.

The file has the following format:

```yaml
inherit_from: ../.rubocop.yml

Style/Encoding:
  Enabled: false

Layout/LineLength:
  Max: 99
```

NOTE: It is basically the same as RuboCop's. Please check [Configuration](https://docs.rubocop.org/rubocop/configuration.html) for details.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
