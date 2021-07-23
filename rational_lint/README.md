# Rational lint

[![pub package](https://img.shields.io/pub/v/rational_lint?style=flat-square)](https://pub.dev/packages/rational_lint)

A heavily strict analysis_options based on popular lint packages on pub.dev

### Installation

Add this package to your `dev_dependencies` in your `pubspec.yaml`:

```yaml
dev_dependencies:
  rational_lint: ^1.0.1
```

and the following to your `analysis_options.yaml` (create one in the root of your project if you don't
have it yet):

```yaml
include: package:rational_lint/analysis_options.yaml

linter:
  rules:
    # ------ Disable individual rules ----- #
    #                 ---                   #
    # Turn off what you don't like.         #
    # ------------------------------------- #

    # Use parameter order as in json response
    always_put_required_named_parameters_first: false
    
    # Util classes are awesome!
    avoid_classes_with_only_static_members: false


    # ------ Enable individual rules ------ #
    #                 ---                   #
    # These rules here are good but too     #
    # opinionated to enable them by default #
    # ------------------------------------- #

    # Make constructors the first thing in every class
    sort_constructors_first: true

    # The new tabs vs. spaces. Choose wisely
    prefer_single_quotes: true
    prefer_double_quotes: true

    # Good packages document everything
    public_member_api_docs: true
    
    # Blindly follow the Flutter code style, which prefers types everywhere
    always_specify_types: true
  
    # Back to the 80s
    lines_longer_than_80_chars: true
```

### Usage

If you're writing apps without developer facing API. i.e. command line tools and Flutter applications, use

```yaml
include: package:rational_lint/analysis_options.yaml

...
```


If you're writing a package with a public API you should use the package version instead

```yaml
include: package:rational_lint/analysis_options_package.yaml

...
```

If you want to use a specific version of lint rules from this package, then use

- For packages
```yaml
include: package:rational_lint/analysis_options_package.major.minor.patch.yaml

...
```

- For tools, applications, etc.
```yaml
include: package:rational_lint/analysis_options.major.minor.patch.yaml

...
```

If you want to enable all rules use

```yaml
include: package:rational_lint/all_rules.yaml

...
```

### Show that you're using `rational_lint`

Add `style: rational_lint` badge to your project's README.md. 

```md
[![style: rational_lint](https://img.shields.io/badge/style-rational__lint-blueviolet)](https://pub.dev/packages/rational_lint)
```

It'll look like this

[![style: rational_lint](https://img.shields.io/badge/style-rational__lint-blueviolet)](https://pub.dev/packages/rational_lint)

