# List Filtering

This Ruby on Rails sample app demonstrates how to render a list of resources
the current user has access to in a web app.
It uses Oso List Filtering to generate this list without
wastefully fetching _all_ authorized resources from the authorization service,
and without making multiple requests to the authorization service.
To minimize the amount of data that needs to be fetched from the authorization service,
some authorization data is stored in this app's own database, and other
authorization data is stored in the authorization service.
[See here](https://www.osohq.com/docs/guides/integrate/filter-lists#list-filtering-with-decentralized-data)
for more information on authorizing lists with distributed data.

## Authorization Policy

The authorization policy is in [oso.polar](config/oso.polar):

```polar
actor User {}

resource Project {
  roles = ["owner"];
}

resource Article {
  permissions = ["view"];
  relations = { project: Project };

  "view" if "owner" on "project";
  "view" if is_public(resource);
}
```

This policy uses three pieces of authorization data:

- Roles on projects: `has_role(User:<user id>, "owner", Project:<project id>)`
- Relations between articles and projects: `has_relation(Article:<article id>, "project", Project:<project id>)`
- Attributes on articles: `is_public(Article:<article id>`

The service presented in this sample app manages `Article`s, which users are granted access to
if they own the `Project` the `Article` belongs to or if the `Article`'s
owner has made the `Article` public.

## Data Model

Imagine that `Article`s are solely the domain of this service, whereas `Project`s
are a concept that may be relevant to multiple services in our system.
Authorization data about `Project`s (the roles that users have on `Project`s)
is centralized in the authorization service so that we may use that information
in other services in the future.
On the other hand, we can keep authorization data about `Article`s
(which `Project` the article belongs to and whether the article is public)
in this service's database.

[The create_articles migration](db/migrate/20240217220544_create_articles.rb)
creates an `articles` table in our PostgreSQL database which stores information
about `Article`s. This includes authorization data as well as
data that's not relevant to authorization, such as the article's title and body.

[oso.yml](config/oso.yml) specifies how to resolve authorization data from the database:

```yaml
facts:
  has_relation(Article:_, String:project, Project:_):
    query: SELECT id, project FROM articles

  is_public(Article:_):
    query: SELECT id FROM articles WHERE is_public

sql_types:
  Article: bigint
```

## Enforcement via Filtering

To enforce our authorization policy, we first set up the Oso Cloud client in [the `oso.rb` initializer](config/initializers/oso.rb):

```ruby
$oso = OsoCloud::Oso.new(
  api_key: ENV['OSO_AUTH'],
  data_bindings: Rails.root.join('config', 'oso.yml')
)
```

We pass the path to `oso.yml` into the client so that Oso Cloud knows that some of the authorization data
is stored in our own system.

In the [Articles controller](app/controllers/articles_controller.rb)
we use Oso's `list_local` method to have Oso Cloud partially evaluate a `list` query
against the data that's stored centrally (roles on `Project`s), and it returns to us a
filter that we can use to finish evaluating the authorization logic against the data
stored in our database.

We pass the filter returned by `list_local` into
Active Record's `where` method to filter the results from the database
down to just the ones the current user is authorized to `view`,
and combine it with some business logic to sort and limit the results:

```ruby
class ArticlesController < ApplicationController
  def index
    @articles = Article.where($oso.list_local(current_user, 'view', 'Article', 'id'))
                      .order(:created_at)
                      .limit(10)
  end
end
```

The final product is that the homepage of our app displays a list of articles
the current user is authorized to view.

## Running the App

1. Make sure you have Ruby on Rails and PostgreSQL installed, and that
   you have your Oso Cloud API Key in the `OSO_AUTH` environment variable.
2. Run `bin/rails db:setup` to set up a PostgreSQL database and seed it with some data.
3. Run `bin/rails oso:seed` to seed your Oso Cloud environment with some data.
4. Run `bin/rails server` to start the Rails server.
5. Open `http://localhost:3000` in your browser.
