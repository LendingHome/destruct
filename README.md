# ![LendingHome](https://cloud.githubusercontent.com/assets/2419/19467866/7efa93a8-94c8-11e6-93e7-4375dbb8a7bc.png) destruct
[![Code Climate](https://codeclimate.com/github/LendingHome/destruct/badges/gpa.svg)](https://codeclimate.com/github/LendingHome/destruct) [![Coverage](https://codeclimate.com/github/LendingHome/destruct/badges/coverage.svg)](https://codeclimate.com/github/LendingHome/destruct) [![Gem Version](https://badge.fury.io/rb/destruct.svg)](http://badge.fury.io/rb/destruct)

> ES6 style object destructuring in Ruby

Check out the JavaScript [ES6 object destructuring](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) documentation for more information.

## Installation

Simply add this gem to the project `Gemfile`.

```ruby
gem "destruct"
```

## Usage

Ruby 2.3+ has some built-in methods and operators for simple object destructuring:

* [`Array#dig`](http://ruby-doc.org/core-2.3.0/Array.html#method-i-dig)
* [`Hash#dig`](http://ruby-doc.org/core-2.3.0/Hash.html#method-i-dig)
* [`Struct#dig`](https://ruby-doc.org/core-2.3.0/Struct.html#method-i-dig)
* [`Array#values_at`](https://ruby-doc.org/core-2.3.0/Array.html#method-i-values_at)
* [`Hash#values_at`](https://ruby-doc.org/core-2.3.0/Hash.html#method-i-values_at)
* [Splat operator `*`](https://ruby-doc.org/core-2.3.0/doc/syntax/calling_methods_rdoc.html#label-Array+to+Arguments+Conversion)
* [Safe navigation operator `&.`](https://bugs.ruby-lang.org/issues/11537)

This gem introduces a couple of new methods to the `Object` class for more complex destructuring.

### `Object#dig`

This behaves just like the `dig` methods in `Array`, `Hash`, and `Struct` allowing ALL objects to be destructured.

The implementation simply uses `send` to pass valid method calls thru to objects recursively.

```ruby
class Object
  def dig(method, *paths)
    object = send(method) if respond_to?(method)
    paths.any? ? object&.dig(*paths) : object
  end
end
```

This method behaves very similar to the safe navigation operator `&.` but checks if the object responds to the method before attempting to call it. Invalid method calls return `nil` instead of raising `NoMethodError`.

```ruby
"test".dig(:upcase, :reverse) # "TSET"
"test".dig(:invalid, :chain, :of, :methods) # nil
```

It also delegates to native `dig` implementations for `Array`, `Hash`, or `Struct` objects whenever possible.

```ruby
class Blog
  def posts
    [
      { "title" => "Testing" },
      { "title" => "Example" }
    ]
  end
end

Blog.new.dig(:posts, 1, "title") # "Example"
```

### `Object#destruct`

This method is like a hybrid of all the other native Ruby destructuring methods! Let's define an example object:

```ruby
object = {
  id: 123,
  title: "Hi",
  translations: [
    {
      locale: "es_MX",
      last_edit: "2014-04-14T08:43:37",
      title: "Hola"
    }
  ],
  url: "/hi-123"
}
```

It behaves like `values_at` and looks up values by keys:

```ruby
id, url = object.destruct(:id, :url)
puts id # 123
puts url # "/hi-123"
```

It behaves like `dig` to lookup nested values:

```ruby
title, locale_title = object.destruct(:title, [:translations, 0, :title])
puts title # "Hi"
puts locale_title # "Hola"
```

It accepts hashes to `dig` out nested values as well:

```ruby
locale, title = object.destruct(translations: { 0 => [:locale, :title] })
puts locale # "es_MX"
puts title # "Hola"
```

It accepts a mixture of different argument types:

```ruby
title, last_edit, locale, locale_title = object.destruct(
  :title,
  [:translations, 0, :last_edit],
  translations: { 0 => [:locale, :title] }
)

puts title # "Hi"
puts last_edit # "2014-04-14T08:43:37"
puts locale # "es_MX"
puts locale_title # "Hola"
```

It accepts a block to lookup nested values with a clear and convenient DSL:

```ruby
title, last_edit, locale, url = object.destruct do
  title
  translations[0].last_edit
  translations[0][:locale]
  url
end

puts title # "Hi"
puts last_edit # "2014-04-14T08:43:37"
puts locale # "es_MX"
puts url # "/hi-123"
```

It returns a `Destruct::Hash` object when the return values are not destructured:

```ruby
destructured = object.destruct do
  title
  translations[0].last_edit
  translations[0][:locale]
  url
end

puts destructured.title # "Hi"
puts destructured[:title] # "Hi"
puts destructured[0] # "Hi"

puts destructured.last_edit # "2014-04-14T08:43:37"
puts destructured.locale # "es_MX"

puts destructured.url # "/hi-123"
puts destructured[-1] # "/hi-123"

puts destructured[999] # nil
puts destructured[:missing] # nil
puts destructured.missing # NoMethodError
```

Note that `Destruct::Hash` values are overwritten if there are multiple with the same keys:

```ruby
destructured = object.destruct(:title, [:translations, 0, :title])

puts destructured.title # "Hola"

# This is where the index lookups really come in handy
puts destructured[0] # "Hi"
puts destructured[1] # "Hola"
```

The return value destructuring is done using `Destruct::Hash#to_ary` for implicit `Array` conversion!

## Examples

Let's compare some of the JavaScript [ES6 destructuring examples](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) with their Ruby equivalents.

Note that almost all of these examples simply use native Ruby 2.3+ features!

### Array destructuring

#### Basic variable assignment

```javascript
var foo = ["one", "two", "three"];
var [one, two, three] = foo;

console.log(one); // "one"
console.log(two); // "two"
console.log(three); // "three"
```

```ruby
foo = ["one", "two", "three"]
one, two, three = foo

puts one # "one"
puts two # "two"
puts three # "three"
```

#### Default values

```javascript
var [a=5, b=7] = [1];

console.log(a); // 1
console.log(b); // 7
```

```ruby
a, b = [1]
a ||= 5
b ||= 7

puts a # 1
puts b # 7
```

#### Swapping variables

```javascript
var a = 1;
var b = 3;
[a, b] = [b, a];

console.log(a); // 3
console.log(b); // 1
```

```ruby
a = 1
b = 3
a, b = b, a

puts a # 3
puts b # 1
```

#### Parsing an array returned from a function

```javascript
function f() {
  return [1, 2];
}

var [a, b] = f();

console.log(a); // 1
console.log(b); // 2
```

```ruby
def f
  [1, 2]
end

a, b = f

puts a # 1
puts b # 2
```

#### Ignoring some returned values

```javascript
function f() {
  return [1, 2, 3];
}

var [a, , b] = f();

console.log(a); // 1
console.log(b); // 3
```

```ruby
def f
  [1, 2, 3]
end

a, _, b = f

puts a # 1
puts b # 3
```

#### Ignoring remaining values

```javascript
var [a, b] = [1, 2, 3, 4];

console.log(a); // 1
console.log(b); // 2
```

```ruby
a, b = [1, 2, 3, 4]

puts a # 1
puts b # 2
```

#### Capture remaining values

```javascript
var [a, b, ...c] = [1, 2, 3, 4];

console.log(c); // [3, 4]
```

```ruby
a, b, *c = [1, 2, 3, 4]

puts c.inspect # [3, 4]
```

#### Destructure a nested array

```javascript
const avengers = [
  "Natasha Romanoff",
  ["Tony Stark", "James Rhodes"],
  ["Steve Rogers", "Sam Wilson"]
];

const [blackWidow, [ironMan, warMachine], [cap, falcon]] = avengers;

console.log(warMachine); // "James Rhodes"
```

```ruby
avengers = [
  "Natasha Romanoff",
  ["Tony Stark", "James Rhodes"],
  ["Steve Rogers", "Sam Wilson"]
]

black_widow, iron_man, war_machine, cap, falcon = avengers.flatten

puts war_machine # "James Rhodes"
```

#### Pluck a single value from a deeply nested array

```javascript
const avengers = [
  "Natasha Romanoff",
  [["Tony Stark", "Pepper Potts"], "James Rhodes"],
  ["Steve Rogers", "Sam Wilson"]
];

const [, [[, potts ]]] = avengers;

console.log(potts); // "Pepper Potts"
```

```ruby
avengers = [
  "Natasha Romanoff",
  [["Tony Stark", "Pepper Potts"], "James Rhodes"],
  ["Steve Rogers", "Sam Wilson"]
]

potts = avengers.dig(1, 0, 1)

puts potts # "Pepper Potts"
```

#### Pulling values from a regular expression match

```javascript
var url = "https://developer.mozilla.org/en-US/Web/JavaScript";

var parsedURL = /^(\w+)\:\/\/([^\/]+)\/(.*)$/.exec(url);
console.log(parsedURL); // ["https://developer.mozilla.org/en-US/Web/JavaScript", "https", "developer.mozilla.org", "en-US/Web/JavaScript"]

var [, protocol, fullhost, fullpath] = parsedURL;
console.log(protocol); // "https"
```

```ruby
url = "https://developer.mozilla.org/en-US/Web/JavaScript"

parsed_url = /^(\w+)\:\/\/([^\/]+)\/(.*)$/.match(url).to_a
puts parsed_url.inspect # ["https://developer.mozilla.org/en-US/Web/JavaScript", "https", "developer.mozilla.org", "en-US/Web/JavaScript"]

_, protocol, fullhost, fullpath = parsed_url.to_a
puts protocol # "https"
```

### Object destructuring

#### Basic assignment

```javascript
var o = {p: 42, q: true};
var {p, q} = o;

console.log(p); // 42
console.log(q); // true
```

```ruby
o = { p: 42, q: true }
p, q = o.values_at(:p, :q)

puts p # 42
puts q # true
```

#### Assigning to new variable names

```javascript
var o = {p: 42, q: true};
var {p: foo, q: bar} = o;

console.log(foo); // 42
console.log(bar); // true
```

```ruby
o = { p: 42, q: true }
foo, bar = o.values_at(:p, :q)

puts foo # 42
puts bar # true
```

#### Default values

```javascript
var {a=10, b=5} = {a: 3};

console.log(a); // 3
console.log(b); // 5
```

```ruby
a, b = { a: 3 }.values_at(:a, :b)
a ||= 10
b ||= 5

puts a # 3
puts b # 5
```

#### Setting default function parameters

```javascript
function drawES6Chart({size = "big", cords = { x: 0, y: 0 }, radius = 25} = {}) {
  console.log(size, cords, radius);
  // do some chart drawing
}

drawES6Chart({
  cords: { x: 18, y: 30 },
  radius: 30
});
```

```ruby
def draw_es6_chart(size: "big", cords: { x: 0, y: 0 }, radius: 25)
  puts size, cords, radius
  # do some chart drawing
end

draw_es6_chart(
  cords: { x: 18, y: 30 },
  radius: 30
)
```

#### Nested object and array destructuring

```javascript
var metadata = {
  title: "Scratchpad",
  translations: [
    {
      locale: "de",
      localization_tags: [ ],
      last_edit: "2014-04-14T08:43:37",
      url: "/de/docs/Tools/Scratchpad",
      title: "JavaScript-Umgebung"
    }
  ],
  url: "/en-US/docs/Tools/Scratchpad"
};

var { title: englishTitle, translations: [{ title: localeTitle }] } = metadata;

console.log(englishTitle); // "Scratchpad"
console.log(localeTitle);  // "JavaScript-Umgebung"
```

```ruby
metadata = {
  title: "Scratchpad",
  translations: [
    {
      locale: "de",
      localization_tags: [ ],
      last_edit: "2014-04-14T08:43:37",
      url: "/de/docs/Tools/Scratchpad",
      title: "JavaScript-Umgebung"
    }
  ],
  url: "/en-US/docs/Tools/Scratchpad"
}

english_title, locale_title = metadata.destruct do
  title
  translations[0].title
end

puts english_title # "Scratchpad"
puts locale_title # "JavaScript-Umgebung"
```

#### For of iteration and destructuring

```javascript
var people = [
  {
    name: "Mike Smith",
    family: {
      mother: "Jane Smith",
      father: "Harry Smith",
      sister: "Samantha Smith"
    },
    age: 35
  },
  {
    name: "Tom Jones",
    family: {
      mother: "Norah Jones",
      father: "Richard Jones",
      brother: "Howard Jones"
    },
    age: 25
  }
];

for (var {name: n, family: { father: f } } of people) {
  console.log("Name: " + n + ", Father: " + f);
}

// "Name: Mike Smith, Father: Harry Smith"
// "Name: Tom Jones, Father: Richard Jones"
```

```ruby
people = [
  {
    name: "Mike Smith",
    family: {
      mother: "Jane Smith",
      father: "Harry Smith",
      sister: "Samantha Smith"
    },
    age: 35
  },
  {
    name: "Tom Jones",
    family: {
      mother: "Norah Jones",
      father: "Richard Jones",
      brother: "Howard Jones"
    },
    age: 25
  }
]

people.each do |person|
  n, f = person.destruct(:name, family: :father)
  puts "Name: #{n}, Father: #{f}"
end

# "Name: Mike Smith, Father: Harry Smith"
# "Name: Tom Jones, Father: Richard Jones"
```

#### Pulling fields from objects passed as function parameter

```javascript
function userId({id}) {
  return id;
}

function whois({displayName: displayName, fullName: {firstName: name}}){
  console.log(displayName + " is " + name);
}

var user = {
  id: 42,
  displayName: "jdoe",
  fullName: {
    firstName: "John",
    lastName: "Doe"
  }
};

console.log("userId: " + userId(user)); // "userId: 42"
whois(user); // "jdoe is John"
```

```ruby
def user_id(id:)
  id
end

def whois(display_name:, full_name:)
  puts "#{display_name} is #{full_name[:first_name]}"
end

user = {
  id: 42,
  displayName: "jdoe",
  fullName: {
    firstName: "John",
    lastName: "Doe"
  }
}

puts "userId: #{user_id(user)}" # "userId: 42"
whois(user) # "jdoe is John"
```

#### Computed object property names

```javascript
let key = "z";
let { [key]: foo } = { z: "bar" };

console.log(foo); // "bar"
```

```ruby
key = :z
foo = { z: "bar" }[key]

puts foo # "bar"
```

## Testing

```bash
bundle exec rspec
```

## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so we don't break it in a future version unintentionally.
* Commit, do not mess with the version or history.
* Open a pull request. Bonus points for topic branches.

## Authors

* [Sean Huber](https://github.com/shuber)

## License

[MIT](https://github.com/lendinghome/destruct/blob/master/LICENSE) - Copyright © 2016 LendingHome
