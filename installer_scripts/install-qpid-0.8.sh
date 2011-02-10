
if [ -z "$TOOLS_HOME" ]; then
  echo
  echo "TOOLS_HOME is not set. Please set it before running this script."
  echo
  exit 1
fi

if [ ! -e qpid-cpp-0.8.tar.gz ]; then
  wget http://www.apache.org/dist/qpid/0.8/qpid-cpp-0.8.tar.gz
fi
if [ ! -d qpidc-0.8 ]; then
  tar -xf qpid-cpp-0.8.tar.gz
fi

cd qpidc-0.8
BOOST_DIR=$TOOLS_HOME/boostlib/boost_1_45

GCC_VERSION_4_3_PLUS=`g++ --version | grep -c 4.3.`
if [ $GCC_VERSION_4_3_PLUS = 1 ]; then
  CPPFLAGS="$CPPFLAGS -Wno-ignored-qualifiers -fno-strict-aliasing"
fi

./configure CPPFLAGS="$CPPFLAGS" LIBS="-lboost_system" LDFLAGS="-L$BOOST_DIR/Linux_i686" --enable-static=yes --libdir=/usr/lib
make
sudo make install
g++ --version | grep 4.4.3