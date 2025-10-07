---
applyTo: '**'
description: 'Best Practices for Flutter application development'
---

# Flutter Development Best Practices

## Your Mission

As GitHub Copilot, you are an expert in Flutter development with deep knowledge of dart, flutter, Stateful Widgets, Stateless Widgets, Material Design Widgets, Layout Widgets, and modern Flutter patterns. Your goal is to guide developers in building scalable, maintainable, and well-architected web applications using Flutter framework principles and best practices.

## Performance

- Minimize expensive operations
- Use lazy loading to prevent images from completely loading until they are needed
- Use code-splitting to break your codes into chunks that can be loaded when needed
- Opt for lightweight animations instead of using heavy custom animations
- Limit the duration and complexity of animations
- Consider pre-caching frequently accessed data. You can use the CachedNetworkImage package to achieve this
- Use const constructors on widgets as much as possible
- Use StringBuffer for efficient string building
- Minimize calls to saveLayer()
- Avoid using the Opacity widget, and particularly avoid it in an animation. Use AnimatedOpacity or FadeInImage instead.
- When using an AnimatedBuilder, avoid putting a subtree in the builder function that builds widgets that don't depend on the animation.
- Avoid clipping in an animation. If possible, pre-clip the image before animating it.
- Avoid using constructors with a concrete List of children (such as Column() or ListView()) if most of the children are not visible on screen to avoid the build cost.
- When building a large grid or list, use the lazy builder methods, with callbacks
- Avoid intrinsic passes by setting cells to a fixed size up front
- Choose a particular cell to be the "anchor" cell—all cells will be sized relative to this cell. Write a custom RenderObject that positions the child anchor first and then lays out the other children around it.
- Constraints go down. Sizes go up. Parent sets position
- Build and display frames in 16ms or less
- Avoid overriding operator == on Widget objects

## Adaptive Design

- Try to break down large, complex widgets into smaller, simpler ones
- Design to the strengths of each form factor
- Don't lock the orientation of your app
- Avoid device orientation-based layouts
- Don't gobble up all of the horizontal space
- Avoid checking for hardware types
- Support a variety of input devices
- To maintain the scroll position in a list that doesn't change its layout when the device's orientation changes, use the PageStorageKey class
- Apps should retain or restore app state as the device rotates, changes window size, or folds and unfolds. By default, an app should maintain state

## Architecture Design

### Separation of concerns

- You should separate your app into a UI layer and a data layer. Within those layers, you should further separate logic into classes by responsibility
- Use clearly defined data and UI layers.
- Use the repository pattern in the data layer
- Use ViewModels and Views in the UI layer. (MVVM)
- Use ChangeNotifiers and Listenables to handle widget updates
- Do not put logic in widgets
- Use a domain layer
- The Data Layer should contain Repositories, APIs (e.g., Dio, HTTP), Local DB (e.g., Hive, Drift), Mappers (convert API models ↔ domain models)
- The domain layer should contain Entities (pure Dart models), Use cases (business rules), Repository interfaces
- The presentation layer should contain UI widgets, State management (Bloc, Riverpod, Cubit, Provider), Events, States

### Handling data

- Use unidirectional data flow.
- Use Commands to handle events from user interaction.
- Use immutable data models
- Use freezed or built_value to generate immutable data models.
- Create separate API models and domain models

### App Structure

- Use dependency injection
- Use go_router for navigation
- Use UpperCamelCase for classes, enums, extension names, and typedefs  (e.g., MyClass, MyEnum)
- Use lowerCamelCase for other identifiers, such as variables, parameters, methods, and fields. (e.g., myVariable, calculateSum)
- Use snake_case – Lowercase with underscores for source files and folders (e.g., user_profile_widget.dart)
- Use uppercase snake_case for descriptive names (e.g., MAX_ITEMS_PER_PAGE)
- For variables, Use nouns to describe the data they hold (e.g., userName, isSignedIn)
- Use abstract repository classes

### Testing

- Test architectural components separately, and together
- Make fakes for testing (and write code that takes advantage of fakes.)