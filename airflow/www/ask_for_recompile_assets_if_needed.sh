#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e

cd "$( dirname "${BASH_SOURCE[0]}" )"

MD5SUM_FILE="static/dist/sum.md5"
readonly MD5SUM_FILE

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NO_COLOR='\033[0m'

md5sum=$(find package.json yarn.lock static/css static/js -type f | sort | xargs md5sum)
old_md5sum=$(cat "${MD5SUM_FILE}" 2>/dev/null || true)
if [[ ${old_md5sum} != "${md5sum}" ]]; then
    if [[ ${START_AIRFLOW:="false"} == "true" && ${USE_AIRFLOW_VERSION:=} == "" ]]; then
        echo
        echo -e "${YELLOW}Recompiling assets as they have changed and you need them for 'start_airflow' command${NO_COLOR}"
        echo
        ./compile_assets.sh
    else
        echo
        echo -e "${YELLOW}WARNING: It seems that the generated assets files do not match the content of the sources.${NO_COLOR}"
        echo "To recompile assets, run:"
        echo ""
        echo "   ./airflow/www/compile_assets.sh"
        echo ""
    fi
else
    echo
    echo -e "${GREEN}No need for www assets recompilation.${NO_COLOR}"
    echo
fi
