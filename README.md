# Git-Tag-Auto
Offer possibility to:
* automatically tag a release in a git repository 
* get the new tag digits available in a git repository 

![Ecedi Agency](https://www.ecedi.fr/theme/images/logo-ecedi-top.png)

## Documentation

A release version is composed by 3 digits like 0.0.0 according to <https://semver.org/>

### git-tag.sh

If you add to a commit message:
* `+semver: breaking` or `+semver: major` it will increase the first one.
* `+semver: feature` or `+semver: minor` it will increase the second digit.
* `+semver: fix` or `+semver: patch` it will increase the third digit.

OR 

If you use the u parameter:
* `./git-tag.sh -u breaking` or `./git-tag.sh -u major` it will increase the first one.
* `./git-tag.sh -u feature` or `./git-tag.sh -u minor` it will increase the second digit.
* `./git-tag.sh -u fix` or `./git-tag.sh -u patch` it will increase the third digit.

### get-tag.sh

u parameter is **mandatory**:

* `breaking` or `major` it will increase the first one.
* `feature` or `minor` it will increase the second digit.
* `fix`or `patch` it will increase the third digit.

It will give you the new tag digits available in a git repository 

## Requirement

Bash and git installed.

## Installation

### git-tag.sh

In a git repository:

```bash
chmod +x git-tag.sh
./git-tag.sh
```
At the end, you can push it on the remote server if needed: `git push --tags`.

### get-tag.sh

In a git repository:

```bash
chmod +x get-tag.sh
./get-tag.sh
```

## Ecedi Community Support

Have a question?  Contact us [Email LD](mailto:ld@ecedi.fr)
