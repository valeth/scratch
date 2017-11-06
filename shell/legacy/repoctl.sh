#!/bin/bash

source "debug.sh"


reporoot="${ARCH_REPO_ROOT:-$HOME/Public/repo/arch}"
pkgdir="${ARCH_REPO_PKGS:-$reporoot/pool/packages}"
srcdir="${ARCH_REPO_SRCS:-$reporoot/sources/packages}"
db_ext="${ARCH_REPO_DBEXT:-.db.tar.gz}"
pkg_ext="${ARCH_REPO_PKGEXT:-.pkg.tar.xz}"
architectures=("i686" "x86_64")


function symlinkPackages()
{
  local pkg="$1"
  local dests=($@)

  for dest in ${dests[@]:1}; do
    for file in $(find $pkgdir -type f -name "${pkg}*${pkg_ext}"); do
      msg_info "Symlinking $file to $repodir/$dest/"
      ln -sf "$file" "$repodir/$dest/"
      if [[ $nosign != "nosign" ]]; then
        msg_info "Symlinking ${file}.sig signature to $repodir/$dest/"
        ln -sf "${file}.sig" "$repodir/$dest/"
      fi
    done
  done
}

function getArch()
{
  local pkg="$1"
  for file in $(find "$pkgdir" -type f -name "${pkg}*${pkg_ext}"); do
    echo $(pacman -Qip "$file" |grep "Architecture.*:" |cut -d: -f2)
    break;
  done
}

function readPkglist()
{
  local arch=""

  for pkg in ${pkglist[@]}; do
    arch=$(getArch "$pkg")
    if [[ $arch == "any" ]]; then
      symlinkPackages $pkg ${architectures[@]}
    elif [[ $arch == "i686" ]] || [[ $arch == "x86_64" ]]; then
      symlinkPackages $pkg $arch
    fi
  done
}


function getPkglist()
{
  pkglist=()

  while read line; do
    pkglist+="$line"
  done <<< $(cat $repodir/${repo}.list)
}


function runUpdate()
{
  local db="${repo}${db_ext}"
  local arch=""

  cd $repodir

  for arch in ${architectures[@]}; do
    if [[ $nosign != "nosign" ]]; then
      args+=("--verify" "--sign")
    fi

    if [[ -d $repodir/$arch ]]; then
      cd $repodir/$arch
      repo-add ${args[@]} $db *$pkg_ext
    fi
  done
}

function runRemove()
{
  local db="${repo}${db_ext}"
  local arch=""

  cd $repodir
  for arch in ${architectures[@]}; do
    if [[ $nosign != "nosign" ]]; then
      args+=("--verify" "--sign")
      local rm_sig=1
    fi

    if [[ -d $repodir/$arch ]]; then
      cd $repodir/$arch
      for pkg in ${pkglist[@]}; do
        if repo-remove ${args[@]} $db $pkg; then
          rm $pkg*$pkg_ext
          (($rm_sig)) && rm $pkg*${pkg_ext}.sig
          sed -i /$pkg/d $repodir/${repo}.list
        fi
      done
    fi
  done
}


function initRepo()
{
  repo="$1"
  repodir="$reporoot/$repo/os"
  nosign="$2"

  for arch in ${architectures[@]}; do
    [[ ! -d "$repodir/$arch" ]] && mkdir -p "$repodir/$arch"
  done

  ${EDITOR:-vim} "$repodir/${repo}.list"
  [[ ! -r $repodir/${repo}.list ]] && return 1

  updateRepo "$repo" "$nosign"
}

function updateRepo()
{
  repo="$1"
  repodir="$reporoot/$repo/os"
  nosign="$2"

  getPkglist
  readPkglist
  runUpdate
}

function removeFileFromRepo()
{
  repo=$1
  repodir="$reporoot/$repo/os"
  nosign="$2"
  pkglist=($@)

  if [[ $nosign != "nosign" ]]; then
    pkglist=(${pkglist[@]:1})
  else
    pkglist=(${pkglist[@]:2})
  fi

  runRemove
}

function removePackageFromList()
{
  repo="$1"
  repodir="$reporoot/$repo/os"
  package="$2"

  sed -i "s|$package||g" "$repodir/${repo}.list"
}

function addPackageToList()
{
  repo="$1"
  repodir="$reporoot/$repo/os"
  package="$2"

  echo "Adding $package to $repo"
  echo "$package" >> "$repodir/${repo}.list"
}

function main()
{
  local argv=($@)
  case $1 in
    init)
      initRepo "$2" "$3"
      ;;
    update)
      updateRepo "$2" "$3"
      ;;
    remove)
      removeFileFromRepo "$2" "$3" ${argv[@]:3}
      ;;
    del)
      removePackageFromList "$2" "$3"
      ;;
    add)
      addPackageToList "$2" "$3"
      ;;
  esac
}

main "$@"
