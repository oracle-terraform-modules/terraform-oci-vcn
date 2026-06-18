# CONTRIBUTING

[The Oracle Contributor Agreement](https://oca.opensource.oracle.com/)

Oracle welcomes contributions to this repository from anyone.

If you want to submit a pull request to fix a bug or enhance an existing
feature, please first open an issue and link to that issue when you
submit your pull request.

If you have any questions about a possible submission, feel free to open
an issue too.

## Required documentation updates

The documentation for your contribution is as valuable as the code you contribute.

Please ensure the documentation is updated to include any new feature, functionality or fix you contribute. Including documentation changes will make the contribution process far quicker and easier (and the maintainers will love you!).

You should ensure that your documentation changes include the following:

- Add an entry that explains your fix or enhancement to the list of unreleased items in [CHANGELOG](CHANGELOG.md). The maintainers will move your entry to the appropriate version during the release process for that version.
- If your contribution provision new resources, update the README introduction section
- If your contribution adds any new variables, update [docs/terraformoptions](docs/terraformoptions.md) with the variable requirements
- Add your GitHub handler to [CONTRIBUTORS](CONTRIBUTORS.md) under the **CONTRIBUTORS** section
- Don't forget how important the documentation is, especially for examples: we would love it if you updated the `main.tf` and `variables.tf` in the `examples/` folder. A simple example is fine.
- You should also update the code examples in [examples/README](examples/): it contains sample code blocks that probably needs to be updated to reflect your changes

*Notes:*

- We are evaluating options to auto-document as much as possible. Tables on [docs/terraformoptions](docs/terraformoptions.md) may be the first point will we address.

## How to contribute to this repository

Pull requests can be made under
[The Oracle Contributor Agreement (OCA)](https://oca.opensource.oracle.com/).

For pull requests to be accepted, the bottom of your commit message must have
the following line using your name and e-mail address as it appears in the
OCA Signatories list.

```text
Signed-off-by: Your Name <you@example.org>
```

This can be automatically added to pull requests by committing with:

```text
git commit --signoff
```

Only pull requests from committers that can be verified as having
signed the OCA can be accepted.

### Pull request process

1. Fork this repository.
2. Create a branch in your fork to implement the changes. We recommend using
   the issue number as part of your branch name, e.g. `1234-fixes`.
3. Ensure that any documentation is updated with the changes that are required
   by your fix.
4. Ensure that any samples are updated to reflect your new features.
5. Submit the pull request. **Do not leave the pull request blank**. Explain exactly
   what your changes are meant to do and provide simple steps on how to validate
   your changes. Ensure that you reference the issue you created as well.

We will assign the pull request to 2-3 people for review before it is merged. Please engage with the maintainer if there is a clarification request and change suggestion. Pull Request with no follow-up from the creator will be closed.
