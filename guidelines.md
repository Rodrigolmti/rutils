# Flutter Projects Guidelines

This document aims to provide a basic guidelines for the end-user of the EBANX Flutter projects.

## Communication

## Commit convention

All Pull Request titles must follow the [conventional commit message format](https://conventionalcommits.org/):

- `feat: Add new feature`
- `chore: Remove unused file`
- `fix: Fix bug`
- `refactor: Refactor code`
- `style: Improve the style`
- `docs: Update docs`

This is used to automate the versioning of the packages. This rule is valid right know for packages inside the [end-user-flutter-modules] repo.

## Tools

We use [VSCode] as our main development IDE, and we strong recommend you to use it too.

There is some extensions that can make your life easier:

- `Dart data class generator`: Generates dart code like, constructors, copyWiths ...

- `Error Lens`: It highlights common lint error in the IDE

- `Flutter`: Helpful commands to work with flutter and features like dev tools

- `Json to dart model`: Generates [json_serializable] classes by a json string

We use [Figma] as our design platform, all the layouts must follow the EBANX design system, if you see something that is not in conformation with it, you need to talk with the designer that build the layout and understand why he is not following the DS

#### Good practices with layouting:

Always use commas, when you don't put commas at the end of some declaration and you try to ident your code it is not gonna end good. The indentation process use the commas to break the lines and without them the code looks like trash and it is difficult to understand what's happening.

Good:

```dart
Expanded_(child: InkWell_(onTap: _onAddTap,
    child: Container(),
  ),
),
```

Bad:

```dart
Expanded_(child: InkWell_(onTap: _onAddTap, child: Container()))
```

The default value for max characters it is 80, and when you do not use commands your code looks like a hadouken.

Layout dimensions follow a strict pattern of spaces, always 8x, so we starts with 8 and ends at 96

we have a class on our [ebanx-flutter-ds] that is [DSInsets] where you can find all the dimensions, in case that you see a space in figma that is not one of the [DSInsets], you may use the most approximate value and ask for the designer adjust, never create any view component with different values than them.

Examples of usage:

- Padding values

- SizedBox values

- Height and Width values (must used wisely otherwise you may break the view in some devices)

...

always break your view in several components/widgets Flutter is build in a way that makes for us easy to reuse code with widgets. WIP

Avoid long build methods, sometimes we start to build a screen and the build methods gets really big to avoid this we can break our code in several widgets/functions that create a piece of the code like:

Good:

```dart

Widget _buildBalanceView() { ... }

Widget _buildEmailTextFormField { ... }

```

Bad:

```dart

Widget build(BuildContext context) {

A long method body with makes difficult to understand and find any elements

}

```

Be aware with the method `listener` on [BlocConsumer], [BlocListener], etc. This method is called every time that you have a emitted state, so if you have a logic inside of the `listener` method and you don't handle this you may have your logic called multiple times, like show a bottomSheet multiple times for the user.

## Localization and Internationalization,

All the projects must be localized, EBANX has projects that runs on multiple countries and we need to support all of them.

In the [end-user-flutter-modules] we have the package [ebanx_localizations] that is a basic implementation to localize strings.

We have sample codes in [go_latam] and [ebanx_pix] that shows how to use it.

### Name conventions for you translation files

You should give your translations good tags and clear names that indicate exactly what they represent example:

Good:

```json
{
  "sign_up_screen": {
    "email_input_label": "Inform your e-mail",
    "email_input_hint": "johndoe@email.com"
  }
}
```

Bad:

```json
{
  "email_sign_up_input_label": "Inform your e-mail",
  "email_su_ih": "johndoe@email.com"
  ...
}
```

Do not abbreviate names, separate string by context, screen, component, feature ... Remember that people that does not have technical knowledge will make changes in this file, so we need to have clear and good string tags.

Even if your feature does not have the need for translation or localizations you should consider to create the translations file, because doing this you will remove the logic of knowing the strings from your view and will have a more organized code with all of your string in one place, and if you need to change something you know where to look for. And having a good name convention helps you even more to find what you want fast.

## Design System

EBANX has a design system that we build, it is located on [end-user-flutter-modules] inside the package [ebanx-flutter-ds].

all the components are there, including fonts, colors, icons, e`tc. We have a sample project that you can see.

## Architecture

Each project has his own implementations of architecture that are aligned with the team and the project needs, you should check the guideline for your project before start doing something, does not make sense you work with something that you do not understand.

## Refactors

As you float through classes and packages, it is a good practice to leave the code better than you found, but this is tricky because you can not change something that you do not understand (quote citation [architecture]), so if the change to make the code better does impact something that you do not see leave it (if the turtle is above the three someone put it there).

### Packages

### Dependency Injection

### Clean Code

All the projects we tent to build using clean code. In case that you do not know yet here it is a good idea to read the [Clean Code](https://www.freecodecamp.org/news/a-quick-introduction-to-clean-architecture-990c014448d2/) article, there is some good referral links too.

### Use Cases

### Models

Always create a immutable model that is easy to use and easy to test. Mark your models with the [@immutable] tag, and add the const modifier to the constructor.

The [@immutable] helps the compiler to know that this class is immutable.

```dart

@immutable

class User {

...

const User();

```

Use the package Equatable to compare two models and generate toString method.

```dart

class User extends Equatable { ... }

```

Your models should be agnostic, they can not know about view related code for example, (have material imports), they need to be generic enough to we be able to reuse it in any environment.

### Repository

The repository layer serves as a proxy between [data_sources] and [use_cases], here normally we do logics like should I get the cache or api values, user has internet connection... This layer some times may appear like they don't do much, but you can see it as a step for the future, in this case is easier to have it when you need rather need and don't have it.

### Data Sources

The [data_sources], local, remote and etc, are a architecture layer that works like a orchestrator, normally they have instances of network clients, local storage clients and they are responsible for: Call the API, parse the response, map the response, work with entities to persist or get from the storage.

What they don't do: have business logics, access directly services like http, or mysql, we always depend on abstraction layers to decrease the level of coupling on our implementations, so when we need to change something or run in a different environment we will be able to do without big pains.

### Mappers

Your mappers are a important part of the project because is where you get your response model and convert it to your view model. We have this separation because the model that we use on the view doesn't need to know about json related code for example. So in your mapper you will get your response and map to your view model, you can add logics to convert data, parse dates ...

On the mapper you can also validate if your response is valid, and return/throw an error

```dart

class MyMapper {

static List<MyModel> mapFromResponse(MyModelResponse response)

...

```

Using with a static method inside a class seems to be more easy to use than create an instance and inject it into your [data_source]

### Services

### Response models

To parse our response data from the API we use the package [json_serializable] and we have some good practices how to create your response models:

Only set the name attr if your variable name will be different than the one that we receive from the API.

Good:

```dart
@JsonKey(name: 'name')
final String username;
```

Bad:

```dart
@JsonKey(name: 'name')
final String name;
```

If the API has a model with a date field you can use the fromJson to convert the string to a DateTime object, and later only format it to display in the view.

```dart
@JsonKey(fromJson: dateFromString)
final DateTime? expiresAt;
```

Always set a default value for enums and booleans, doing this we avoid te usage of ?? in our mappers and problems with null values.

```dart
@JsonKey(defaultValue: false)
final bool changeAllowed;
```

If you have a type that will be a enum you can directly parse it with the [json_serializable], you just need to add the type of the variable as the enum and provide a default value for it in case that the API change and the app breaks.

```dart
@JsonKey(unknownEnumValue: KeyTypeModel.NONE)
final KeyTypeModel keyType;
```

Try to understand what is nullable and what is not before map the json to a class, doing this we can reduce the numbers of nullable fields in the app. If you are using a API with graphql is easy to identify, just look for the fields that contains !, this means that the field can not be null.

## Lint

It is a good idea to install [error_lens] he helps us to see errors that the VSCode by himself does not show sometimes, each project has a set of lint rules that must be followed, in case that you open a PR the CI will run a set of rules that will analyze your code and prevent you to merge in case that there is a problem with the lint or your tests. Remember the lint is here to help us to have a better code quality in our projects.

You can run the lint locally and avoid the CI to break or have unnecessary comments in your PR. Check in your project how to run the lint locally but the default command is:

```dart
flutter analyze
```

## Unit Test

## Logs

## Analytics

## Think for the future

## Code Style

## Code Review

## Components
