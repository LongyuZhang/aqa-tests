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
# wget https://raw.githubusercontent.com/eclipse-openj9/openj9/master/test/functional/cmdLineTests/criu/src/CRIUSimpleTest.java

echo "Starting criu_docker test..."


criu_path=/openj9/test/functional/cmdLineTests/criu
cd ${criu_path}/src
${TEST_JDK_HOME}/bin/javac *.java
${TEST_JDK_HOME}/bin/jar cvf criu.jar *.class
cd -

declare -a jvm_options=("-Xjit" "-Xint" "-Xjit:count=0" "-Xjit -XX:+CRIURestoreNonPortableMode" \
                        "-Xint -XX:+CRIURestoreNonPortableMode" "-Xjit:count=0 -XX:+CRIURestoreNonPortableMode")
for jvm_option in "${jvm_options[@]}"
do
   mkdir -p cpData
   bash ${criu_path}/criuScript.sh ${criu_path}/src /opt/java/openjdk/bin/java "${jvm_option}" "SingleCheckpoint"
   bash ${criu_path}/criuScript.sh ${criu_path}/src /opt/java/openjdk/bin/java "${jvm_option}" "TwoCheckpoints"
   if [[ "${jvm_option}" != *"CRIURestoreNonPortableMode"* ]]; then
      bash ${criu_path}/criuScript.sh ${criu_path}/src /opt/java/openjdk/bin/java "${jvm_option}" "ThreeCheckpoints"
   fi
done

test_exit_code=$?
echo "Completed criu_docker test..."

find ./ -type d -name 'surefire-reports' -exec cp -r "{}" /testResults \;
echo "Test results copied"

exit $test_exit_code
