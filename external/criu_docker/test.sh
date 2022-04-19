#/bin/bash

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

source $(dirname "$0")/test_base_functions.sh
# Set up Java to be used by the quarkus quickstarts test
echo_setup


export TEST_JDK_HOME=$JAVA_HOME
echo "TEST_JDK_HOME is : $TEST_JDK_HOME"

criu -V



wget https://raw.githubusercontent.com/eclipse-openj9/openj9/master/test/functional/cmdLineTests/criu/src/CRIUSimpleTest.java


echo "Starting criu_docker test..."
mkdir cpData
${TEST_JDK_HOME}/bin/javac CRIUSimpleTest.java

${TEST_JDK_HOME}/bin/java -XX:+EnableCRIUSupport CRIUSimpleTest >foo 2>&1

criu restore -D ./cpData --shell-job
cat foo

test_exit_code=$?
echo "Completed criu_docker test..."

find ./ -type d -name 'surefire-reports' -exec cp -r "{}" /testResults \;
echo "Test results copied"

exit $test_exit_code
