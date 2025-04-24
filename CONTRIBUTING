# Contributing to Druid

Thank you for your interest in contributing to **Druid**! We welcome contributions of all sizes - even small fixes make a big difference.

## Table of Contents
- [How to Report Issues](#how-to-report-issues)
- [Small Fixes](#small-fixes)
- [Larger Contributions](#larger-contributions)
- [Documentation Updates](#documentation-updates)
- [Adding or Updating Examples](#adding-or-updating-examples)
- [Unit Tests](#unit-tests)

## How to Report Issues

Found a bug? Please report it to our [issue tracker](https://github.com/druid-js/druid/issues) with:
- A clear description of the problem
- Steps to reproduce the issue
- Expected vs. actual behavior
- Your environment (Defold version, OS, etc.)

## Small Fixes

**We highly encourage small improvements!** For bug fixes, typo corrections, or minor improvements, you can create a pull request directly to the `master` or `develop` branch.

When making these contributions, you **must**:

1. Update the patch version number in both:
   - `README.md` file (in the dependency section)
   - `game.project` file (in the project section)
2. Add your changes to `wiki/changelog.md`
3. These steps are required to properly tag a new release

**Example of version updates:**

For README.md:
```
# Before
https://github.com/Insality/druid/archive/refs/tags/1.1.0.zip

# After (patch version increased)
https://github.com/Insality/druid/archive/refs/tags/1.1.1.zip
```

For game.project:
```
# Before
[project]
title = Druid
version = 1.1.0

# After (patch version increased)
[project]
title = Druid
version = 1.1.1
```

## Larger Contributions

For new features, major improvements, or complex fixes:

1. Fork the repository
2. Create a branch from `develop`
3. Make your changes
4. Ensure code follows project style guidelines
5. Test your changes thoroughly
6. Submit a pull request to the `develop` branch
7. Include references to any related issues (e.g., "Fixes #123")

Please keep changes focused on addressing specific issues or features, and maintain the existing code style.

## Documentation Updates

To improve documentation:

1. Fork the repository
2. Create a branch for your changes
3. Update the relevant documentation files
4. Submit a pull request to the `master` or `develop` branch

Clear, accurate documentation helps everyone, so documentation improvements are always appreciated!

## Adding or Updating Examples

Examples are vital for helping users understand how to use Druid. Each example should include:

1. A GUI scene with a Druid widget
2. Information about the example in `examples_list.lua`

To add a new example:

1. Create a new GUI file in the `/example/examples` directory
2. Add the example information to `examples_list.lua`
3. Include your GUI template in `/example/druid.gui`
   - Place it inside the proper hierarchy: `root -> container_center -> examples -> widgets`
4. Test your example by running the game
5. Submit a pull request to the `develop` branch

## Unit Tests

Unit tests help ensure Druid works correctly. If you're facing an issue, unit tests can be a good starting point to understand or reproduce it.

All tests are located in the `/test/tests` directory.

To run tests:
1. Set the bootstrap collection to `/test/test.collection`
2. Run the project

To submit new or updated tests:
1. Create a branch for your changes
2. Add or modify tests
3. Verify your tests pass
4. Submit a pull request to the `develop` branch

---

Thank you for contributing to making Druid better for everyone! ❤️
