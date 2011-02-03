
if [ -z "$TOOLS_HOME" ]; then
  echo
  echo "TOOLS_HOME is not set. Please set it before running this script."
  echo
  exit 1
fi

if [ ! -e qpid-cpp-0.6.tar.gz ]; then
  wget http://www.apache.org/dist/qpid/0.6/qpid-cpp-0.6.tar.gz
fi
if [ ! -d qpidc-0.6 ]; then
  tar -xf qpid-cpp-0.6.tar.gz
fi
#cat patches/qpid_boost_1_41.patch | patch -d qpidc-0.5 -p 0 -N

cd qpidc-0.6
wget --no-check-certificate -P bindings/qmf/ruby/ http://github.com/apache/qpid/raw/0.6-release/qpid/cpp/bindings/qmf/ruby/ruby.i
BOOST_DIR=$TOOLS_HOME/boostlib/boost_1_41

CPPFLAGS="-I$BOOST_DIR/include"
if [ `lsb_release -cs` = "lucid" ]; then
  CPPFLAGS="$CPPFLAGS -Wno-ignored-qualifiers -fno-strict-aliasing"
fi

./configure CPPFLAGS="$CPPFLAGS" LIBS="-lboost_system" LDFLAGS="-L$BOOST_DIR/Linux_i686" --enable-static=yes --libdir=/usr/lib
make install
