#/bin/bash
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

source $(dirname "$0")/test_base_functions.sh
# Set up Java to be used by the functional test
echo_setup
export TEST_JDK_HOME=$JAVA_HOME
echo "TEST_JDK_HOME is : $TEST_JDK_HOME"
export JDK_VERSION=
echo "JDK_VERSION has been unset, use auto-detect instead."
# export DYNAMIC_COMPILE=true
export BUILD_LIST=functional

cd /aqa-tests
# !!!!testtesttest
./get.sh --openj9_repo "https://github.com/longyuzhang/openj9.git" --openj9_branch "port1"
cd /aqa-tests/TKG

set -e

# echo "testtest2 Building functional test material..."
make compile

echo "testteset3 Generating make files and running the functional tests"
make $1

# get current container ID
# cat /etc/hostname

set +e