# radix-buildkit-builder

`radix-buildkit-builder` is used by the Radix platform to build container images for hosted applications which have enabled `useBuildKit`.

## Configuration

** Command line arguments **

| Name                      | Required                        | Description                                                                                                                              | 
| ------------------------- | ------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| --registry                | Yes                             | Name of container registry used in --tag                                                                                                 |
| --registry-username       | Yes                             | Username for login to --registry                                                                                                         |
| --registry-password       | Yes                             | Password for --registry-username                                                                                                         |
| --use-cache               | No                              | Enabled caching of image layers                                                                                                          |
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

* --auth-file

## Running with read-only root file system

The underlying build engine is buildah. buildah requires write access to the following directories:
- `/home/build`
- `/var/tmp` If this directory does not exist, `build.sh` will try to create it.

