[![Deploy Status](https://github.com/equinor/radix-buildkit-builder/actions/workflows/build-push.yml/badge.svg)](https://github.com/equinor/radix-buildkit-builder/actions/workflows/build-push.yml)

# radix-buildkit-builder

`radix-buildkit-builder` is used by the Radix platform to build container images for hosted applications which have enabled `useBuildKit`.

## Configuration

**Command line arguments**

| Name                      | Required                        | Description                                                                                                                              | 
| ------------------------- | ------------------------------- |------------------------------------------------------------------------------------------------------------------------------------------|
| --registry                | Yes                             | Name of container registry used in --tag                                                                                                 |
| --registry-username       | Yes                             | Username for login to --registry                                                                                                         |
| --registry-password       | Yes                             | Password for --registry-username                                                                                                         |
| --use-cache               | No                              | Enabled caching of image layers                                                                                                          |
| --refresh-cache           | No                              | Refresh caches of image layers                                                                                                           |
| --cache-registry          | When --use-cache flag set       | Name of container registry for cache layers                                                                                              |
| --cache-registry-username | When --use-cache flag set       | Username for login to --cache-registry                                                                                                   |
| --cache-registry-password | When --use-cache flag set       | Password for --cache-registry-username                                                                                                   |
| --cache-repository        | When --use-cache flag set       | Name of repository to store cache layers in                                                                                              |
| --push                    | No                              | Push the built image to --registry                                                                                                       |
| --tag                     | When --push flag set            | Fully qualified tag to push                                                                                                              |
| --cluster-type-tag        | When --push flag set            | Fully qualified tag containing cluster-type to push                                                                                      |
| --cluster-name-tag        | When --push flag set            | Fully qualified tag containing cluster-name to push                                                                                      |
| --secret                  | No                              | Defines a secret that can be mounted in the build process. Can be specified multiple times.                                              |
| --secrets-path            | When --secret flag set          | Path to directory containing files matching secrets defined with --secret                                                                |
| --dockerfile              | Yes                             | Name of Dockerfile to build                                                                                                              |
| --context                 | Yes                             | Path to the --dockerfile                                                                                                                 |
| --auth-file               | No                              | Path and name of file containing credentials in Docker format to use when pulling images when building. Can be specified multiple times. |
| --branch                  | Yes                             | Used as build argument named BRANCH                                                                                                      |
| --git-commit-hash         | Yes                             | Used as build argument named RADIX_GIT_COMMIT_HASH                                                                                       |
| --git-tags                | Yes                             | Used as build argument named RADIX_GIT_TAGS                                                                                              |
| --target-environments     | Yes                             | Used as build argument named TARGET_ENVIRONMENTS                                                                                         |

## Running with read-only root file system

The underlying build engine is buildah. buildah requires write access to the following directories:
- `/home/build`
- `/var/tmp` If this directory does not exist, `build.sh` will try to create it.

## Development Process

The `radix-buildkit-builder` project follows a **trunk-based development** approach.

### 🔁 Workflow

- **External contributors** should:
  - Fork the repository
  - Create a feature branch in their fork

- **Maintainers** may create feature branches directly in the main repository.

### ✅ Merging Changes

All changes must be merged into the `main` branch using **pull requests** with **squash commits**.

The squash commit message must follow the [Conventional Commits](https://www.conventionalcommits.org/en/about/) specification.

## Release Process

Merging a pull request into `main` triggers the **Prepare release pull request** workflow.  
This workflow analyzes the commit messages to determine whether the version number should be bumped — and if so, whether it's a major, minor, or patch change.  

It then creates two pull requests:

- one for the new stable version (e.g. `1.2.3`), and  
- one for a pre-release version where `-rc.[number]` is appended (e.g. `1.2.3-rc.1`).

---

Merging either of these pull requests triggers the **Create releases and tags** workflow.  
This workflow reads the version stored in `version.txt`, creates a GitHub release, and tags it accordingly.

The new tag triggers the **Build and deploy Docker** workflow, which builds and pushes a new container image to `ghcr.io`.

## Contribution

Want to contribute? Read our [contributing guidelines](./CONTRIBUTING.md)

## Security

This is how we handle [security issues](./SECURITY.md)

