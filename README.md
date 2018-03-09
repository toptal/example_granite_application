# Example Granite Application

This is an example application to cover the basics of using [Granite](https://github.com/toptal/granite)
in a Rails app. For a detailed documentation, check out [the official docs](https://github.com/toptal/granite/blob/master/GETTING_STARTED.md).

## Setup

Download or clone the repository, install ruby and bundler if you haven't already, then:

```bash
bundle install
```

## Running the server

```bash
bundle exec rails s
```

## Running specs

```bash
bundle exec rspec
```

# Understanding the application example

In [apq](/apq) folder you can find the business action usage of Granite.
The application samples just contain one real model persisted in database.

The model persisted is [Book](/app/models/book.rb):

```ruby
> Book # => Book(id: integer, title: string, genres: string)
```

[BooksController](/app/controllers/books_controller.rb) uses the
action [BA::Book::Create](/apq/actions/ba/book/create.rb) combined with the
`current_user` to insert the new book in the database.

And, with a logged user we create some books with a title and a list of genres.

In the controller, the action is instantiated with the current user as performer
and render a feedback depending of action success.

# app/controllers/book_controller.rb
```ruby
class BooksController < ApplicationController
  # POST /books
  def create
    book_action = BA::Book::Create.as(current_user).new(params.require(:book))
    if book_action.perform
      # render success
    else
      # render errors
    end
  end
end
```

The current action and controller are clean because the logic and important behavior from
[BA::Book::BusinessAction](/apq/actions/ba/book/business_action.rb) is where
the magic is:

```ruby
class BA::Book::BusinessAction < BaseAction
  allow_if { performer.is_a?(User) }

  represents :title, of: :subject

  embeds_many :genres

  accepts_nested_attributes_for :genres

  validates :title, presence: true

  private

  def execute_perform!(*)
    subject.genres = genres
    subject.save!
  end
end
```

Let's break down each macro and comprehend how it's being used:

### Policies

You can expect only to execute some action with a user. For purposes, it's only
verifying if it's a user and anything more.

```ruby
allow_if { performer.is_a?(User) }
```

Testing it on the console:

```ruby
BA::Book::Create.as('Fake User').new.allowed? # => false
```

With a real user:

```ruby
BA::Book::Create.as(User.first).new.allowed? # => true
```

> Keep in mind you need to create at least one user to make this example work.

### Attributes

The book has a title and also a list of genres.

```ruby
represents :title, of: :subject
```

Instancing with the title attribute:

```ruby
BA::Book::Create.as(User.first).new(title: "My first book")
# => #<BA::Book::Create genres: #<EmbedsMany []>, title: "My first book">
```

We also have embeded genres:

```
embeds_many :genres
accepts_nested_attributes_for :genres
```

And can be instanced as keyword arguments as the `title` was used before:

```ruby
BA::Book::Create.as(User.first).new(genres: [Genre.new(title: "Science & Fiction")])
# => #<BA::Book::Create genres: #<EmbedsMany [#<Genre title: "Science & Fiction", *id: #<Ac...]>, title: nil>
```

### Validations

You can also be validating your model:

```ruby
validates :title, presence: true
```

And check if the action is valid or not:

```ruby
BA::Book::Create.as(User.first).new().valid? # => false
BA::Book::Create.as(User.first).new(title: "My first book").valid? #  => true
```

And, with a logged user we create some books with a title and a list of genres.

In the controller, the action is instantiated with the current user as performer
and render a feedback depending of the action response.

## Subject

The `subject` needs to be memoized because we're not using a persistent record
in `BA::Book::Create`:

```ruby
class BA::Book::Create < BA::Book::BusinessAction
  def subject
    @subject ||= ::Book.new
  end
end
```

While we have a special macro for `subject` in the action
[BA::Book::Update](/apq/actions/ba/book/update.rb), just referring it's a book.

```ruby
class BA::Book::Update < BA::Book::BusinessAction
  subject :book
end
```

## Performing the action

The method `execute_perform` contains the logic that needs to be executed when
the book is updated or created.

```ruby
def execute_perform!(*)
  subject.genres = genres
  subject.save!
end
```

Note that the `title` is not being assigned explicitly because it's using
`represents` and [active_data](https://github.com/pyromaniac/active_data)
is doing the assignment behind the scenes.

