#!/bin/bash
set -e -u -o pipefail

push=0
use_cache=0
git_commit_hash=""
git_tags=""
target_environments=""
secrets=()
auth_files=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --registry)
      registry="$2"
      shift
      ;;
    --registry-username)
      registry_username="$2"
      shift
      ;;
    --registry-password)
      registry_password="$2"
      shift
      ;;
    --use-cache)
      use_cache=1
      ;;
    --cache-registry)
      cache_registry="$2"
      shift
      ;;
    --cache-registry-username)
      cache_registry_username="$2"
      shift
      ;;
    --cache-registry-password)
      cache_registry_password="$2"
      shift
      ;;
    --cache-repository)
      cache_repository="$2"
      shift
      ;;
    --push)
      push=1
      ;;
    --tag)
      tag="$2"
      shift
      ;;
    --cluster-type-tag)
      cluster_type_tag="$2"
      shift
      ;;
    --cluster-name-tag)
      cluster_name_tag="$2"
      shift
      ;;
    --secret)
      secrets+=("$2")
      shift
      ;;
    --secrets-path)
      secrets_path="$2"
      shift
      ;;
    --dockerfile)
      dockerfile="$2"
      shift
      ;;
    --context)
      context="$2"
      shift
      ;;
    --auth-file)
      auth_files+=("$2")
      shift
      ;;
    --branch)
      branch="$2"
      shift
      ;;
    --git-commit-hash)
      git_commit_hash="$2"
      shift
      ;;
    --git-tags)
      git_tags="$2"
      shift
      ;;
    --target-environments)
      target_environments="$2"
      shift
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
  shift
done

if [ ! -d "/var/tmp" ]; then
  mkdir /var/tmp
fi

target_auth_file="/home/build/auth.json"

# Combines multiple input auth-files into one by merging them with jq
# Ref slurp: https://jqlang.github.io/jq/manual/#invoking-jq
# Ref object addition: https://jqlang.github.io/jq/manual/#addition
len=${#auth_files[@]}
if [[ $len -gt 0 ]]; then
  jq_filter=""
  jq_source_files=()
  
  for (( i=0; i<$len; i++ ));
  do
    if [[ $i -gt 0 ]]; then
      jq_filter+=" + "
    fi

    jq_filter+=".[${i}].auths"
    jq_source_files+=("${auth_files[$i]}")
  done

  jq_filter+="| {\"auths\": .}"
  jq --slurp "${jq_filter}" "${jq_source_files[@]}" > $target_auth_file
fi

buildah login \
    --authfile "${target_auth_file}" \
    --username "${registry_username}" \
    --password "${registry_password}" \
    ${registry}

if [[ $use_cache -eq 1 ]]; then
    buildah login \
        --authfile "${target_auth_file}" \
        --username "${cache_registry_username}" \
        --password "${cache_registry_password}" \
        ${cache_registry}
fi

build_args=(
    --authfile "${target_auth_file}"
    --storage-driver=overlay
    --isolation=chroot
    --jobs 0
    --ulimit nofile=4096:4096
    --file "${context}/${dockerfile}"
    --build-arg RADIX_GIT_COMMIT_HASH="${git_commit_hash}"
    --build-arg RADIX_GIT_TAGS="${git_tags}"
    --build-arg BRANCH="${branch}"
    --build-arg TARGET_ENVIRONMENTS="${target_environments}"
)

for s in "${secrets[@]}"
do
    build_args+=(
        --secret id="$s",src="${secrets_path}"/"$s"
    )
done

if [[ $use_cache -eq 1 ]]; then
    build_args+=(
        --layers
        --cache-to="${cache_repository}"
        --cache-from="${cache_repository}"
    )
fi

if [[ $push -eq 1 ]]; then
    build_args+=(
        --tag "${tag}"
        --tag "${cluster_type_tag}"
        --tag "${cluster_name_tag}"
    )
fi

buildah build "${build_args[@]}" "${context}"

if [[ $push -eq 1 ]]; then
    push_args=(
        --authfile "${target_auth_file}"
        --storage-driver=overlay
    )
    buildah push "${push_args[@]}" "${tag}"
    buildah push "${push_args[@]}" "${cluster_type_tag}"
    buildah push "${push_args[@]}" "${cluster_name_tag}"
fi
