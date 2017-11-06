#!/usr/bin/env bash

basedir="$(pwd)"
pooldir="${basedir}/pool/packages"
srcdir="${basedir}/sources/packages"
arch="$(uname -m)"
repo="${1}"
repodir="${basedir}/${repo}/os/${arch}"
db_ext='.db.tar.gz'
db="${repo}${db_ext}"

[[ ! -d ${pooldir} ]] && mkdir -p "${pooldir}"
[[ ! -d ${repodir} ]] && mkdir -p "${repodir}"

cd ${pooldir}
for f in ${pooldir}/*; do
    mv -fv $f{.asc,.sig} 2>/dev/null
done
ln -srfv ${pooldir}/*-{any,${arch}}.pkg.tar.xz* ${repodir}

cd ${repodir}
rm -fv ".tmp.${db}.asc" "${repo}.sig"
repo-add --verify --sign -n "${db}" *.pkg.tar.xz
mv -fv ".tmp.${db}.asc" "${db}.sig"
ln -srfv "${db}.sig" "${repo}.sig"
