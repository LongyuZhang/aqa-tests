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
export BUILD_LIST=functional

echo "testtest set up criu environment"
cd /tmp
criu_v=3.16.1
wget https://github.com/checkpoint-restore/criu/archive/refs/tags/v${criu_v}.tar.gz
ls

tar -xzf v${criu_v}.tar.gz
ls
cd criu-${criu_v}
make
make install


criu -V

cd ..
rm -rf v${criu_v}.tar.gz criu-${criu_v}
setcap cap_chown,cap_dac_override,cap_dac_read_search,cap_fowner,cap_fsetid,cap_kill,cap_setgid,cap_setuid,cap_setpcap,cap_net_admin,cap_sys_chroot,cap_sys_ptrace,cap_sys_admin,cap_sys_resource,cap_sys_time,cap_audit_control=eip /usr/local/sbin/criu
# apt install pkg-config nftables iproute2 libcap-dev libnl-3-dev libnet1-dev libnet-cpp-dev libnetxx-dev libaio-dev asciidoc xmlto libbsd-dev libnftables-dev protobuf-c-compiler libprotobuf-dev libprotobuf-c1 libprotobuf-c-dev protobuf-compiler python-protobuf
# git clone https://github.com/xemul/criu.git criu
# cd criu && make clean && make && make install
# setcap cap_sys_time,cap_dac_override,cap_chown,cap_setpcap,cap_setgid,cap_audit_control,cap_dac_read_search,cap_net_admin,cap_sys_chroot,cap_sys_ptrace,cap_fowner,cap_kill,cap_fsetid,cap_sys_resource,cap_setuid,cap_sys_admin=eip /usr/local/sbin/criu: \
# cd ..

cd /aqa-tests
./get.sh

cd /aqa-tests/TKG

set -e

echo "Building functional test material..." 
make compile

echo "Generating make files and running the functional tests" 
make $1
set +e
