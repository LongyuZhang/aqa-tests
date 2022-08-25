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

set -e
echo "Testing AOT"
aot_failure_msg="AOT header validation failed"
echo "Testtest 1"
java -Xjit:verbose -version >output.txt 2>&1
echo "Testtest 2"
ls
grep "$aot_failure_msg" output.txt
echo "Testtest 3"
fail_count=`grep "$aot_failure_msg" output`
echo "Testtest 4"
if [ -z "$fail_count" ]; then
  echo "Test Passed!"
else
  echo "Testtest 5"
  cat output
  echo -e "\nError: $aot_failure_msg"
  exit 1
fi
echo "Testtest 5"
set +e
