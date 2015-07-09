#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ "${MITM_CMD}b" == "b" ] ; then
	MITM_CMD="mitmdump"
fi

"${MITM_CMD}" "--cadir=${DIR}" "-s" "${DIR}/filter.py"
