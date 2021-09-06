# RUtils WIP

Util classes for common use cases. This repo aims to provide classes to solve common problems in flutter.
problems like:
- Ask location permission and get the user current location
- Format a number to a currency format and locale
- TextFormField for currency formatted values
- Refresh token for DIO
- Abstraction for local storage with SharedPreferences

## Conventions

### Commits / PR 

All Pull Request titles and commits must follow the [conventional commit message format](https://conventionalcommits.org/):

- `feat: Add new feature`
- `chore: Remove unused file`
- `fix: Fix bug`
- `refactor: Refactor code`
- `style: Improve the style`
- `docs: Update docs`

This is used to automate the versioning of the packages.

## Releasing

Run and accept the versioning

```bash
melos version --all
```

Then, push the new version:

```
git push --follow-tags
```

## Packages
- [rutils_core]
- [rutils_currency]
- [rutils_image]
- [rutils_local_storage]
- [rutils_location]
- [rutils_logger]
- [rutils_network]
- [rutils_uikit]

## Contributors
@Rodrigolmti
@danilofuchs
@pedroculque

### Tags

flutter,utils,package
